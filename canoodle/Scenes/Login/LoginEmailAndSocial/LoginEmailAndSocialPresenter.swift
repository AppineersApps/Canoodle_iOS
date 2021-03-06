//
//  LoginEmailAndSocialPresenter.swift
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

/// Protocol for login email and social presentor
protocol LoginEmailAndSocialPresentationLogic {
    /// Present login Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentLoginResponse(response: Login.ViewModel?, message: String, success: String)
    /// Present social login Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentSocialLoginResponse(response: Login.ViewModel?, message: String, success: String)
}

/// Class for login email and social presentor
class LoginEmailAndSocialPresenter: LoginEmailAndSocialPresentationLogic {
    weak var viewController: LoginEmailAndSocialDisplayLogic?
    /// Present login Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentLoginResponse(response: Login.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveLoginResponse(response: response, message: message, success: success)
    }
    /// Present social login Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentSocialLoginResponse(response: Login.ViewModel?, message: String, success: String) {
        self.viewController?.didReceiveSocialLoginResponse(response: response, message: message, success: success)
    }
}
