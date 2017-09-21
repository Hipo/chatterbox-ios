//
//  ChatInputAccessoryRepresentable.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit


protocol ChatInputAccessoryDelegate: class {
    func chatInputAccessoryDidTapSendButton(_ chatInputAccessoryView: ChatInputAccessoryRepresentable)
}


protocol ChatInputAccessoryBuildable {
    var textView: UITextView { get }
    var sendButton: UIButton { get }
    
    var isSendingText: Bool { get set }
    
    var delegate: ChatInputAccessoryDelegate? { get set }
    
    func textViewTextDidChange()
}

typealias ChatInputAccessoryRepresentable = ViewRepresentable & ChatInputAccessoryBuildable
