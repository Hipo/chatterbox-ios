//
//  ChatViewController.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 13/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit


public protocol ChatInterfaceViewControllerDelegate: class {
    
    func chatInterfaceViewControllerDidFailLoadingChatThread(with error: Error)
    
    func chatInterfaceViewControllerDidFailLoadingChatMessages(with error: Error)
    
    func chatInterfaceViewControllerShouldSendChatMessage(with text: String,
                                                          for chatThread: ChatThreadRepresentable?) -> Bool
    
    func chatInterfaceViewControllerDidFailSendingChatMessage(with error: Error)
}

extension ChatInterfaceViewControllerDelegate {
    func chatInterfaceViewControllerDidFailLoadingChatThread(with error: Error) {
    }
    
    func chatInterfaceViewControllerDidFailLoadingChatMessages(with error: Error) {
    }
    
    func chatInterfaceViewControllerShouldSendChatMessage(with text: String,
                                                          for chatThread: ChatThreadRepresentable?) -> Bool {
        return true
    }
    
    func chatInterfaceViewControllerDidFailSendingChatMessage(with error: Error) {
    }
}


open class ChatInterfaceViewController
    <T: ChatThreadRepresentable, U: ChatMessageRepresentable>:
UIViewController,
ListAdapterDataSource,
ListDisplayDelegate {
    
    public typealias ChatInterfaceDataProvider = BaseChatInterfaceDataProvider<T, U>
    
    public typealias ChatInterfaceWebSockeProvider = BaseChatInterfaceWebSocketProvider<T>
    
    // MARK: LayoutComponents
    
    private(set) lazy var collectionView: ChatInterfaceCollectionView = ChatInterfaceCollectionView()
    
    var chatInputAccessoryView: ChatInputAccessoryRepresentable {
        get {
            return collectionView.chatInputAccessoryView
        }
        set {
            collectionView.chatInputAccessoryView = newValue
        }
    }
    
    // MARK: Variables
    
    let dataProvider: ChatInterfaceDataProvider
    let webSocketProvider: ChatInterfaceWebSockeProvider
    
    fileprivate lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var isLoadingChatMessages = false
    
    var isScrollTopToLoadEnabled = false
    
    var isNewChatThread: Bool {
        return dataProvider.chatThread == nil
    }
    
    var scrollTopToLoadMoreLastChatMessagesThreshold: Int {
        return 5
    }
    
    var keyboardAccessoryHeight: CGFloat?
    var keyboardAccessoryAnimationDuration: Double?
    
    weak var delegate: ChatInterfaceViewControllerDelegate?
    
    // MARK: Initialization
    
    required public init(dataProvider: ChatInterfaceDataProvider,
                  webSocketProvider: ChatInterfaceWebSockeProvider) {
        self.dataProvider = dataProvider
        self.webSocketProvider = webSocketProvider
        
        if !dataProvider.isNewChatThread {
            isScrollTopToLoadEnabled = true // To show loader immediately at first fetch.
        }
        
        super.init(nibName: nil, bundle: nil)
        
        startWatchingNotifications()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopObservingNewChatMessages()
        stopWatchingNotifications()
    }
    
    // MARK: Notifications
    
    func startWatchingNotifications() {
        startWatchingKeyboardNotifications()
        startWatchingAppLifeCycleNotifications()
    }
    
    private func startWatchingKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceive(keyboardWillShow:)),
            name: Notification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceive(keyboardWillHide:)),
            name: Notification.Name.UIKeyboardWillHide,
            object: nil)
    }
    
    private func startWatchingAppLifeCycleNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceive(applicationWillEnterForeground:)),
            name: Notification.Name.UIApplicationWillEnterForeground,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceive(applicationDidEnterBackground:)),
            name: Notification.Name.UIApplicationDidEnterBackground,
            object: nil)
    }
    
    func stopWatchingNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: LifeCycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        setChatInputEnabled(true)
        
        setupAdapter()
        setupChatThread()
        
        updateInsets()
    }
    
    func setChatInputEnabled(_ isEnabled: Bool) {
        if isEnabled {
            collectionView.becomeFirstResponder()
            collectionView.chatInputAccessoryView.delegate = self
        } else {
            collectionView.chatInputAccessoryView.delegate = nil
            collectionView.chatInputAccessoryView.textView.resignFirstResponder()
            collectionView.resignFirstResponder()
        }
    }
    
    private func setupChatThread() {
        setupListeners()
        
        let initializeChatThread: () -> Void = {
            [weak self] in
            
            self?.loadChatMessages()
            self?.observeNewChatMessages()
        }
        
        if dataProvider.isChatThreadReady {
            initializeChatThread()
            return
        }
        
        guard let faultChatThread = dataProvider.chatThread,  let token = faultChatThread.token else {
            return
        }
        
        dataProvider.loadChatThread(with: token) { [weak self] (chatThread, error) in
            guard let error = error else {
                self?.dataProvider.chatThread = chatThread
                self?.webSocketProvider.chatThread = chatThread
                
                initializeChatThread()
                
                if let chatThread = chatThread {
                    NotificationCenter.default.post(
                        name: Notification.Name.ChatThreadDidUpdateNotification,
                        object: nil,
                        userInfo: [ChatThreadUserInfoKey: chatThread])
                }
                
                return
            }
            
            self?.delegate?.chatInterfaceViewControllerDidFailLoadingChatThread(with: error)
        }
    }
    
    private func setupListeners() {
        dataProvider.listener = self
        webSocketProvider.listener = self
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNewChatThread {
            enableTyping()
        }
    }
    
    private func enableTyping() {
        chatInputAccessoryView.textView.becomeFirstResponder()
    }
    
    // MARK: Layout
    
    func setupLayout() {
        prepareCollectionViewLayout()
    }
    
    func prepareCollectionViewLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // Otherwise, i am seeing reversed transform for collection view cells.
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func updateInsets(animated: Bool = false) {
        var topInset: CGFloat = 0.0
        
        if let keyboardAccessoryHeight = keyboardAccessoryHeight {
            topInset = keyboardAccessoryHeight
        } else {
            topInset = chatInputAccessoryView.view.intrinsicContentSize.height // Custom chat input accessory views should support intrinsicContentSize.
        }
        
        var contentInset = collectionView.contentInset
        let previousTopInset = contentInset.top
        contentInset.top = topInset
        
        var scrollContentInset = contentInset
        scrollContentInset.right = view.bounds.width - 8.5 // Scroll bar is inverted horizontally when collection view is inverted vertically.
        
        var contentOffset = collectionView.contentOffset
        
        if animated && contentOffset.y != -topInset { // If offset is right position, no scroll animation.
            let duration = keyboardAccessoryAnimationDuration ?? 0.25
            
            UIView.animate(withDuration: duration, animations: { 
                self.collectionView.contentInset = contentInset
                self.collectionView.scrollIndicatorInsets = scrollContentInset
            })
            
            contentOffset.y -= topInset - previousTopInset
            collectionView.contentOffset = contentOffset
        } else {
            collectionView.contentInset = contentInset
            collectionView.scrollIndicatorInsets = scrollContentInset
        }
    }
    
    // MARK: ListAdapterDataSource
    // This protocol can not be conformed by an extension of a generic class.
    
    public func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var allObjects = dataProvider.chatMessages as [ListDiffable]
        
        if isScrollTopToLoadEnabled {
            allObjects.append((ChatMessageLoaderController.replacementToken as ListDiffable))
        }
        
        return allObjects
    }
    
    public func listAdapter(_ listAdapter: ListAdapter,
                     sectionControllerFor object: Any) -> ListSectionController {
        if let messageLoader = object as? String, messageLoader == ChatMessageLoaderController.replacementToken {
            return ChatMessageLoaderController()
        }
        
        if let chatMessage = object as? U {
            let chatMessageDataController = dataProvider.createChatMessageDataController(for: chatMessage)
            
            if isScrollTopToLoadEnabled {
                chatMessageDataController.displayDelegate = self
            }
            
            return chatMessageDataController
        }
        
        return ListSectionController()
    }
    
    public func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: ListDisplayDelegate
    
    public func listAdapter(_ listAdapter: ListAdapter,
                     willDisplay sectionController: ListSectionController) {
        if !dataProvider.canLoadMoreChatMessages {
            isScrollTopToLoadEnabled = false // No need to trigger delegate method every scroll.
            performUpdates(animated: false) // To remove loader cell at top.
            
            return
        }
        
        if isLoadingChatMessages {
            return
        }
        
        let numberOfChatMessages = listAdapter.objects().count - 1 // 1 for loader cell
        
        if numberOfChatMessages - sectionController.section == scrollTopToLoadMoreLastChatMessagesThreshold {
            loadChatMessages(previous: true)
        }
    }
    
    public func listAdapter(_ listAdapter: ListAdapter,
                     willDisplay sectionController: ListSectionController,
                     cell: UICollectionViewCell,
                     at index: Int) {
    }
    
    public func listAdapter(_ listAdapter: ListAdapter,
                     didEndDisplaying sectionController: ListSectionController) {
    }
    
    public func listAdapter(_ listAdapter: ListAdapter,
                     didEndDisplaying sectionController: ListSectionController,
                     cell: UICollectionViewCell,
                     at index: Int) {
    }
    
    // MARK: Notifications+Action
    
    func didReceive(keyboardWillShow notification: Notification) {
        if UIApplication.shared.applicationState != UIApplicationState.active {
            return
        }
        
        guard let userInfo = notification.userInfo else {
                return
        }
        
        let kbFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue
        
        /* Input accessory height + keyboard height when text view is first responder, 
         input accessory height when collection view is first responder. 
         This action will be triggered when input accessory view frame is changed. */
        keyboardAccessoryHeight = kbFrame?.cgRectValue.size.height
        
        let kbAnimationDurationInfo = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber
        let kbAnimationDuration = kbAnimationDurationInfo?.doubleValue
        
        keyboardAccessoryAnimationDuration = kbAnimationDuration
        
        updateInsets(animated: !collectionView.isFirstResponder)
    }
    
    func didReceive(keyboardWillHide notification: Notification) {
        if UIApplication.shared.applicationState != UIApplicationState.active {
            return
        }
        
        keyboardAccessoryHeight = nil
        
        updateInsets()
    }
    
    func didReceive(applicationWillEnterForeground notification: Notification) {
        dataProvider.chatMessages.removeAll()
        reloadData()
        
        isScrollTopToLoadEnabled = true // Reset values.
        
        loadChatMessages()
        observeNewChatMessages()
    }
    
    func didReceive(applicationDidEnterBackground notification: Notification) {
        stopObservingNewChatMessages()
    }
}

