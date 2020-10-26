//
//  MessageAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 23/10/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

enum MessageAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Report User Case
    case sendMessage(request: SendMessage.Request)

    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .sendMessage:
            return "/send_message"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .sendMessage(let request):
            params = [
                "receiver_id": request.receiverId,
                "firebase_id": request.firebaseId,
                "message": request.message
            ]
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
    
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        return nil
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}

