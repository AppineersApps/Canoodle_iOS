//
//  UIImage+Extension.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// Compress image to desired size
    ///
    /// - Parameter expectedSizeInMb: Expected size in MB
    /// - Returns: Returns the image 
    func compressTo(_ expectedSizeInMb:Double) -> Data? {
        let sizeInBytes = expectedSizeInMb * 1024 * 1024
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < Int(sizeInBytes) {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < Int(sizeInBytes)) {
                return data
            }
        }
        return nil
    }
    
    
}
