//
//  OTPVerificationRouter.swift
//  AppineersWhiteLabel
//
//  Created by hb on 04/09/19.

import UIKit

/// Protocol for OTP Verification routing
@objc protocol OTPVerificationRoutingLogic {
    func redirectToHome()
}

/// Protocol for OTP Verification data passing
protocol OTPVerificationDataPassing {
    var dataStore: OTPVerificationDataStore? { get }
}

/// Class for OTP Verification router
class OTPVerificationRouter: NSObject, OTPVerificationRoutingLogic, OTPVerificationDataPassing {
    
    /// Viewcontroller instance
    weak var viewController: OTPVerificationViewController?
    /// Datastore instance
    var dataStore: OTPVerificationDataStore?
    
    /// Redirect to home
    func redirectToHome() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            AppConstants.appDelegate.window?.rootViewController = tab
        }
    }
    
}
