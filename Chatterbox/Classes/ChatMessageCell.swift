//
//  ChatMessageCell.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit


open class ChatMessageCell<T: ChatMessageViewRepresentable>: UICollectionViewCell {
    
    // MARK: LayoutComponents
    
    public lazy var messageView: T = T()
    
    // MARK: Builder
    
    public var builder = ChatMessageViewBuilder<T>()
    
    // MARK: Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.transform = CGAffineTransform.identity.rotated(by: .pi)
                
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    open func setupLayout() {
        fatalError("This method must be overridden by subclasses.")
    }
    
    // MARK: API
    
    open class func calculateHeight(with chatMessage: ChatMessageRepresentable,
                               constrainedTo width: CGFloat) -> CGFloat {
        fatalError("This method must be overridden by subclasses.")
    }
}
