//
//  UIImageView+Extension.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


extension UIImageView {
    /// Method is user to download image asynchronuosly
    ///
    /// - Parameters:
    ///   - url: URL to download
    ///   - placeHolder: Placeholder image to show
    ///   - completed: Completion handler is called when image is downloaded
    func setImage(with url: String?, placeHolder: UIImage? = nil, completed: (() -> Void)? = nil) {
        if let urlString = url {
            let url = URL(string: urlString)
            //         self.kf.indicatorType = .activity
            self.kf.setImage(with: url, placeholder: placeHolder, options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ], progressBlock: nil)
//            { (result) in
//                completed?()
//            }
        } else {
            self.image = placeHolder
        }
    }
    
    /// Change color of image
    ///
    /// - Parameter color: Color of the image
    func changePngColorTo(color: UIColor){
        guard let image =  self.image else {return}
        self.image = image.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
        
    }
    
}
