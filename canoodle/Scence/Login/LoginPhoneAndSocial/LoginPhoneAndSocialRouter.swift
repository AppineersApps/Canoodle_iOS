//
//  LoginPhoneAndSocialRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 16/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for Login routing
protocol LoginPhoneAndSocialRoutingLogic {
    func redirectToHome()
    func navigateToSignup()
}

/// Protocol for Login data passing
protocol LoginPhoneAndSocialDataPassing {
    var dataStore: LoginPhoneAndSocialDataStore? { get set }
}

/// Class for Login router
class LoginPhoneAndSocialRouter: NSObject, LoginPhoneAndSocialRoutingLogic, LoginPhoneAndSocialDataPassing {
    /// Viewcontroller instance
    weak var viewController: LoginPhoneAndSocialViewController?
    /// Datastore instance
    var dataStore: LoginPhoneAndSocialDataStore?
    
    /// Redirect to home
    func redirectToHome() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            AppConstants.appDelegate.window?.rootViewController = tab
        }
    }
    
    /// Navigate to Sign up
    func navigateToSignup() {
        if let signUpVC = SignUpViewController.instance() {
            signUpVC.isSocialType = self.viewController?.socialLoginType ?? ""
            signUpVC.facbookUserData = self.viewController?.facebookDict ?? [String:AnyObject]()
            signUpVC.googleDict = self.viewController?.googleDict
            signUpVC.appleUserData = self.viewController?.appleDict ?? [String:AnyObject]()
            self.viewController?.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
}
