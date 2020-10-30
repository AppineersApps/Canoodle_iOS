//
//  SplashWorker.swift
//  Test
//
//  Created by The Appineers on 11/10/19.
//  Copyright (c) 2019 The Appineers. All rights reserved.
//

import UIKit

/// Class for splash API Call
class SplashWorker {
    /// API call for splash API Calls
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func versionCheck(completionHandler: @escaping (Splash.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.versionCheck, showHud: false) { (responce: WSResponse<Splash.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, resparray.count > 0, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( resparray.first, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
        }
    }
}
