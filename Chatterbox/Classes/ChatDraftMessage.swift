//
//  ChatDraftMessage.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 20/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation


public struct ChatDraftMessage {
    
    // MARK: Variables
    
    var type: ChatMessageType
    
    // MARK: Initialization
    
    init(type: ChatMessageType) {
        self.type = type
    }
    
    // MARK: API
    
    func serialized() -> [String: Any] {
        return ["text": serializedBody()]
    }
    
    private func serializedBody() -> String {
        var body = String()
        
        switch type {
        case .none:
            break
        case .text(let text):
            if let validText = text {
                body = validText
            }
        case .attributedText(let attributedText):
            if let validText = attributedText?.string {
                body = validText
            }
        }
        
        return body
    }
}