// MARK: Data 

extension ChatInterfaceViewController {
    fileprivate func setupAdapter() {
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    fileprivate func loadChatMessages(previous: Bool = false) {
        isLoadingChatMessages = true
        dataProvider.loadChatMessages(previous: previous)
    }
    
    fileprivate func observeNewChatMessages() {
        webSocketProvider.openConnection()
    }
    
    fileprivate func stopObservingNewChatMessages() {
        webSocketProvider.closeConnection()
    }
}

// MARK: API

extension ChatInterfaceViewController {
    func performUpdates(animated: Bool,
                        onCompletion completion: (() -> Void)? = nil) {
        adapter.performUpdates(animated: animated, completion: { _ in
            completion?()
        })
    }
    
    func reloadData(onCompletion completion: (() -> Void)? = nil) {
        adapter.reloadData { (_) in
            completion?()
        }
    }
    
    func scrollToLastReceivedChatMessage(animated: Bool) {
        let contentInset = collectionView.contentInset
        collectionView.setContentOffset(CGPoint(x: -contentInset.left, y: -contentInset.top), animated: animated)
    }
}

// MARK: BaseChatInterfaceDataProviderListener

extension ChatInterfaceViewController: BaseChatInterfaceDataProviderListener {
    public func chatInterfaceDataProviderDidReloadChatMessages(animated: Bool) {
        isLoadingChatMessages = false
        isScrollTopToLoadEnabled = dataProvider.canLoadMoreChatMessages
        reloadData()
    }
    
