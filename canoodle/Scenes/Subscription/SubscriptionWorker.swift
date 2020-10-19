//
//  SubscriptionWorker.swift
//  Tyst
//
//  Created by hb on 27/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

class SubscriptionWorker {
    func manageSubscription(request: ManageSubscription.Request, completionHandler: @escaping (_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: SubscriptionAPIRouter.manageSubscription(request: request)) { (responce: WSResponse<Subscription.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(AlertMessage.defaultError, "0")
            }
        }
    }
}
