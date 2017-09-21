//
//  ChatThreadDataProvider.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 13/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit
import IGListKit


extension Notification.Name {
    static let NewChatThreadDidCreateNotification = Notification.Name("Chat.Notification.Name.NewChatThreadDidCreate")
    static let ChatThreadDidUpdateNotification = Notification.Name("Chat.Notification.Name.ChatThreadDidUpdate")
    // It will be fired when user send a message himself/herself.
    static let NewChatMessageDidReceiveNotification = Notification.Name("Chat.Notification.Name.NewChatMessageDidReceive")
}

let ChatThreadUserInfoKey = "Chat.Notification.UserInfo.ChatThread"
let ChatMessageUserInfoKey = "Chat.Notification.UserInfo.ChatMessage"


protocol BaseChatInterfaceDataProviderListener: class {
    
    func chatInterfaceDataProviderDidReloadChatMessages(animated: Bool)
    
    func chatInterfaceDataProviderDidLoadNextChatMessages(animated: Bool)
    
    func chatInterfaceDataProviderDidLoadNewChatMessage(animated: Bool)
    
    func chatInterfaceDataProviderDidFailLoadChatMessages(with error: Error)
}

extension BaseChatInterfaceDataProviderListener {
    func chatInterfaceDataProviderDidFailLoadChatMessages(with error: Error) {
    }
}


enum ChatThreadStatus {
    
    case unstarted
    
    case running
    
    case suspended // It should be in suspended until data related to chat thread is loaded.
}


class BaseChatInterfaceDataProvider<T: ChatThreadRepresentable, U: ChatMessageRepresentable> {
    
    typealias ChatThread = T
    typealias ChatMessage = U
    
    typealias CompletionClosure = (Error?) -> Void
    
    typealias ChatThreadCreationCompletionClosure = (ChatThread?, ChatMessage?, Error?) -> Void
    
    typealias ChatThreadLoadCompletionClosure = (ChatThread?, Error?) -> Void
    
    // MARK: Variables
    
    var chatThread: ChatThread? {
        didSet {
            self.chatThreadStatus = chatThread.map({ $0.isFault ? .suspended : .running }) ?? .unstarted
        }
    }
    var chatThreadStatus: ChatThreadStatus
    
    var chatMessages = [ChatMessage]()
    
    var isNewChatThread: Bool {
        return chatThreadStatus == .unstarted
    }
    
    var isChatThreadReady: Bool {
        return chatThreadStatus == .running
    }
    
    var canLoadMoreChatMessages: Bool {
        return true
    }
    
    weak var listener: BaseChatInterfaceDataProviderListener?
    
    // MARK: Initialization
    
    init(chatThread: ChatThread?) {
        self.chatThread = chatThread
        self.chatThreadStatus = chatThread.map({ $0.isFault ? .suspended : .running }) ?? .unstarted
    }
    
    // MARK: API
    
    func createChatThread(with draft: ChatDraftMessage,
                          onCompletion completion: ChatThreadCreationCompletionClosure?) {
        fatalError("This method must be implemented by subclasses.")
    }
    
    func loadChatThread(with token: String,
                        onCompletion completion: ChatThreadLoadCompletionClosure?) {
        fatalError("This method must be implemented by subclasses.")
    }
    
    func loadLastReceivedChatMessage(for json: [String: Any]) {
        fatalError("This method must be implemented by subclasses.")
    }
    
    func load(_ chatMessage: ChatMessage) {
        chatMessages.insert(chatMessage, at: 0)
        listener?.chatInterfaceDataProviderDidLoadNewChatMessage(animated: true)
        
        notifyForNewlyReceived(chatMessage)
    }
    
    private func notifyForNewlyReceived(_ chatMessage: ChatMessage) {
        guard let chatThread = chatThread else {
            return
        }
        
        NotificationCenter.default.post(
            name: Notification.Name.NewChatMessageDidReceiveNotification,
            object: self,
            userInfo: [ChatThreadUserInfoKey: chatThread,
                       ChatMessageUserInfoKey: chatMessage])
    }
    
    // This method should trigger chat view controller to update isLoadingChatMessages value.
    func loadChatMessages(previous: Bool) {
        fatalError("This method must be implemented by subclasses.")
    }
    
    func loadChatMessagesWasCompleted(previous: Bool, with error: Error?) {
        guard let error = error else {
            if previous {
                listener?.chatInterfaceDataProviderDidLoadNextChatMessages(animated: false)
            } else {
                listener?.chatInterfaceDataProviderDidReloadChatMessages(animated: true)
            }
            
            return
        }
        
        listener?.chatInterfaceDataProviderDidFailLoadChatMessages(with: error)
    }

    func createChatMessageDataController(for chatMessage: ChatMessage) -> ChatMessageDataController {
        switch chatMessage.type {
        case .none:
            return ChatMessageDataController()
        case .text, .attributedText:
            return ChatTextMessageDataController()
        }
    }
    
    func send(_ chatDraftMessage: ChatDraftMessage,
              onCompletion completion: CompletionClosure?) {
        fatalError("This method must be implemented by subclasses.")
    }
}
