//
//  ChatMessageTextDataController.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit
import IGListKit


class ChatTextMessageDataController: ChatMessageDataController {
    
    // MARK: Initialization
    
    override init() {
        super.init()
        
        inset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
    }
    
    // MARK: ChatMessageDataController
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = widthForItem(at: index)
        
        var height: CGFloat = 0.0
        
        if let chatMessage = chatMessage {
            height = ChatTextMessageCell.calculateHeight(with: chatMessage, constrainedTo: width)
        }
        
        return CGSize(width: width, height: height.rounded(.up))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(
            of: ChatTextMessageCell.self,
            for: self,
            at: index) as? ChatTextMessageCell else {
            return super.cellForItem(at: index)
        }
        
        if let chatMessage = chatMessage {
            switch chatMessage.type {
            case .none:
                break
            case .text(let text):
                cell.messageView.textLabel.text = text
            case .attributedText(let attributedText):
                cell.messageView.textLabel.attributedText = attributedText
            case .attachment(let name, let url, let identifier):
                break
            }
        }
        
        return cell
    }
}
