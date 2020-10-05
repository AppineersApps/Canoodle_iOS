//
//  CustomTextView.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationTextViewKeyMaxLength: Int = 100


/// Custom Textview with additional Options
@IBDesignable class CustomTextView: UITextView {
    
    /// Placeholder label
    var placeholderLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
    }
    
    @IBInspectable
    /// Set Corner Raidus
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    /// Set Max lenght for textview
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationTextViewKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationTextViewKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// Set Placeholder color
    @IBInspectable var placeholderColor: UIColor? {
        didSet {
            setup()
        }
    }
    
    /// Set Placeholder text
    @IBInspectable var placeholderText: String? {
        didSet {
            setup()
        }
    }
    
    /// Set placeholder
    func setup() {
        placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.textColor = self.placeholderColor
        placeholderLabel.font = self.font
        placeholderLabel.sizeToFit()
        self.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}

extension CustomTextView : UITextViewDelegate {
    /// Method is called when textview text changes
    ///
    /// - Parameter textView: Textview
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
    /// Method is called when textview text changes
    ///
    /// - Parameters:
    ///   - textView: Textview
    ///   - range: Range of text
    ///   - text: Text user inputted
    /// - Returns: Returns true or false
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let maxLength = kAssociationTextViewKeyMaxLength
            let currentString: NSString = self.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
            if newString.length > maxLength {
                return newString.length <= maxLength
            }
        return true
    }
}

