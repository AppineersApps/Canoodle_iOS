//
//  APIDeviceInfo.swift
//  BaseProject
//
//  Created by hb on 02/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

/// API Deviceinfo to be sent to server
class APIDeviceInfo: NSObject {
    
    /// Class for Device info
    class var deviceInfo: [String: Any] {
        
        /// Device info dictionary
        var infoParams = [String: Any]()
        infoParams["device_type"] = AppConstants.platform
        infoParams["device_os"] = AppConstants.os_version
        infoParams["device_token"] = UserDefaultsManager.deviceToken
        infoParams["device_name"] = AppConstants.device_name
        infoParams["app_version"] = AppInfo.kAppVersion
        infoParams["device_udid"] = UIDevice.current.identifierForVendor?.uuidString ?? ""
        infoParams["access_token"] = AppConstants.accessToken ?? ""
        infoParams[UserDefaultsKey.ws_token] = UserDefaultsManager.webServiceToken
        return infoParams
    }
}

// MARK: - Device extension
extension UIDevice {
    
    /// Is Simulator 
    var isSimulator: Bool {
        #if IOS_SIMULATOR
        return true
        #else
        return false
        #endif
    }
}
