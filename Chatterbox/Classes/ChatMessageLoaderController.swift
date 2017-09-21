//
//  ChatMessageLoaderController.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 21/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit
import IGListKit


class ChatMessageLoaderController: ListSectionController {
    
    static let replacementToken = "ChatMessageLoaderController.replacementToken"

    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        var width: CGFloat
        
        if let collectionContext = collectionContext {
            width = collectionContext.containerSize.width
        } else {
            width = UIScreen.main.bounds.width
        }
        
        return CGSize(width: width, height: 40.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: ChatMessageLoaderCell.self,
            for: self,
            at: index) as? ChatMessageLoaderCell else {
                return UICollectionViewCell()
        }
        
        cell.loader.startAnimating()
        
        return cell
    }
}
