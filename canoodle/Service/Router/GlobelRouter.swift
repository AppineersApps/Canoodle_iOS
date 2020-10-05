//
//  LoginRouter.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//
import Foundation
import Alamofire

/// Global router to be user throughtout app without login
enum GlobelRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }

    case createToken
    case countryList
    case stateList(countryId: String)

    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .createToken:
            return "create_token"
        case .countryList:
            return "country_list"
        case .stateList:
            return "country_with_states"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        switch self {
        case .stateList(let country_id):
            return ["country_id": country_id]
        default:
            return nil
        }
    }
    
    /// Parameter Encoding required
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.httpBody
    }
    
    /// Headers for the url request
    var headers: [String: String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    /// Files if required to attach
    var files: [MultiPartData]? {
        return nil
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return nil
    }
}
