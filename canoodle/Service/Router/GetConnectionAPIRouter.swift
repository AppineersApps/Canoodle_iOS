//
//  GetConnectionAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 19/10/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

enum GetConnectionAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// getUsers Case
    case getConnections(request: Connection.Request)

    /// HTTP Method
    var method: HTTPMethod {
        switch self {
            case .getConnections:
                return .get
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .getConnections(let request):
                var components = URLComponents(string: AppConstants.baseUrl + "/connections")!
               components.queryItems = [
                URLQueryItem(name: "connection_type", value: request.connectionType),
               ]
               return components.url!.absoluteString
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .getConnections:
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
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        return nil
    }
}


