//
//  ChatMessageCell.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit


class ChatMessageCell<T: ChatMessageViewRepresentable>: UICollectionViewCell {
    
    // MARK: LayoutComponents
    
    lazy var messageView: T = T()
    
    // MARK: Builder
    
    private(set) var builder = ChatMessageViewBuilder<T>()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.transform = CGAffineTransform.identity.rotated(by: .pi)
                
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    func setupLayout() {
        fatalError("This method must be overridden by subclasses.")
    }
    
    // MARK: API
    
    class func calculateHeight(with chatMessage: ChatMessageRepresentable,
                               constrainedTo width: CGFloat) -> CGFloat {
        fatalError("This method must be overridden by subclasses.")
    }
}
