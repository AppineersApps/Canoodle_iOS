//
//  EditProfileWorker.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.
//  Copyright (c) 2019 hb. All rights reserved.

import UIKit

/// Class for Edit Profile API call
class EditProfileWorker {
    /// API call for state list
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getStateListResponse(completionHandler: @escaping ([StateList.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.stateList) { (responce: WSResponse<StateList.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
            
        }
    }
    /// API call for edit profile
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getEditProfileResponse(request: EditProfile.Request, completionHandler: @escaping ([Login.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: EditProfileAPIRouter.editProfile(request: request)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
            
        }
    }
}
