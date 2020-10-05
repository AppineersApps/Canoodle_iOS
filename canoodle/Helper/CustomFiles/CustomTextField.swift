//
//  CustomTextField.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

/// Maxlength property for textfield
private var kAssociationTextFieldKeyMaxLength: Int = 0


/// Custom Textfield to define properties
@IBDesignable class CustomTextField: UITextField {
    
    ///Provides left padding for images
    ///
    /// - Parameter bounds: Bounds for padding
    /// - Returns: returns rect area
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    
    /// Sets corner radius for textfield
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// Set Max Length
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationTextFieldKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationTextFieldKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    /// Check max length
    ///
    /// - Parameter textField: Textfield object
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text, prospectiveText.count > maxLength else
        {
            return
        }
        let selection = selectedTextRange
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
        
    /// Left image for textfield
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    /// Set left padding for textfield
    @IBInspectable var leftPadding: CGFloat = 0
    
    /// Set text color
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    /// Update View
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            view.backgroundColor = nil
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            view.addSubview(imageView)
            leftView = view
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
       
    }
    
    
}
