//
//  ChatMessageLoaderCell.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 21/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit


class ChatMessageLoaderCell: UICollectionViewCell {
    
    // MARK: LayoutComponents
    
    private(set) lazy var loader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    func setupLayout() {
        prepareLoaderLayout()
    }
    
    private func prepareLoaderLayout() {
        contentView.addSubview(loader)
        
        loader.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
