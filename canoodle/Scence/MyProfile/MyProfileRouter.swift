//
//  MyProfileRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit

/// Protocol for routing
protocol MyProfileRoutingLogic {
    func redirectToEditProfile()
}

/// Protocol for data passing
protocol MyProfileDataPassing {
    var dataStore: MyProfileDataStore? { get set }
}

/// Class for My Profile Router
class MyProfileRouter: NSObject, MyProfileRoutingLogic, MyProfileDataPassing {
    
    /// Viewcontroller instance for my profile view controller
    weak var viewController: MyProfileViewController?
    /// Data store to pass data
    var dataStore: MyProfileDataStore?
    
    /// Redirect to edit profile
    func redirectToEditProfile() {
        if let VC = EditProfileViewController.instance() {
            viewController?.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
}
