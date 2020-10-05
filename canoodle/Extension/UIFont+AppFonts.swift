//
//  UIFont+AppFonts.swift
//  BaseProject
//
//  Created by hb on 28/08/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

//MARK: - Fonts
extension UIFont {
    
    /// App font weight
    ///
    /// - Light: Light
    /// - Regular: Regular
    /// - Medium: Medium
    /// - SemiBold: Semibold
    /// - Bold: Bold
    enum FontWeight: String {
         /// - Weight: Light
        case Light = "Montserrat-Light"
        /// - Weight: Regular
        case Regular = "Montserrat-Regular"
        /// - Weight: Medium
        case Medium = "Montserrat-Medium"
        /// - Weight: Semibold
        case SemiBold = "Montserrat-SemiBold"
        /// - Weight: Bold
        case Bold = "Montserrat-Bold"
    }
    
    /// Get Montserrat font
    ///
    /// - Parameters:
    ///   - size: Set the size
    ///   - weight: Set weight enum
    /// - Returns: Get UIFont object
    class func Montserrat(size: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: weight.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    /// Print all fonts in the app
    class func printFonts() {
        UIFont.familyNames.forEach({ familyName in
            let fontNames = UIFont.fontNames(forFamilyName: familyName)
            print(familyName, fontNames)
        })
    }
}
