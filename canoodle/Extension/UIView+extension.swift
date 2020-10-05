//
//  UIView+extension.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//


import Foundation
import UIKit


extension UIView {
    
    /// Get ParentView Controller of the Given UIView
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    
    /// Add Rounded corner
    ///
    /// - Parameter radius: Radius of the corners
	func setRoundCorner(radius:CGFloat) {
		self.layer.cornerRadius = radius
		self.layer.masksToBounds = true
	}
    
    /// Add Reounded corner with shadow
    ///
    /// - Parameter cornerRe: Radius of the corners
    func setCornerRadiusAndShadow(cornerRe: CGFloat) {
        self.layer.cornerRadius = cornerRe
        self.setShadow()
    }
    
    /// Add shadow
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
    }
	
    /// Add shadow to button
    ///
    /// - Parameter button: WLButton
    func addLoginButtonShadowAndCornerRadius() {
        self.layer.cornerRadius = 20
        self.layer.shadowRadius = 3.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
    
    /// Add Border to the View
    ///
    /// - Parameters:
    ///   - color: Color of the border
    ///   - size: Width of the border
	func setBorder(color:UIColor = UIColor.clear, size:CGFloat = 1) {
		self.layer.borderColor = color.cgColor
		self.layer.borderWidth = size
	}
	
    /// Set Rounded border along with Border Color
    ///
    /// - Parameters:
    ///   - radius: Radius of the corners
    ///   - color: Color of the border
    ///   - size: Width of the border
	func setRoundBorder(radius:CGFloat, color:UIColor = UIColor.clear, size:CGFloat = 1) {
		self.setRoundCorner(radius: radius)
		self.setBorder(color: color, size: size)
	}
	
    /// Method used to apply corner radius to speicific corners
    ///
    /// - Parameters:
    ///   - corners: Accepts the array of type UIRectCorner
    ///   - radius:Radius of the corners
    func roundCorners(corners:UIRectCorner, radius: CGFloat,bounds:CGRect = CGRect.zero) {
        let aApplyBound = bounds == CGRect.zero ? self.bounds : bounds
        let path = UIBezierPath(roundedRect:aApplyBound, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    

    
    /// Add Circular shadow around view
    ///
    /// - Parameter radius: Radius of the shadow
    func addCircularShadow(_ radius:CGFloat) {
        let aRect = CGRect(x: 0, y: -2, width: frame.size.width + 2, height: frame.size.height + 2)
        let shadowPath = UIBezierPath(roundedRect: aRect , cornerRadius: radius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 1.0

    }
}
