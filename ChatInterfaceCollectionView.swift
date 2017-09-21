//
//  ChatInterfaceCollectionView.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 14/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit


class ChatInterfaceCollectionViewLayout: UICollectionViewFlowLayout {
}


class ChatInterfaceCollectionView: UICollectionView {
    
    // MARK: LayoutComponents
    
    var chatInputAccessoryView: ChatInputAccessoryRepresentable = ChatInputAccessoryView() {
        didSet {
            reloadInputViews()
        }
    }

    // MARK: Initialization
    
    init() {
        let collectionViewLayout = ChatInterfaceCollectionViewLayout()
        
        super.init(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor.clear
        bounces = true
        alwaysBounceVertical = true
        alwaysBounceHorizontal = false
        showsVerticalScrollIndicator = false
        keyboardDismissMode = .interactive
        transform = CGAffineTransform.identity.rotated(by: .pi)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIResponder
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView {
        return chatInputAccessoryView.view
    }
}
