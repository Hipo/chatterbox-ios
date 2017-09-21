//
//  ChatMessageRepresentable.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import IGListKit


enum ChatMessageType {
    case none
    case text(String?)
    case attributedText(NSAttributedString?)
}


protocol ChatMessageRepresentable: ListDiffable {
    var type: ChatMessageType { get }
    
    var date: Date? { get }
    
//    var owner: FLUser? { get }
    
    var avatarUrl: String? { get }
    
    var isMe: Bool { get }
    
    var undefinedInfo: [String: Any]? { get }
}
