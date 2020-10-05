//
//  ChangeMobileNumberWorker.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.

import UIKit

/// API class for Change mobile number
class ChangeMobileNumberWorker {
    /// API call for send feedback
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getOtp(request: CheckUniqueUser.Request, completionHandler: @escaping ( CheckUniqueUser.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.checkUniqueUser(request: request)) { (responce: WSResponse<CheckUniqueUser.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, resparray.count > 0, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray.first, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
        }
    }
}
