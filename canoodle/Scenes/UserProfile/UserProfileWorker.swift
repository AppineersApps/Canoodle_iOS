//
//  UserProfileWorker.swift
//  canoodle
//
//  Created by Appineers India on 15/10/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class UserProfileWorker
{
    func getUserProfile(request: UserProfile.Request, completionHandler: @escaping ([User.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        GetNetworkService.dataRequest(with: UserAPIRouter.getUserProfile(request: request), showHud: true) { (responce: WSResponse<User.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let data = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(data, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage() ?? AlertMessage.defaultError, "0")
            }
        }
    }
}
