//
//  ChangeMobileNumberPresenter.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.

import UIKit

/// Protocol for presentation
protocol ChangeMobileNumberPresentationLogic {
    /// Present OTP Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentOtp(response: CheckUniqueUser.ViewModel?, message: String, success: String)
}

/// Presenter class for API Response
class ChangeMobileNumberPresenter: ChangeMobileNumberPresentationLogic {
    
    /// View controller instance for Change Phone Number
    weak var viewController: ChangeMobileNumberDisplayLogic?
    
    /// Present OTP Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentOtp(response: CheckUniqueUser.ViewModel?, message: String, success: String) {
        viewController?.didReceivecOtpResponse(response: response, message: message, success: success)
    }
    
}
