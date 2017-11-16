//
//  ViewController.swift
//  Chatterbox
//
//  Created by Hakan Demiröz on 09/21/2017.
//  Copyright (c) 2017 Hakan Demiröz. All rights reserved.
//

import UIKit
import Chatterbox

class ViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        
        let chatThread = ChatThreadable()
        
        let dataProvider = DataProvider(thread: chatThread)
        let socketProvider = SocketProvider(thread: chatThread)
        
        let vc = ChatViewController(dataProvider: dataProvider,
                                    webSocketProvider: socketProvider)
        
        vc.chatInputAccessoryView = FLChatInputAccessoryView()
        
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        
        vc.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

class ChatViewController: ChatInterfaceViewController <ChatThreadable, ChatMessage>, UITextViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
    }
    
    private func setupDelegates() {
        chatInputAccessoryView.textView.delegate = self
    }
    
    // MARK: UITextViewDelegate
    // This protocol can not be conformed by an extension of a generic class.
    
    func textViewDidChange(_ textView: UITextView) {
        chatInputAccessoryView.textViewTextDidChange()
    }
    
}

class DataProvider: BaseChatInterfaceDataProvider<ChatThreadable, ChatMessage> {
    override var canLoadMoreChatMessages: Bool {
        return false
    }
    
    init(thread: ChatThreadable?) {
        super.init(chatThread: thread)
    }
    
    override func loadChatMessages(previous: Bool) {
        loadChatMessagesWasCompleted(previous: previous, with: nil)
    }
    
    override func createChatMessageDataController(for chatMessage: ChatMessage) -> ChatMessageDataController {
        return DataController()
    }
    
    
    override func send(_ chatDraftMessage: ChatDraftMessage,
                       onCompletion completion: ((Error?) -> Void)?) {
    
        let chatMessage = ChatMessage()
        
        if let message = chatDraftMessage.serialized()["text"] as? String {
            chatMessage.text = message
        } else {
            chatMessage.text = NSLocalizedString("Unknow message type", comment: "")
        }
        
        completion?(nil)
        
        //Insert chat message to chat thread
        load(chatMessage)
    }
}

class SocketProvider: BaseChatInterfaceWebSocketProvider<ChatThreadable> {
    init(thread: ChatThreadable?) {
        super.init(chatThread: thread)
    }
    
    override var chatServerUrl: String? {
        return nil
    }
    
    override func setupConnection() {
        
    }
    
    override func openConnection() {
        
    }
    
    override func closeConnection() {
        
    }
}

class DataController: ChatMessageDataController {
    
    override init() {
        
        super.init()
        
        inset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 10, right: 0.0)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        let height: CGFloat = 100.0
        
        let width: CGFloat = UIScreen.main.bounds.width - 20.0
        
        return CGSize(width: width, height: height.rounded(.up))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let chatMessage = chatMessage else {
            return super.cellForItem(at: index)
        }
        
        if chatMessage.isMe {
            return dequeueMyCellForItem(at: index, with: chatMessage)
        }
        
        return dequeueFriendCellForItem(at: index, with: chatMessage)
    }
    
    private func dequeueMyCellForItem(at index: Int,
                                      with chatMessage: ChatMessageRepresentable) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: MyCell.self,
            for: self,
            at: index) as? MyCell else {
                return super.cellForItem(at: index)
        }
        
        switch chatMessage.type {
        case .text(let text):
            cell.messageView.textLabel.text = text
        case .attributedText(let attributedText):
            cell.messageView.textLabel.attributedText = attributedText
        default:
            break
        }

        return cell
    }
    
    private func dequeueFriendCellForItem(at index: Int,
                                          with chatMessage: ChatMessageRepresentable) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: FriendCell.self,
            for: self,
            at: index) as? FriendCell else {
                return super.cellForItem(at: index)
        }
        
        switch chatMessage.type {
        case .text(let text):
            cell.messageView.textLabel.text = text
        case .attributedText(let attributedText):
            cell.messageView.textLabel.attributedText = attributedText
        default:
            break
        }
        
        return cell
    }
}
