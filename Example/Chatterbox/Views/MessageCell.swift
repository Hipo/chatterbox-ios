//
//  MessageCell.swift
//  Chatterbox_Example
//
//  Created by Göktuğ Berk Ulu on 16.11.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Chatterbox

class MessageCell: ChatMessageCell<MessageView> {
    
    override func setupLayout() {
        
        buildMessageView()
        
        contentView.addSubview(messageView)
        
        messageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setupMessageLabelLayout()
    }
    
    func buildMessageView() {
        messageView = builder.build()
    }
    
    func setupMessageLabelLayout() {
        
        let textLabel = messageView.textLabel
        
        messageView.contentView.addSubview(textLabel)
        
        textLabel.setContentHuggingPriority(999, for: .vertical)
        textLabel.snp.remakeConstraints({ (make) in
            make.top.equalToSuperview().inset(10.0)
            make.leading.equalToSuperview().inset(10.0)
            make.trailing.equalToSuperview().inset(10.0)
        })
    }
    
    override class func calculateHeight(with chatMessage: ChatMessageRepresentable,
                                        constrainedTo width: CGFloat) -> CGFloat {
        var height: CGFloat = 75.0
        
        let maxSize = CGSize(
            width: width - 40.0,
            height: CGFloat.greatestFiniteMagnitude)
        
        switch chatMessage.type {
        case .none:
            break
        case .text(let text):
            height += calculateTextHeight(with: text, constrainedTo: maxSize)
        case .attributedText(let attributedText):
            height += calculateAttributedTextHeight(with: attributedText, constrainedTo: maxSize)
        }
        
        return height
    }
    
    private class func calculateTextHeight(with text: String?,
                                           constrainedTo size: CGSize) -> CGFloat {
        guard let text = text else {
            return 0.0
        }
        
        var textAttributes = [String: Any]()
        
        textAttributes[NSFontAttributeName] = UIFont.systemFont(ofSize: 14.0)
        
        return text.boundingSize(withAttributes: textAttributes, constrainedToSize: size).height
    }
    
    private class func calculateAttributedTextHeight(with attributedText: NSAttributedString?,
                                                     constrainedTo size: CGSize) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0.0
        }
        
        return attributedText.boundingSize(constrainedToSize: size).height
    }
}

class MyCell: MessageCell {
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundColor = UIColor.purple
        layer.cornerRadius = 4.0
    }
}

class FriendCell: MessageCell {
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundColor = .yellow
        layer.cornerRadius = 4.0
    }
}

class MessageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LayoutComponents
    
    private(set) lazy var contentView: UIView = UIView()
    
    private(set) lazy var textLabel: UILabel = {
        [unowned self] in
        
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        return label
        }()
    
    var senderViewPosition = ViewPosition.none
    static var contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
}

extension MessageView: ChatMessageViewRepresentable {
    var view: UIView {
        return self
    }
    
    var contentBackgroundView: UIView? {
        return nil
    }
    
    var contentMessageView: UIView? {
        return nil
    }
    
    var contentFooterSupplementaryView: UIView? {
        return nil
    }
    
    var senderView: UIView? {
        return nil
    }
}

