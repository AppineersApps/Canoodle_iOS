//
//  SettingRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 23/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for settings routing
protocol SettingRoutingLogic {
    func redirectToLogin()
}

/// Protocol for settings data passing
protocol SettingDataPassing {
    var dataStore: SettingDataStore? { get set }
}

/// Class for settings router
class SettingRouter: NSObject, SettingRoutingLogic, SettingDataPassing {
    /// Viewcontroller instance
    weak var viewController: SettingViewController?
    /// Datastore instance
    var dataStore: SettingDataStore?
    
    /// Redirect to login
    func redirectToLogin() {
        UserDefaultsManager.logoutUser()
        GlobalUtility.redirectToLogin()
    }
}