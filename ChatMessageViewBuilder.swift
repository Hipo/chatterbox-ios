//
//  ChatMessageViewBuilder.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit
import SnapKit


func compose<A, B, C>(_ f1: @escaping ((A) -> B), _ f2: @escaping ((B) -> C)) -> (A) -> C {
    return { a in f2(f1(a)) }
}


class ChatMessageViewBuilder<T: ChatMessageViewRepresentable>: NSObject {
    
    fileprivate var fn: (T) -> T = { chatMessageView in
        return chatMessageView
    }
    
    func contentBackgroundView() -> Self {
        fn = compose(fn, { chatMessageView in
            if let backgroundView = chatMessageView.contentBackgroundView {
                chatMessageView.contentView.addSubview(backgroundView)
                
                backgroundView.snp.makeConstraints({ (make) in
                    make.edges.equalToSuperview()
                })
            }
            
            return chatMessageView
        })
        
        return self
    }
    
    func contentMessageView() -> Self {
        fn = compose(fn, { chatMessageView in
            if let messageView = chatMessageView.contentMessageView {
                chatMessageView.contentView.addSubview(messageView)
                
                messageView.snp.makeConstraints({ (make) in
                    make.top.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                })
            }
            
            return chatMessageView
        })
        
        return self
    }
    
    func contentFooterSupplementaryView() -> Self {
        fn = compose(fn, { chatMessageView in
            if let supplementaryView = chatMessageView.contentFooterSupplementaryView {
                chatMessageView.contentView.addSubview(supplementaryView)
                
                supplementaryView.snp.makeConstraints({ (make) in
                    make.leading.equalToSuperview()
                    make.bottom.equalToSuperview()
                    make.trailing.equalToSuperview()
                })
            }
            
            return chatMessageView
        })
        
        return self
    }
    
    func senderView(at position: ViewPosition) -> Self {
        fn = compose(fn, { chatMessageView in
            if let senderView = chatMessageView.senderView, position != .none {
                chatMessageView.view.addSubview(senderView)
                
                senderView.snp.makeConstraints({ (make) in
                    make.top.equalToSuperview().inset(T.contentEdgeInsets.top)
                    make.bottom.equalToSuperview().inset(T.contentEdgeInsets.bottom)
                    
                    switch position {
                    case .left:
                        make.left.equalToSuperview().inset(T.contentEdgeInsets.left)
                    case .right:
                        make.right.equalToSuperview().inset(T.contentEdgeInsets.right)
                    default:
                        break
                    }
                })
                
                var mutableChatMessageView = chatMessageView
                
                mutableChatMessageView.senderViewPosition = position
            }
            
            return chatMessageView
        })
        
        return self
    }
    
    func build() -> T {
        let simpleChatMessageView = T()
        
        simpleChatMessageView.view.addSubview(simpleChatMessageView.contentView)
        
        simpleChatMessageView.contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(T.contentEdgeInsets.top)
            make.bottom.equalToSuperview().inset(T.contentEdgeInsets.bottom)
        }
        
        let chatMessageView = fn(simpleChatMessageView)
        
        adjustInternalLayout(for: chatMessageView)
        
        return chatMessageView
    }
    
    private func adjustInternalLayout(for chatMessageView: T) {
        let messageView = validate(
            chatMessageView.contentMessageView,
            isDescendantOf: chatMessageView.view)
        let footerSupplementaryView = validate(
            chatMessageView.contentFooterSupplementaryView,
            isDescendantOf: chatMessageView.view)
        
        if let theMessageView = messageView {
            if let theFooterSupplementaryView = footerSupplementaryView {
                theFooterSupplementaryView.snp.makeConstraints({ (make) in
                    make.top.equalTo(theMessageView.snp.bottom)
                })
            } else {
                theMessageView.snp.makeConstraints({ (make) in
                    make.bottom.equalToSuperview()
                })
            }
        } else if let theFooterSupplementaryView = footerSupplementaryView {
            theFooterSupplementaryView.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
            })
        }
        
        if let theSenderView = validate(
            chatMessageView.senderView,
            isDescendantOf: chatMessageView.view) {
            switch chatMessageView.senderViewPosition {
            case .left:
                chatMessageView.contentView.snp.makeConstraints({ (make) in
                    make.trailing.equalToSuperview().inset(T.contentEdgeInsets.right)
                    make.leading.equalTo(theSenderView.snp.trailing)
                })
            case .right:
                chatMessageView.contentView.snp.makeConstraints({ (make) in
                    make.leading.equalToSuperview().inset(T.contentEdgeInsets.left)
                    make.trailing.equalTo(theSenderView.snp.leading)
                })
            default:
                break
            }
        } else {
            chatMessageView.contentView.snp.makeConstraints({ (make) in
                make.leading.equalToSuperview().inset(T.contentEdgeInsets.left)
                make.trailing.equalToSuperview().inset(T.contentEdgeInsets.right)
            })
        }
    }
    
    private func validate(_ view: UIView?,
                          isDescendantOf superView: UIView) -> UIView? {
        guard let view = view else {
            return nil
        }
        
        if !view.isDescendant(of: superView) {
            return nil
        }
        
        return view
    }
}
