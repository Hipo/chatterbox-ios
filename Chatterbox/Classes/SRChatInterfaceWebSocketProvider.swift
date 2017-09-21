//
//  SRChatInterfaceWebSocketProvider.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 20/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import SocketRocket


public class SRChatInterfaceWebSocketProvider
    <T: ChatThreadRepresentable, S: ChatMessageRepresentable>: BaseChatInterfaceWebSocketProvider<T>,
SRWebSocketDelegate {
    
    // MARK: Variables
    
    fileprivate var webSocket: SRWebSocket?
    
    override var connectionStatus: WebSocketConnectionStatus {
        guard let webSocket = webSocket else {
            return .disconnected
        }
        
        switch webSocket.readyState {
        case .CONNECTING:
            return WebSocketConnectionStatus.connecting
        case .OPEN:
            return WebSocketConnectionStatus.connected
        case .CLOSING, .CLOSED:
            return WebSocketConnectionStatus.disconnected
        }
    }
    
    // MARK: API
    
    override public func openConnection() {
        if connectionStatus != .disconnected {
            return
        }
        
        webSocket?.delegate = nil
        webSocket = nil
        
        guard let chatServerUrl = chatServerUrl, let url = URL(string: chatServerUrl) else {
            return
        }
        
        let newWebSocket = SRWebSocket(url: url)
        
        newWebSocket?.delegate = self
        newWebSocket?.open()
    }
    
    override public func closeConnection() {
        if connectionStatus == .disconnected {
            return
        }
        
        guard let webSocket = webSocket else {
            return
        }
        
        webSocket.close()
    }
    
    // MARK: SRWebSocketDelegate
    
    public func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        self.webSocket = webSocket
        
        listener?.webSocketConnectionDidOpen()
    }
    
    public func webSocket(_ webSocket: SRWebSocket!,
                   didCloseWithCode code: Int,
                   reason: String!,
                   wasClean: Bool) {
        listener?.webSocketConnectionDidClose()
        
        openConnection()
    }
    
    public func webSocket(_ webSocket: SRWebSocket!,
                   didFailWithError error: Error!) {
        listener?.webSocketConnectionDidFail(with: error)
        
        openConnection()
    }
    
    public func webSocket(_ webSocket: SRWebSocket!,
                   didReceiveMessage message: Any!) {
        let jsonString = message as? String
        listener?.webSocketConnectionDidReceive(jsonString?.jsonSerialized())
    }
}