    public func chatInterfaceDataProviderDidLoadNextChatMessages(animated: Bool) {
        isLoadingChatMessages = false
        isScrollTopToLoadEnabled = dataProvider.canLoadMoreChatMessages
        performUpdates(animated:animated)
    }
    
    public func chatInterfaceDataProviderDidLoadNewChatMessage(animated: Bool) {
        scrollToLastReceivedChatMessage(animated: false)
        performUpdates(animated:animated)
    }
    
    public func chatInterfaceDataProviderDidFailLoadChatMessages(with error: Error) {
        delegate?.chatInterfaceViewControllerDidFailLoadingChatMessages(with: error)
    }
}

// MARK: ChatInterfaceWebSocketProviderListener

extension ChatInterfaceViewController: ChatInterfaceWebSocketProviderListener {
    public func webSocketConnectionDidReceive(_ json: [String : Any]?) {
        guard let validJson = json else {
            return
        }
        
        dataProvider.loadLastReceivedChatMessage(for: validJson)
    }
}

// MARK: ChatInputAccessoryDelegate

extension ChatInterfaceViewController: ChatInputAccessoryDelegate {
    public func chatInputAccessoryDidTapSendButton(_ chatInputAccessoryView: ChatInputAccessoryRepresentable) {
        guard let text = chatInputAccessoryView.textView.text else {
            return
        }
        
        if text.isEmpty {
            return
        }
        
        if let delegate = delegate,
            !delegate.chatInterfaceViewControllerShouldSendChatMessage(with: text, for: dataProvider.chatThread) {
            return
        }
        
        sendChatMessage(with: text)
    }
    
