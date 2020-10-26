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
    case deleteMessage(request: DeleteMessage.Request)


    /// HTTP Method
    var method: HTTPMethod {
        switch self {
            case .getMessages:
                return .get
            case .deleteMessage:
                return .delete
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .getMessages:
                var components = URLComponents(string: AppConstants.baseUrl + "/get_message_list")!
               return components.url!.absoluteString
            case .deleteMessage:
                return AppConstants.baseUrl + "/get_message_list"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .getMessages:
                return nil
            case .deleteMessage(let request):
                params = [
                    "message_id" : request.message_id
                ]
                return params
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



