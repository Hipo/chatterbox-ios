//
//  ChatTextMessageCell.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit


class ChatTextMessageView: UIView {
    
    struct Style {
        struct Font {
            static let textLabelFont = UIFont.systemFont(ofSize: 14.0)
        }
    }
    
    // MARK: LayoutComponents
    
    private(set) lazy var contentView: UIView = UIView()
    
    private(set) lazy var textLabel: UILabel = {
        [unowned self] in
        
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.black
        label.font = Style.Font.textLabelFont
        
        return label
    }()

    var senderViewPosition = ViewPosition.none
    static var contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
}

extension ChatTextMessageView: ChatMessageViewRepresentable {
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


class ChatTextMessageCell: ChatMessageCell<ChatTextMessageView> {
    
    // MARK: Layout
    
    override func setupLayout() {
        messageView = builder.build()
        
        messageView.contentView.addSubview(messageView.textLabel)
        
        messageView.textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(messageView)
        
        messageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: API
    
    override class func calculateHeight(with chatMessage: ChatMessageRepresentable,
                                        constrainedTo width: CGFloat) -> CGFloat {
        var height: CGFloat = 0.0
        
        height += ChatTextMessageView.contentEdgeInsets.top
        height += ChatTextMessageView.contentEdgeInsets.bottom
        
        let maxSize = CGSize(
            width: width -
                ChatTextMessageView.contentEdgeInsets.left -
                ChatTextMessageView.contentEdgeInsets.right,
            height: CGFloat.greatestFiniteMagnitude)
        
        switch chatMessage.type {
        case .none:
            break
        case .text(let text):
            height += calculateTextHeight(with: text, constrainedTo: maxSize)
        case .attributedText(let attributedText):
            height += calculateAttributedTextHeight(with: attributedText, constrainedTo: maxSize)
        case .attachment(_, _, _):
            break
        }
        
        return height
    }
    
    private class func calculateTextHeight(with text: String?,
                                     constrainedTo size: CGSize) -> CGFloat {
        guard let text = text else {
            return 0.0
        }
        
        var textAttributes = [NSAttributedStringKey: Any]()
        
        textAttributes[NSAttributedStringKey.font] = ChatTextMessageView.Style.Font.textLabelFont
        
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
