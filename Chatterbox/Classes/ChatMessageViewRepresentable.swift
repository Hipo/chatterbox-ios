//
//  ChatMessageView.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit

public enum ViewPosition {
    case none
    case left
    case right
}


public protocol ChatMessageViewBuildable {
    
    init()
    
    var contentView: UIView { get }
    
    var contentBackgroundView: UIView? { get }
    
    var contentMessageView: UIView? { get }
    
    var contentFooterSupplementaryView: UIView? { get }
    
    var senderView: UIView? { get }
    
    var senderViewPosition: ViewPosition { get set }
    
    static var contentEdgeInsets: UIEdgeInsets { get set }
}

public typealias ChatMessageViewRepresentable = ViewRepresentable & ChatMessageViewBuildable
