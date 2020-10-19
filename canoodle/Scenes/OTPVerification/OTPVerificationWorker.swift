//
//  OTPVerificationWorker.swift
//  AppineersWhiteLabel
//
//  Created by hb on 04/09/19.

import UIKit

/// Class for OTP Verification
class OTPVerificationWorker {
    /// API call for phont sign up
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getPhoneSignUpResponse(request: SignUp.SignUpPhoneModel.Request, completionHandler: @escaping ([Login.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: AuthRouter.signUpWithPhone(request: request)) { (responce: WSResponse<Login.ViewModel>?, error: NetworkError?) in
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
    /// API call for forgot password
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func forgotPassword(phone: String, completionHandler: @escaping (ForgotPasswordPhone.ViewModel?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: ForgotPasswordRouter.forgotPasswordPhone(phone: phone)) { (responce: WSResponse<ForgotPasswordPhone.ViewModel>?, error: NetworkError?) in
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
    /// API call for change mobile number
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func changeMobileNumber(request: ChangeMobileNumber.Request, completionHandler: @escaping (_ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: SettingAPIRouter.changePhoneNumber(request: request)) { (responce: WSResponse<Setting.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if  detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(msg, detail.setting?.success)
                } else {
                    completionHandler(detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(error?.erroMessage(), "0")
            }
        }
    }
}
