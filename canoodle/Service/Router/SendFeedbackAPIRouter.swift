//
//  SendFeedbackAPIRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import Alamofire

/// Send Feedback API Router
enum SendFeedbackAPIRouter: RouterProtocol {
    
    /// Base URL String
    var baseUrlString: String {
        return AppConstants.baseUrl
    }
    
    /// Send Feedback Case
    case sendFeedback(request: SendFeedback.Request)
    /// Send log file to Admin Case
    case sendAdminLog(request: SendAdminLog.Request)
    /// Send log database file to Admin Case
    case sendAdminDatabaseLog(request: SendAdminLog.Request)
    
    /// HTTP Method
    var method: HTTPMethod {
        return .post
    }
    
    /// Path for API
    var path: String {
        return "/post_a_feedback"
    }
    
    /// Parameters for API
    var parameters: [String: Any]? {
        switch self {
        case .sendFeedback(let request):
            return [
                "feedback": request.postdescription,
                "images_count": request.imageCount,
                "device_token": UserDefaultsManager.deviceToken,
                "device_model": AppConstants.device_model,
                "device_os": AppConstants.os_version
            ]
            case .sendAdminLog(let request),.sendAdminDatabaseLog(let request):
               return [
                   "feedback": request.fileName,
                   "images_count": "2",
                   "device_token": UserDefaultsManager.deviceToken,
                   "device_model": AppConstants.device_model,
                   "device_os": AppConstants.os_version

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
        case .sendFeedback(let request):
            var arrMultiPart = [MultiPartData]()
            
            var imageData = [Data]()
            for pickedImage in request.imageArray {
                let data = pickedImage.jpegData(compressionQuality: 0.5)
                imageData.append(data!)
            }
            
            if request.imageArray.count > 0 {
                for count in 0...request.imageArray.count - 1 {
                    arrMultiPart.append(MultiPartData(fileName: "image_\(count + 1).jpg", data: imageData[count] as Data, paramKey: "image_\(count + 1)", mimeType: "image/jpg", fileKey: "image_\(count + 1)"))
                }
            }
            return arrMultiPart
            case .sendAdminLog(let request):
                       
               var arrMultiPart = [MultiPartData]()
               arrMultiPart.append(MultiPartData(fileName: request.fileName, data: request.logFile, paramKey: "image_1", mimeType: "text/plain", fileKey:  "image_1"))
                arrMultiPart.append(MultiPartData(fileName: request.databasefileName, data: request.logDatabase, paramKey: "image_2", mimeType: "application/zip", fileKey:  "image_2"))
               //request.fileName
               return arrMultiPart
               
            case .sendAdminDatabaseLog(let request):
                      
              var arrMultiPart = [MultiPartData]()
              arrMultiPart.append(MultiPartData(fileName: request.databasefileName, data: request.logDatabase, paramKey: "image_1", mimeType: "application/zip", fileKey:  "image_1"))
              //request.fileName
              return arrMultiPart
        }
    }
    
    /// Get Device Info
    var deviceInfo: [String : Any]? {
        return APIDeviceInfo.deviceInfo
    }
}
