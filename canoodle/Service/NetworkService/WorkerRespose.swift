//
//  WorkerRespose.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation

/// Worker class response
///
/// - success: Success
/// - failure: Failure
enum WorkerResponse<T> {
    /// - success: Success
    case success(T)
    /// - failure: Failure
    case failure(Error)
}
