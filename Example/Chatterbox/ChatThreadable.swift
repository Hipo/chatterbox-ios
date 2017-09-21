//
//  ChatThreadable.swift
//  Chatterbox
//
//  Created by Omer Emre Aslan on 21/09/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit
import Chatterbox

class ChatThreadable: ChatThreadRepresentable {
    var membershipToken: String? {
        return "Membership Token"
    }
    
    var isFault: Bool {
        return false//
    }
    
    var token: String? {
        return "token"
    }
}

class ChatMessage: NSObject, ChatMessageRepresentable {
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ChatMessage else {
            return false
        }
        
        if self === object {
            return true
        }
        
        return date == object.date
    }
    
    fileprivate(set) var text: String? {
        didSet {
            if text == oldValue {
                return
            }
            
            // Creating attributed text will be in loading chat messages.
            guard let text = text else {
                attributedText = nil
                
                return
            }
            
            let paragraphyStyle = NSMutableParagraphStyle()
            
            paragraphyStyle.minimumLineHeight = 16.0
            paragraphyStyle.maximumLineHeight = 16.0
            
            attributedText = NSAttributedString(
                string: text,
                attributes: [//NSFontAttributeName: FLChatTextMessageView.Style.Font.textLabelFont,
                             NSParagraphStyleAttributeName: paragraphyStyle])
        }
    }
    fileprivate(set) var attributedText: NSAttributedString?
    fileprivate(set) var date: Date?
    fileprivate(set) var userId: String?
    
    
    
    var type: ChatMessageType {
        return .attributedText(attributedText)
    }
    
    var avatarUrl: String? {
        return "avatar"
    }
    
    var isMe: Bool {
        return true
    }
    
    struct UndefinedInfo {
        static let isFamelogger = "isFamelogger"
    }
    
    var undefinedInfo: [String: Any]? {
        let info = [String: Any]()
        
        return info
    }
}
