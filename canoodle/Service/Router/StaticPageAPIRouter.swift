//
//  StaticPageAPIRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 20/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Static page router
enum StaticPageAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Static Page Case
    case staticPage(request:StaticPage.Request)
    /// Static Page Version Update Case
    case staticPageVersionUpdate(request:StaticPage.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .staticPage:
            return "/static_pages"
        case .staticPageVersionUpdate:
            return "/update_page_version"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        switch self {
        case .staticPage(let request):
            return [
                "page_code": request.pageCode
            ]
        case .staticPageVersionUpdate(let request):
            return [
                "page_type": request.pageCode
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
