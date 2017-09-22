//
//  AutoGrowingTextView.swift
//  Famelog
//
//  Created by Salih Karasuluoglu on 13/06/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import UIKit


public struct PlaceholderBundle {
    var text: String? = nil
    var textColor: UIColor? = nil
    var font: UIFont? = nil
    
    public init(text: String?, textColor: UIColor?, font: UIFont?) {
        self.text = text
        self.textColor = textColor
        self.font = font
    }
}


public class AutoGrowingTextView: UITextView {
    
    // MARK: LayoutComponents
    
    fileprivate lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        
        label.isHidden = true
        
        return label
    }()
    
    // MARK: UITextView-Variables
    
    override public var font: UIFont? {
        didSet {
            guard let bundle = placeholderBundle, let _ = bundle.text else {
                return
            }
            
            if bundle.font == nil {
                placeholderLabel.font = font
            }
        }
    }
    
    override public var contentSize: CGSize {
        didSet {
            updateHeight()
        }
    }
    
    // MARK: Variables
    
    public var placeholderBundle: PlaceholderBundle? {
        didSet {
            placeholderLabel.text = placeholderBundle?.text
            
            if let textColor = placeholderBundle?.textColor {
                placeholderLabel.textColor = textColor
            } else {
                placeholderLabel.textColor = UIColor.lightGray
            }
            
            if let font = placeholderBundle?.font {
                placeholderLabel.font = font
            } else {
                placeholderLabel.font = self.font
            }
        }
    }
    
    fileprivate(set) var expectedHeight: CGFloat = 0.0
    var minimumHeight: CGFloat {
        return lineHeight + textContainerInset.top + textContainerInset.bottom
    }
    var maximumHeight = CGFloat.greatestFiniteMagnitude // Equals to minimumHeight by default.
    
    var maxNumberOfLines: Int = 0 { // 0 means no limit
        didSet {
            if maxNumberOfLines > 0 { // Otherwise keep the last change.
                maximumHeight = (lineHeight * CGFloat(maxNumberOfLines)) +
                    textContainerInset.top + textContainerInset.bottom
            } else if maxNumberOfLines == 0 {
                maximumHeight = CGFloat.greatestFiniteMagnitude
            }
        }
    }
    
    var lineHeightMultiple: CGFloat = 1.0 // Natural line height is multiplied by this factor (if positive) before being constrained by minimum and maximum line height.
    
    fileprivate var lineHeight: CGFloat {
        guard let font = font else {
            return 0.0
        }
        
        return (font.lineHeight * lineHeightMultiple).rounded(.up)
    }
    
    fileprivate var canShowPlaceholder: Bool {
        guard let placeholderBundle = placeholderBundle, let placeholder = placeholderBundle.text else {
            return false
        }
        
        return text.isEmpty && !placeholder.isEmpty
    }
    
    // MARK: Initialization
    
    override init(frame: CGRect,
                  textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        isScrollEnabled = false
        autocorrectionType = .no
        autocapitalizationType = .sentences
        
        addSubview(placeholderLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Layout
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if canShowPlaceholder {
            placeholderLabel.isHidden = false
            placeholderLabel.frame = placeholderRectThatFits(bounds)
            
            sendSubview(toBack: placeholderLabel)
        }
    }
    
    private func placeholderRectThatFits(_ rect: CGRect) -> CGRect {
        var placeholderRect = UIEdgeInsetsInsetRect(rect, textContainerInset)
        let padding = textContainer.lineFragmentPadding
        
        placeholderRect.origin.x += padding
        placeholderRect.size.width -= 2 * padding
        
        return placeholderRect
    }
}

// MARK: Height

extension AutoGrowingTextView {
    fileprivate func updateHeight() {
        let expectedHeight = calculateHeight()
        
        if expectedHeight > maximumHeight {
            self.expectedHeight = maximumHeight
            isScrollEnabled = true
        } else {
            self.expectedHeight = expectedHeight
            isScrollEnabled = false
        }
        
        ensureCaretAtCorrectPosition()
    }
    
    private func calculateHeight() -> CGFloat {
        var newHeight: CGFloat = 0.0
        
        guard let font = font else {
            return minimumHeight
        }
        
        var textAttributes = [String: Any]()
        
        textAttributes[NSFontAttributeName] = font
        
        if lineHeightMultiple > 1.0 {
            let paragraphyStyle = NSMutableParagraphStyle()
            
            paragraphyStyle.lineHeightMultiple = lineHeightMultiple
            
            textAttributes[NSParagraphStyleAttributeName] = paragraphyStyle
        }
        
        let constrainedWidth = bounds.width -
            (textContainerInset.left + textContainerInset.right) -
            (2 * textContainer.lineFragmentPadding)
        let constrainedSize = CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = NSString(string: text).boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .truncatesLastVisibleLine, .usesFontLeading],
            attributes: textAttributes,
            context: nil)
        
        newHeight = boundingRect.height.rounded(.up)
        newHeight = newHeight + textContainerInset.top + textContainerInset.bottom
        
        return max(newHeight, minimumHeight)
    }
    
    private func ensureCaretAtCorrectPosition() {
        guard let selectedTextRange = selectedTextRange else {
            return
        }
        
        let rect = super.caretRect(for: selectedTextRange.end)
        
        UIView.performWithoutAnimation {
            scrollRectToVisible(rect, animated: false)
        }
    }
}

// MARK: API

extension AutoGrowingTextView {
    func textDidChange() {
        placeholderLabel.isHidden = !canShowPlaceholder
        updateHeight()
    }
}
