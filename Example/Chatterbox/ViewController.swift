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
        
        let dataProvider = DataProvider(thread: ChatThreadable())
        let socketProvider = SocketProvider(thread: ChatThreadable())
        
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
    
    // MARK: Variables
    
    init(thread: ChatThreadable?) {
        super.init(chatThread: thread)
    }
    
    override func loadChatMessages(previous: Bool) {
        
    }
    
    override func send(_ chatDraftMessage: ChatDraftMessage,
                       onCompletion completion: ((Error?) -> Void)?) {
        
    }
}

class SocketProvider: BaseChatInterfaceWebSocketProvider<ChatThreadable> {
    init(thread: ChatThreadable?) {
        super.init(chatThread: thread)
    }
    
    override func setupConnection() {
        
    }
    
    override func openConnection() {
        
    }
    
    override func closeConnection() {
        
    }
    
}
