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


class ChatMessageDataController: ListSectionController {
    
    private(set) var chatMessage: ChatMessageRepresentable?
    
    // MARK: ListSectionController
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    func widthForItem(at index: Int) -> CGFloat {
        let width: CGFloat
        
        if let collectionContext = collectionContext { // Precaution since collectionContext is force-wrap in samples.
            width = collectionContext.containerSize.width
        } else {
            width = UIScreen.main.bounds.width
        }
        
        return width
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: widthForItem(at: index), height: CGFloat.leastNormalMagnitude)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    final override func didUpdate(to object: Any) {
        chatMessage = object as? ChatMessageRepresentable
    }
}
