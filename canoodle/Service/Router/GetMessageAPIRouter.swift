//
//  GetMessageAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 19/10/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

enum GetMessageAPIRouter: GetRouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// getUsers Case
    case getMessages

    /// HTTP Method
    var method: HTTPMethod {
        switch self {
            case .getMessages:
                return .get
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .getMessages:
                var components = URLComponents(string: AppConstants.baseUrl + "/get_message_list")!
               return components.url!.absoluteString
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .getMessages:
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
        return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN": UserDefaultsManager.getLoggedUserDetails()?.authToken ?? ""]
    }

    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}



