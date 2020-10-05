//
//  MultiPartData.swift
//  Note
//
//  Created by HB1 on 03/10/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation
import UIKit

/// Struct to define mutlipart data to be sent to API
public struct MultiPartData {
    /// File name of upload file
    var fileName: String!
    /// Data in binary format
    var data: Data!
    /// Param for multipart
    var paramKey: String!
    /// Mime type for uplaod file
    var mimeType: String!
    /// File Key (API Key)
    var fileKey: String?
}
