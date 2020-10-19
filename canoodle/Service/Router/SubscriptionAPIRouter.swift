//
//  SubscriptionAPIRouter.swift
//  HoosOut
//
//  Created by hb on 18/12/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Settings API Router
enum SubscriptionAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    case manageSubscription(request: ManageSubscription.Request)
    
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
            
        case .manageSubscription:
            return "subscription_purchase"
        }
    }
    
    /// Parameter for API
    var parameters: [String: Any]? {
        switch self {
            
        case .manageSubscription(let request):
            return [
                "subscription_id": "monthly",
                "receipt_type": "ios"
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
        switch self {
        case .manageSubscription(let request):
            var arrMultiPart = [MultiPartData]()
            arrMultiPart.append(MultiPartData(fileName: request.fileName, data: request.oneTimeTransactionData, paramKey: "receipt_data", mimeType: "text/plain", fileKey: "receipt_data"))
            return arrMultiPart
        }
        
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}

