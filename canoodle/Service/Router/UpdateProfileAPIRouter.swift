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
            return "/pets"
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
            if(request.petId != "") {
                return [
                "pet_id": request.petId,
                "pet_name": request.petName,
                "breed": request.breed,
                "pet_age": request.petAge,
                "pet_description": request.description,
                "akc_registered": request.akcRegistered
                ]
            } else {
            return [
                "pet_name": request.petName,
                "breed": request.breed,
                "pet_age": request.petAge,
                "pet_description": request.description,
                "akc_registered": request.akcRegistered
            ]
            }
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

