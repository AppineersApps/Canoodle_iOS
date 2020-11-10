//
//  SessionManager.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation
import UIKit
#if canImport(TALogger)
import TALogger
#endif

/// Sturct for user defaults manager
struct UserDefaultsManager {
    /// Userdefaults instance
    static let applicationDefaults = UserDefaults.standard
    
    /// Get User Details object
    static private var userDetails: Login.ViewModel?
    /// State list data
    static private var stateList: StateList.ViewModel?
    
    static var filter: Filter?

    /// Get Device token for push
    static var deviceToken: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.deviceTokenKey) ?? "Error:\(AppConstants.deviceId ?? "")"
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.deviceTokenKey)
        }
    }
    
    
    
    /// Notification enable/disable state maintain
    static var notificationEnable: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.notificationEnable) ?? "Yes"
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.notificationEnable)
        }
    }
    
    /// Webservice token to be passed in every webservice
    static var webServiceToken: String {
        get {
            return applicationDefaults.string(forKey: UserDefaultsKey.ws_token) ?? ""
        }
        set {
            applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.ws_token)
        }
    }
    
    /// Set logged in user details
    ///
    /// - Parameter userDetail: Get user details
    static func setLoggedUserDetails(userDetail: Login.ViewModel) {
        #if canImport(TALogger)
        if(userDetail.logStatus == "Active") {
            TALogger.shared.enable()
            TALogger.shared.disableAutoNetworkLog()
        }
        else if(AppConstants.isDebug == false){
            TALogger.shared.clearLogs()
            TALogger.shared.disable()
        }
        #endif

        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(userDetail)
        applicationDefaults.setValue(encodedData, forKey: UserDefaultsKey.userDetail)
        applicationDefaults.synchronize()
    }
    

    /// Logout user
    static func logoutUser() {
        userDetails = nil
        applicationDefaults.removeObject(forKey: UserDefaultsKey.userDetail)
    }
    
    /// Get logged in user details
    ///
    /// - Returns: returns logged in user model object
    static func getLoggedUserDetails() -> Login.ViewModel? {
        if let decoded = applicationDefaults.object(forKey: UserDefaultsKey.userDetail) as? Data {
            let decoder = JSONDecoder()
            let decodedUser = try? decoder.decode(Login.ViewModel.self, from: decoded)
            userDetails = decodedUser
        }
        return userDetails
    }
    
    static func resetFilter() {
        var dictionary: [String:String] = [:]
         dictionary.updateValue("All", forKey: "Gender")
        dictionary.updateValue("5", forKey: "Distance")
       // dictionary.updateValue("99", forKey: "MaxAge")
        filter = Filter(dictionary: dictionary)
        saveFilter(filter: filter!)
    }
    
    static func setFilter(filter: Filter) {
        UserDefaultsManager.self.filter = filter
        saveFilter(filter: filter)
    }
    
    static func getFilter() -> Filter {
        loadFilter()
        if(filter == nil) {
            resetFilter()
        }
        return filter!
    }
    
    static func saveFilter(filter: Filter) {
        applicationDefaults.setValue(filter.gender, forKey: "Gender")
        applicationDefaults.setValue(filter.distance, forKey: "Distance")
       // applicationDefaults.setValue(filter.minAge, forKey: "MinAge")
       // applicationDefaults.setValue(filter.maxAge, forKey: "MaxAge")
        applicationDefaults.synchronize()
    }
    
    static func loadFilter() {
        if(applicationDefaults.string(forKey: "Gender") == nil) {
            resetFilter()
        }
            var dictionary: [String:String] = [:]
            dictionary.updateValue(applicationDefaults.string(forKey: "Gender")!, forKey: "Gender")
            dictionary.updateValue(applicationDefaults.string(forKey: "Distance")!, forKey: "Distance")
           // dictionary.updateValue(applicationDefaults.string(forKey: "MinAge")!, forKey: "MinAge")
           // dictionary.updateValue(applicationDefaults.string(forKey: "MaxAge")!, forKey: "MaxAge")
            filter = Filter(dictionary: dictionary)
    }
    
    static var onboardingDone: String {
           get {
               return applicationDefaults.string(forKey: UserDefaultsKey.onboarding) ?? "No"
           }
           set {
               applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.onboarding)
           }
    }
    
    static var likeCount: Int {
           get {
               return applicationDefaults.integer(forKey: "Likes") ?? 0
           }
           set {
               applicationDefaults.setValue(newValue, forKey: "Likes")
           }
    }
    
    static var profileSetUpDone: String {
           get {
            return applicationDefaults.string(forKey: UserDefaultsKey.profileSetUp) ?? "Yes"
           }
           set {
               applicationDefaults.setValue(newValue, forKey: UserDefaultsKey.profileSetUp)
           }
       }
}
