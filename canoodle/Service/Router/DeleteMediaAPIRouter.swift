//
//  DeleteMediaAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 27/10/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

enum DeleteMediaAPIRouter: GetRouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// delete media Case
    case deleteMedia(request: DeleteMedia.Request)


    /// HTTP Method
    var method: HTTPMethod {
        switch self {
            case .deleteMedia:
                return .delete
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .deleteMedia:
                return AppConstants.baseUrl + "/mad_collab_user"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .deleteMedia(let request):
                params = [
                    "media_id" : request.media_id
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
