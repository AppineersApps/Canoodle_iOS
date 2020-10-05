//
//  EditProfileAPIRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Edit profile API router
enum  EditProfileAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Edit Profile Case
    case editProfile(request: EditProfile.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .editProfile:
            return "edit_profile"
            
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
            
        case .editProfile(let request):
            params = [
                "first_name": request.firstName,
                "last_name": request.lastName,
                "user_name": request.userName,
                "mobile_number": request.mobileNo,
                "user_profile": request.userProfile,
                "dob": request.dob,
                "address": request.address,
                "city": request.city,
                "latitude": request.lat,
                "longitude": request.long,
                "state_id": request.stateId,
                "zipcode": request.zipCode
            ]
            return params
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
        case .editProfile(let request):
            var arrMultiPart = [MultiPartData]()
            arrMultiPart.append(MultiPartData(fileName: request.userProfileName, data: request.userProfile, paramKey: "user_profile", mimeType: request.userProfileName.fileExtension(), fileKey: "user_profile"))
            return arrMultiPart
        }
        
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
