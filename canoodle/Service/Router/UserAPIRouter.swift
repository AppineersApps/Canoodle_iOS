//
//  UserAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 16/10/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation
import Alamofire

enum UserAPIRouter: GetRouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// getUsers Case
    case getUsers(request: User.Request)
    case getUserProfile(request: UserProfile.Request)

    /// HTTP Method
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUserProfile:
                return .get
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .getUsers(let request):
                var components = URLComponents(string: AppConstants.baseUrl + "/mad_collab_user")!
               components.queryItems = [
                URLQueryItem(name: "gender_type", value: request.gender)
               ]
               return components.url!.absoluteString
            case .getUserProfile(let request):
                var components = URLComponents(string: AppConstants.baseUrl + "/mad_collab_user")!
               components.queryItems = [
                URLQueryItem(name: "other_user_id", value: request.otherUserId),
               ]
               return components.url!.absoluteString
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .getUsers, .getUserProfile:
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