    func sendChatMessage(with text: String) {
        let trimmedText = text.trimmingCharactersAtTail(CharacterSet.whitespacesAndNewlines)
        let chatDraftMessage = ChatDraftMessage(type: .text(trimmedText))
        
        self.chatInputAccessoryView.isSendingText = true
        
        let sendingMessageCompletionClosure: ((Error?) -> Void) = {
            [weak self] (error) in
            
            self?.chatInputAccessoryView.isSendingText = false
            
            if error == nil {
                self?.chatInputAccessoryView.textView.text = nil
                self?.chatInputAccessoryView.textViewTextDidChange()
            }
        }
        
        if isNewChatThread {
            dataProvider.createChatThread(with: chatDraftMessage, onCompletion: {
                [weak self] (chatThread, chatMessage, error) in
                
                guard let error = error else {
                    self?.dataProvider.chatThread = chatThread
                    self?.webSocketProvider.chatThread = chatThread
                    
                    if let chatMessage = chatMessage {
                        self?.dataProvider.load(chatMessage)
                    }
                    
                    self?.observeNewChatMessages()
                    
                    sendingMessageCompletionClosure(nil)
                    
                    if let chatThread = chatThread {
                        NotificationCenter.default.post(
                            name: Notification.Name.NewChatThreadDidCreateNotification,
                            object: nil,
                            userInfo: [ChatThreadUserInfoKey: chatThread])
                    }
                    
                    return
                }
                
                self?.delegate?.chatInterfaceViewControllerDidFailSendingChatMessage(with: error)
            })
        } else {
            dataProvider.send(chatDraftMessage, onCompletion: { [weak self] (error) in
                sendingMessageCompletionClosure(error)
                
                if let error = error {
                    self?.delegate?.chatInterfaceViewControllerDidFailSendingChatMessage(with: error)
                }
            })
        }
    }
}

