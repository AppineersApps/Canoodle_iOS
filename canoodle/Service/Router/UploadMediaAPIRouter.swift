//
//  AddPostAPIRouter.swift
//  Chinwag
//
//  Created by TheAppineers on 01/01/20.
//  Copyright © 2020 TheAppineers. All rights reserved.
//

import Foundation
import Alamofire

/// Upload Media API Router
enum UploadMediaAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Send Feedback Case
    case uploadMedia(request: UploadMedia.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        switch self {
        case .uploadMedia:
            return "/user_list"
        }
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        switch self {
        case .uploadMedia(let request):
            return [
                "media_file_count": "\(request.imageArray.count)",
                "media_url": "",
                "media_name": "",
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
        case .uploadMedia(var request):
            var arrMultiPart = [MultiPartData]()
            
           /* var imageData = [Data]()
            for media in request.mediaArray {
                let data = media.image!.jpegData(compressionQuality: 0.5)
                imageData.append(data!)
            }*/
            var index: Int = 0
            if request.imageArray.count > 0 {
                for count in 0...request.imageArray.count-1 {
                   // let media: Media.ViewModel = request.mediaArray[count]
                    let image = request.imageArray[count]
                    let data = image.pngData()
                    index += 1
                    arrMultiPart.append(MultiPartData(fileName: "media_\(index).png", data: data, paramKey: "media_file_\(index)", mimeType: "image/png", fileKey: "media_file_\(index)"))
                }
            }
            return arrMultiPart
        }
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
