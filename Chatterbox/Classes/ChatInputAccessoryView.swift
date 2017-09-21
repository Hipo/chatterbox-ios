//
//  ChatInputAccessoryView.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 13/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit
import SnapKit


class ChatInputAccessoryView: UIView {
    
    // MARK: LayoutComponents
    
    private(set) lazy var growingTextView: AutoGrowingTextView = {
        let textView = AutoGrowingTextView()
        
        textView.backgroundColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.maxNumberOfLines = 5
        
        return textView
    }()
    
    private(set) lazy var sendButton: UIButton = {
        let button = UIButton()
        
        button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        button.setTitle(NSLocalizedString("chat-message-button-title-send", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        return button
    }()
    
    private(set) lazy var sendingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return activityIndicator
    }()
    
    // MARK: Variables
    
    var contentEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0) {
        didSet {
            if contentEdgeInsets == oldValue {
                return
            }
            
            updateLayoutForContentEdgeInsetsChange()
            updateMinimumHeight()
        }
    }
    
    var textViewEdgeInsets = UIEdgeInsets.zero {
        didSet {
            if textViewEdgeInsets == oldValue {
                return
            }
            
            updateLayoutForTextViewEdgeInsetsChange()
            updateMinimumHeight()
        }
    }
    
    var minimumHeight: CGFloat = 0.0 {
        didSet {
            if minimumHeight == oldValue {
                return
            }
            
            updateSendButtonHeight()
        }
    }
    
    private var growingTextViewTopConstraint: Constraint?
    private var growingTextViewLeadingConstraint: Constraint?
    private var growingTextViewBottomConstraint: Constraint?
    private var sendButtonHeightConstraint: Constraint?
    private var sendButtonLeadingConstraint: Constraint?
    private var sendButtonTrailingConstraint: Constraint?
    
    var isSendingText: Bool = false {
        didSet {
            if isSendingText == oldValue {
                return
            }
            
            if isSendingText {
                sendButton.isEnabled = false
                sendButton.setTitle(nil, for: .normal)
                sendingIndicator.startAnimating()
                prepareSendingIndicatorLayout()
            } else {
                sendingIndicator.stopAnimating()
                sendingIndicator.removeFromSuperview()
                sendButton.isEnabled = true
                sendButton.setTitle(NSLocalizedString("chat-message-button-title-send", comment: ""), for: .normal)
            }
        }
    }
    
    weak var delegate: ChatInputAccessoryDelegate?
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        minimumHeight = calculateMinimumumHeight()
        
        setupLayout()
        
        sendButton.addTarget(self, action: #selector(didTap(sendButton:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override var intrinsicContentSize: CGSize {
        let totalHeight = growingTextView.expectedHeight +
            contentEdgeInsets.top +
            contentEdgeInsets.bottom +
            textViewEdgeInsets.top +
            textViewEdgeInsets.bottom
        
        return CGSize(width: UIViewNoIntrinsicMetric, height: totalHeight)
    }
    
    func setupLayout() {
        autoresizingMask = .flexibleHeight
        
        backgroundColor = UIColor.lightGray
        
        prepareTextViewLayout()
        prepareSendButtonLayout()
    }
    
    private func prepareTextViewLayout() {
        addSubview(growingTextView)
        
        growingTextView.snp.makeConstraints { (make) in
            self.growingTextViewTopConstraint = make.top.equalToSuperview()
                .inset(contentEdgeInsets.top + textViewEdgeInsets.top).constraint
            self.growingTextViewLeadingConstraint = make.leading.equalToSuperview()
                .inset(contentEdgeInsets.left + textViewEdgeInsets.left).constraint
            self.growingTextViewBottomConstraint = make.bottom.equalToSuperview()
                .inset(contentEdgeInsets.bottom + textViewEdgeInsets.bottom).constraint
        }
    }
    
    private func prepareSendButtonLayout() {
        addSubview(sendButton)
        
        sendButton.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .horizontal)
        sendButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(contentEdgeInsets.bottom)
            self.sendButtonHeightConstraint = make.height
                .equalTo(minimumHeight - contentEdgeInsets.top - contentEdgeInsets.bottom).constraint
            self.sendButtonTrailingConstraint = make.trailing.equalToSuperview()
                .inset(contentEdgeInsets.right).constraint
            self.sendButtonLeadingConstraint = make.leading.equalTo(growingTextView.snp.trailing)
                .offset(textViewEdgeInsets.right).constraint
        }
    }
    
    private func prepareSendingIndicatorLayout() {
        addSubview(sendingIndicator)
        
        sendingIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(sendButton)
        }
    }
    
    private func updateLayoutForContentEdgeInsetsChange() {
        updateTextViewLayoutForInsetsChange()
        sendButtonTrailingConstraint?.update(inset: contentEdgeInsets.right)
    }
    
    private func updateTextViewLayoutForInsetsChange() {
        growingTextViewTopConstraint?.update(inset: contentEdgeInsets.top + textViewEdgeInsets.top)
        growingTextViewLeadingConstraint?.update(inset: contentEdgeInsets.left + textViewEdgeInsets.left)
        growingTextViewBottomConstraint?.update(inset: contentEdgeInsets.bottom + textViewEdgeInsets.bottom)
    }
    
    private func updateLayoutForTextViewEdgeInsetsChange() {
        updateLayoutForContentEdgeInsetsChange()
        sendButtonLeadingConstraint?.update(offset: textViewEdgeInsets.right)
    }
    
    private func updateSendButtonHeight() {
        sendButtonHeightConstraint?.update(offset: minimumHeight - contentEdgeInsets.top - contentEdgeInsets.bottom)
    }
    
    private func updateMinimumHeight() {
        minimumHeight = calculateMinimumumHeight()
    }
    
    private func calculateMinimumumHeight() -> CGFloat {
        return growingTextView.minimumHeight +
            contentEdgeInsets.top +
            contentEdgeInsets.bottom +
            textViewEdgeInsets.top +
            textViewEdgeInsets.bottom
    }
    
    // MARK: UIView
    
    override func didMoveToSuperview() {
        if superview == nil { // It is removed from superview
            return
        }
        
        updateMinimumHeight() // Because text view font can be changed in init(frame:) 
    }
    
    // MARK: Action
    
    func didTap(sendButton sender: UIButton) {
        delegate?.chatInputAccessoryDidTapSendButton(self)
    }
}

// MARK: ChatInputAccessoryRepresentable

extension ChatInputAccessoryView: ChatInputAccessoryRepresentable {
    var view: UIView {
        return self
    }
    
    var textView: UITextView {
        return growingTextView
    }
    
    func textViewTextDidChange() {
        growingTextView.textDidChange()
        invalidateIntrinsicContentSize()
        
        // TODO: It would be nice to find a way to animate height.
    }
}
