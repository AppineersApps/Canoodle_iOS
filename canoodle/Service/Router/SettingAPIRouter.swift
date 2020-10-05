//
//  SettingAPIRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Settings API Router
enum SettingAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Change Password Case
    case changePassword(request: ChangePassword.Request)
    /// Change Phone Number Case
    case changePhoneNumber(request: ChangeMobileNumber.Request)
    /// Go Ad Free Case
    case goAddFree(request: GoAddFree.Request)
    /// Logout Case
    case logout
    /// Update push notification setting Case
    case updatePushNotificationSetting(request: UpdatePushNotificationSetting.Request)
    ///Delete Account Case
    case deleteAccount
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .changePassword:
            return "/change_password"
        case .changePhoneNumber:
            return "/change_mobile_number"
        case .goAddFree:
            return "/go_ad_free"
        case .logout:
            return "/logout"
        case .updatePushNotificationSetting:
            return "/update_push_notification_settings"
        case .deleteAccount:
            return "/delete_account"
        }
    }
    
    /// Parameter for API
    var parameters: [String: Any]? {
        switch self {
        case .changePassword(let request):
            return [
                "old_password": request.oldPassword,
                "new_password": request.newPassword
//                "user_id": UserDefaultsManager.getLoggedUserDetails()?.userId ?? "",
            ]
        case .changePhoneNumber(let request):
            return [
                "new_mobile_number": request.mobileNumber
//                "user_id": UserDefaultsManager.getLoggedUserDetails()?.userId ?? "",
            ]
        case .goAddFree(let request):
            return [
                "one_time_transaction_data": request.oneTimeTransactionData
            ]
        case .logout:
            return [
                "user_id": UserDefaultsManager.getLoggedUserDetails()?.userId ?? ""
            ]
            
        case .deleteAccount:
            return [
                "user_id": UserDefaultsManager.getLoggedUserDetails()?.userId ?? ""
            ]
            
        case .updatePushNotificationSetting(let request):
           return [
//                "user_id": UserDefaultsManager.getLoggedUserDetails()?.userId ?? "",
                "notification": request.notification
            ]
        }
        
    }
    
    /// Parameter Encoding required
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    /// Headers for the url request
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN": UserDefaultsManager.getLoggedUserDetails()?.authToken ?? ""]
    }
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        return nil
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
