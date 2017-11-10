//
//  ChatMessageDataController.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit
import IGListKit


open class ChatMessageDataController: ListSectionController {
    
    public var chatMessage: ChatMessageRepresentable?
    
    // MARK: ListSectionController
    
    override open func numberOfItems() -> Int {
        return 1
    }
    
    public func widthForItem(at index: Int) -> CGFloat {
        let width: CGFloat
        
        if let collectionContext = collectionContext { // Precaution since collectionContext is force-wrap in samples.
            width = collectionContext.containerSize.width
        } else {
            width = UIScreen.main.bounds.width
        }
        
        return width
    }
    
    override open func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: widthForItem(at: index), height: CGFloat.leastNormalMagnitude)
    }
    
    override open func cellForItem(at index: Int) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    final override public func didUpdate(to object: Any) {
        chatMessage = object as? ChatMessageRepresentable
    }
}
