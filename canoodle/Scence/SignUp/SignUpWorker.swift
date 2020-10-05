//
//  SignUpWorker.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Class for sign up API call
class SignUpWorker {
    /// API call for email sign up
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getEmailSignUpResponse(request: SignUp.SignUpEmailModel.Request, completionHandler: @escaping ([Login.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.signUpWithEmail(request: request)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    /// API call for check unique user
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func checkUniqueUser(request: CheckUniqueUser.Request, completionHandler: @escaping ([CheckUniqueUser.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.checkUniqueUser(request: request)) { (responce: WSResponse<CheckUniqueUser.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler( resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
        }
    }
    /// API call for social sign up
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getSocialSignUpResponse(request: SignUp.SignUpSocialModel.Request, completionHandler: @escaping ([Login.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.socialSignUp(request: request)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    /// API call for get state list
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
}
