//
//  ChatInterfaceSocketProvider.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 19/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation


public protocol ChatInterfaceWebSocketProviderListener: class {
    
    func webSocketConnectionDidOpen()
    
    func webSocketConnectionDidClose()
    
    func webSocketConnectionDidFail(with error: Error?)
    
    func webSocketConnectionDidReceive(_ json: [String: Any]?)
}

extension ChatInterfaceWebSocketProviderListener {
    
    public func webSocketConnectionDidOpen() {
    }
    
    public func webSocketConnectionDidClose() {
    }
    
    public func webSocketConnectionDidFail(with error: Error?) {
    }
}


public enum WebSocketConnectionStatus {
    case disconnected
    case connecting
    case connected
}


open class BaseChatInterfaceWebSocketProvider<T: ChatThreadRepresentable>: NSObject {
    
    public typealias ChatThread = T
    
    // MARK: Variables
    
    open var chatThread: ChatThread?
    
    var chatServerUrl: String? {
        fatalError("This variable must be implemented by subclasses.")
    }
    
    var connectionStatus: WebSocketConnectionStatus {
        return WebSocketConnectionStatus.disconnected
    }
    
    weak var listener: ChatInterfaceWebSocketProviderListener? // If multiple objects needs to be listener, use notification instead of delegate approach.
    
    // MARK: Initialization
    
    public init(chatThread: ChatThread?) {
        self.chatThread = chatThread
    }
    
    // MARK: API
    
    open func setupConnection() {
        fatalError("This method must be implemented by subclasses.")
    }
    
    open func openConnection() {
        fatalError("This method must be implemented by subclasses.")
    }
    
    open func closeConnection() {
        fatalError("This method must be implemented by subclasses.")
    }
}
