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
    
    
    /// Log the Button events in library
    @objc func logEvent() {
        
        var aFunctionName = ""
        var buttonName = ""
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
                        buttonName = target.description
                    }
                    print(aStr)
                }
            }
        }
        if let _ = aClass
        {
            GlobalUtility.logButtonEvent(functionName: aFunctionName, file: GlobalUtility.classNameAsString(obj: aClass!), name: self.titleLabel?.text ?? aFunctionName)
        }
    }
}
