//
//  WLButton+Extension.swift
//  WhiteLabelApp
//
//  Created by hb on 17/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    /// Check if button is selected
    ///
    /// - Throws: Throws exception if button is not selected
    func checkSelection() throws {
        if !self.isSelected {
            throw ValidationError(AlertMessage.acceptTermsCondition)
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(logEvent), for: .touchUpInside)
    }
    
    func press() {
             UIView.animate(withDuration: 0.05, animations: {
                 self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) }, completion: { (finish: Bool) in
                     UIView.animate(withDuration: 0.1, animations: {
                         self.transform = CGAffineTransform.identity
                     })
             })
     }

    
    /// Log the Button events in library
    @objc func logEvent() {
        press()
        var aFunctionName = ""
        var aClass = self.superview?.parentViewController
        if aClass is NavController
        {
            aClass = (aClass as! NavController).topViewController
        }
        
        for target in self.allTargets
        {
            if let aActions = self.actions(forTarget: target, forControlEvent: .touchUpInside)
            {
                for aStr in aActions
                {
                    print("Actions")
                    if aStr != "logEvent"
                    {
                        aFunctionName = aStr
                    }
                    print(aStr)
                }
            }
        }
        if let _ = aClass
        {
            GlobalUtility.logButtonEvent(functionName: aFunctionName, file: GlobalUtility.classNameAsString(obj: aClass!), name: aFunctionName)
        }
    }
}
