//
//  ChatInterfaceSocketProvider.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 19/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation


protocol ChatInterfaceWebSocketProviderListener: class {
    
    func webSocketConnectionDidOpen()
    
    func webSocketConnectionDidClose()
    
    func webSocketConnectionDidFail(with error: Error?)
    
    func webSocketConnectionDidReceive(_ json: [String: Any]?)
}

extension ChatInterfaceWebSocketProviderListener {
    
    func webSocketConnectionDidOpen() {
    }
    
    func webSocketConnectionDidClose() {
    }
    
    func webSocketConnectionDidFail(with error: Error?) {
    }
}


enum WebSocketConnectionStatus {
    case disconnected
    case connecting
    case connected
}


class BaseChatInterfaceWebSocketProvider<T: ChatThreadRepresentable>: NSObject {
    
    typealias ChatThread = T
    
    // MARK: Variables
    
    var chatThread: ChatThread?
    
    var chatServerUrl: String? {
        fatalError("This variable must be implemented by subclasses.")
    }
    
    var connectionStatus: WebSocketConnectionStatus {
        return WebSocketConnectionStatus.disconnected
    }
    
    weak var listener: ChatInterfaceWebSocketProviderListener? // If multiple objects needs to be listener, use notification instead of delegate approach.
    
    // MARK: Initialization
    
    init(chatThread: ChatThread?) {
        self.chatThread = chatThread
    }
    
    // MARK: API
    
    func setupConnection() {
        fatalError("This method must be implemented by subclasses.")
    }
    
    func openConnection() {
        fatalError("This method must be implemented by subclasses.")
    }
    
    func closeConnection() {
        fatalError("This method must be implemented by subclasses.")
    }
}
