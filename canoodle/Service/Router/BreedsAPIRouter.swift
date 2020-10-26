//
//  BreedsAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 22/10/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

enum BreedsAPIRouter: GetRouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Get Breeds Case
    case getBreeds


    /// HTTP Method
    var method: HTTPMethod {
        switch self {
            case .getBreeds:
                return .get
        }
    }
    
    /// Path for API
    var path: String {
        switch self {
            case .getBreeds:
                return AppConstants.baseUrl + "/breed_list"

        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            case .getBreeds:
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
            case .getBreeds:
                return ["Content-Type": "application/x-www-form-urlencoded", "AUTHTOKEN": UserDefaultsManager.getLoggedUserDetails()?.authToken ?? ""]
        }
        
    }

    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}


