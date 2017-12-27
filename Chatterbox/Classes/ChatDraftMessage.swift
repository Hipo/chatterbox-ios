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
    
    public var type: ChatMessageType
    
    // MARK: Initialization
    
    public init(type: ChatMessageType) {
        self.type = type
    }
    
    // MARK: API
    
    public func serialized() -> [String: Any] {
        return ["text": serializedBody(), "attachment": serializedAttachment()]
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
        
        case .attachment(_,_,_):
            break
        }
        return body
    }
    
    private func serializedAttachment() -> [String: Any] {
        var attachmentDictionary: [String: Any] = [:]
        switch type {
        case .attachment(let name, let url, let identifier):
            if let validName = name {
                attachmentDictionary["name"] = validName
            }
            if let validUrl = url {
                attachmentDictionary["url"] = validUrl
            }
            if let validId = identifier {
                attachmentDictionary["identifier"] = validId
            }
            return attachmentDictionary
        default:
            break
        }
        return attachmentDictionary
    }
}
