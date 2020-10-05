//
//  ForgotPasswordRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 19/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

enum ForgotPasswordRouter: RouterProtocol {
    
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Forgot password with email Case
    case forgotPasswordEmail(email: String)
    /// Forgot password with phone Case
    case forgotPasswordPhone(phone: String)
    /// Reset Password Case
    case resetPassword(request: ResetPassword.Request)
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        switch self {
        case .forgotPasswordEmail:
            return "forgot_password"
        case .forgotPasswordPhone:
            return "forgot_password_phone"
        case .resetPassword:
            return "reset_password_phone"
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .forgotPasswordEmail(let email):
            params = [
                "email": email
            ]
        case .forgotPasswordPhone(let phone):
            params = [
                "mobile_number": phone
            ]
        case .resetPassword(let request):
            params = [
                "mobile_number": request.mobileNumber,
                "new_password": request.newPassword,
                "reset_key": request.resetKey
            ]
        }
        
        return params
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN":""]
    }
    
    var files: [MultiPartData]? {
        return nil
    }
    
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
