//
//  FLChatInputAccessoryView.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 14/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit
import Chatterbox

class FLChatInputAccessoryView: ChatInputAccessoryView {
    
    struct Style {
        struct Color {
            static let contentBackgroundColor = UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
            static let textViewBackgroundColor = UIColor.white
            static let textViewCaretColor = UIColor(red: 172.0 / 255.0, green: 148.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
            static let textViewTextColor = UIColor.black
            static let sendButtonTitleColor = UIColor.white
        }
        
        struct Layer {
            static let textViewCornerRadius: CGFloat = 2.5
        }
        
        struct Font {
            static let sendButtonTitleFont = UIFont.systemFont(ofSize: 12.0)//UIFont.avenirNext(weight: .medium, size: 12.0)
        }
    }
    
    struct Layout {
        static let sendButtonWidth: CGFloat = 65.0
    }
    
    // MARK: Variables
    
    override var isSendingText: Bool {
        didSet {
            if isSendingText == oldValue {
                return
            }
            
            super.isSendingText = isSendingText
            
            if !isSendingText {
                sendButton.setTitle(NSLocalizedString("chat-message-button-title-send", comment: ""), for: .normal)
            }
        }
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    
    private func configureContent() {
        backgroundColor = Style.Color.contentBackgroundColor
        
        contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 10.0, bottom: 8.0, right: 8.0)
        textViewEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 15.0)
        
        configureGrowingTextView()
        configureSendButton()
    }
    
    private func configureGrowingTextView() {
        growingTextView.backgroundColor = Style.Color.textViewBackgroundColor
        growingTextView.layer.masksToBounds = true
        growingTextView.layer.cornerRadius = Style.Layer.textViewCornerRadius
        growingTextView.tintColor = Style.Color.textViewCaretColor
        growingTextView.textColor = Style.Color.textViewTextColor
        growingTextView.font = UIFont.systemFont(ofSize: 13.0)
        growingTextView.textContainerInset = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 5.0, right: 0.0)
        growingTextView.placeholderBundle = PlaceholderBundle(text: "Write here", textColor: nil, font: nil)
    }
    
    private func configureSendButton() {
        sendButton.backgroundColor = Style.Color.textViewCaretColor
        sendButton.setBackgroundImage(nil, for: .normal)
        sendButton.titleLabel?.font = Style.Font.sendButtonTitleFont
        sendButton.setTitleColor(Style.Color.sendButtonTitleColor, for: .normal)
        sendButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        
        sendButton.snp.makeConstraints { (make) in
            make.width.equalTo(Layout.sendButtonWidth)
        }
    }
}
