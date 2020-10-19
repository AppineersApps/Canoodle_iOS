//
//  SendFeedbackWorker.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.

import UIKit

/// Class for Send feedback API call
class SendFeedbackWorker {
  
    /// API call for send feedback
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func sendFeedback(request: SendFeedback.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: SendFeedbackAPIRouter.sendFeedback(request: request)) { (responce: WSResponse<SendFeedback.Response>?, error: NetworkError?) in
            if let detail = responce {
                if  detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(error?.erroMessage(), "0")
            }
        }
    }
}
