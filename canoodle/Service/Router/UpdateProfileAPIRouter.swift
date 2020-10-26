//
//  UpdateProfileAPIRouter.swift
//  canoodle
//
//  Created by Appineers India on 23/10/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

/// Update Profile API Router
enum UpdateProfileAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Send Feedback Case
    case updateProfile(request: UpdateProfile.Request)
    case updatePetProfile(request: UpdatePetProfile.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .updateProfile:
            return "/mad_collab_user"
        case .updatePetProfile:
            return "/mad_collab_user"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        switch self {
        case .updateProfile(let request):
            return [
                "media_file_count": "0",
                "media_url": "",
                "media_name": "",
                "description": request.description
            ]
        case .updatePetProfile(let request):
            return [
                "pet_name": request.petName,
                "breed": request.breed,
                "pet_age": request.petAge,
                "description": request.description
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

