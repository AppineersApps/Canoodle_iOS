//
//  ChangePasswordPresenter.swift
//  Udecide
//
//  Created by hb on 15/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for presentation
protocol ChangePasswordPresentationLogic {
    /// Present Change password response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - success: API Success
    func presentChangePassword(message: String, success: String)
}

/// Presenter class for API Response
class ChangePasswordPresenter: ChangePasswordPresentationLogic {
    /// View controller instance for Chaneg Password
    weak var viewController: ChangePasswordDisplayLogic?
    
    /// Present Change password response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - success: API Success
    func presentChangePassword(message: String, success: String) {
        self.viewController?.didReceivecChangePasswordResponse(message: message, success: success)
    }
}
