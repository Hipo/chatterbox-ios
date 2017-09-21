//
//  ChatInterfaceViewController+Helpers.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 15/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit


extension String {
    func boundingSize(withAttributes attributes: [String: Any]?,
                      hasMultilines: Bool = true,
                      constrainedToSize size: CGSize) -> CGSize {
        if size == CGSize.zero {
            return size
        }
        
        var options: NSStringDrawingOptions = [NSStringDrawingOptions.usesFontLeading]
        
        if hasMultilines {
            options = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
        }
        
        let rect = NSString(string: self).boundingRect(
            with: size,
            options: options,
            attributes: attributes,
            context: nil)
        
        return rect.size
    }
    
    func jsonSerialized() -> [String: Any]? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any]
    }
    
    func trimmingCharactersAtTail(_ characterSet: CharacterSet) -> String {
        guard let rangeOfValidLastCharacter = rangeOfCharacter(
            from: characterSet.inverted,
            options: .backwards,
            range: startIndex..<endIndex) else {
                return self
        }
     
        return replacingCharacters(in: rangeOfValidLastCharacter.upperBound..<endIndex, with: "")
    }
}


extension NSAttributedString {
    func boundingSize(hasMultilines: Bool = true,
                      constrainedToSize size: CGSize) -> CGSize {
        if size == CGSize.zero {
            return size
        }
        
        var options: NSStringDrawingOptions = [NSStringDrawingOptions.usesFontLeading]
        
        if hasMultilines {
            options = [.usesFontLeading, .truncatesLastVisibleLine, .usesLineFragmentOrigin]
        }
        
        let rect = boundingRect(
            with: size,
            options: options,
            context: nil)
        
        return rect.size
    }
}
