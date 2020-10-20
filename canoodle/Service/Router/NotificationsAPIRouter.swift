//
//  NotificationsAPIRouter.swift
//  Time2Beat
//
//  Created by Appineers India on 07/09/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

enum NotificationsAPIRouter: GetRouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Search Friends Case
    case getNotifications
    case clearNotifications


    /// HTTP Method
    var method: HTTPMethod {
        switch self {
            case .getNotifications:
                return .get
            case .clearNotifications:
                return .delete
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .getNotifications:
                return AppConstants.baseUrl + "/notification"
            case .clearNotifications:
                return AppConstants.baseUrl + "/notification"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .getNotifications:
                 return nil
            case .clearNotifications:
                return nil
        }
        return params
    }
    
    /// Parameter Encoding required
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    /// Headers for the url request
    var headers: [String: String]? {
        switch self {
            case .getNotifications:
                return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN": UserDefaultsManager.getLoggedUserDetails()?.authToken ?? ""]
            case .clearNotifications:
                return ["Content-Type": "application/json", "AUTHTOKEN": UserDefaultsManager.getLoggedUserDetails()?.authToken ?? ""]
        }
        
    }

    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}

