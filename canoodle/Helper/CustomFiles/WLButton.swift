//
//  WLButton.swift
//  WhiteLabelApp
//
//  Created by hb on 23/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
@IBDesignable class WLButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// Sets corner radius for textfield
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// Sets corner radius for textfield
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// Sets corner radius for textfield
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

}
