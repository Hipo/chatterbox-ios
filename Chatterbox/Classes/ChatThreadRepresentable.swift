//
//  ChatThreadRepresentable.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation


protocol ChatThreadRepresentable {
    
    var token: String? { get }
    
    var membershipToken: String? { get }
    
    var isFault: Bool { get } // Return false if thread is neede to be provided.
}
