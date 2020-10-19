//
//  ForgotPasswordPhoneInteractor.swift
//  WhiteLabel
//
//  Created by hb on 09/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

/// Protocol for Forgot Password Phone API
protocol ForgotPasswordPhoneBusinessLogic {
    /// Call Forgot password API
    ///
    /// - Parameter phone: Phone String
    func forgotPassword(phone: String)
}

/// Protocol for Forgot Password Phone Data Store
protocol ForgotPasswordPhoneDataStore {
    
}

/// Class for forgot password phone interactor
class ForgotPasswordPhoneInteractor: ForgotPasswordPhoneBusinessLogic, ForgotPasswordPhoneDataStore {
    /// Presentor instance
    var presenter: ForgotPasswordPhonePresentationLogic?
    /// Worker instance
    var worker: ForgotPasswordPhoneWorker?
    
    /// Call Forgot password API
    ///
    /// - Parameter phone: Phone String
    func forgotPassword(phone: String) {
        worker = ForgotPasswordPhoneWorker()
        worker?.forgotPassword(phone: phone, completionHandler: { (response, message, success) in
            self.presenter?.presentForgotPasswordResponse(response: response, message: message ?? "", success: success ?? "0")
        })
    }
}
