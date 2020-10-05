//
//  OTPVerificationInteractor.swift
//  AppineersWhiteLabel
//
//  Created by hb on 04/09/19.

import UIKit

/// Protocol for OTP Verification API
protocol OTPVerificationBusinessLogic {
    /// Call Sign up Phone API
    ///
    /// - Parameter request: Sign up Phone API Request
    func callSignUpPhoneAPI(request: SignUp.SignUpPhoneModel.Request)
    /// Call Check Unique user API
    ///
    /// - Parameter request: Ubnique User API Request
    func checkUniqUser(request: CheckUniqueUser.Request)
    /// Call Social Sign up API
    ///
    /// - Parameter request: Social sign up API Request
    func callSocialSignUpAPI(request: SignUp.SignUpSocialModel.Request)
    /// Call Forgot password API
    ///
    /// - Parameter phone: Phone String
    func forgotPassword(phone: String)
    /// Call change phone number API
    ///
    /// - Parameter request: Change Mobile Number Request
    func changePhoneNumber(request: ChangeMobileNumber.Request)
}

/// Protocol for OTP Verification Data Store
protocol OTPVerificationDataStore {
    //var name: String { get set }
}

/// Class for OTP Verification interactor
class OTPVerificationInteractor: OTPVerificationBusinessLogic, OTPVerificationDataStore {
    /// Presentor instance
    var presenter: OTPVerificationPresentationLogic?
    /// Worker instance
    var worker: OTPVerificationWorker?
    
    /// Call Sign up Phone API
    ///
    /// - Parameter request: Sign up Phone API Request
    func callSignUpPhoneAPI(request: SignUp.SignUpPhoneModel.Request) {
        worker = OTPVerificationWorker()
        worker?.getPhoneSignUpResponse(request: request, completionHandler: { (response, message, successCode) in
            self.presenter?.presentPhoneSignUpResponse(response: response, message: message ?? "", successCode: successCode ?? "0")
        })
    }
    
    /// Call Check Unique user API
    ///
    /// - Parameter request: Ubnique User API Request
    func checkUniqUser(request: CheckUniqueUser.Request) {
        worker = OTPVerificationWorker()
        worker?.checkUniqueUser(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentUniqeUser(response: response, message: message ?? "", success: success ?? "0")
        })
    }
    
    /// Call Social Sign up API
    ///
    /// - Parameter request: Social sign up API Request
    func callSocialSignUpAPI(request: SignUp.SignUpSocialModel.Request) {
        worker = OTPVerificationWorker()
        worker?.getSocialSignUpResponse(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentSocialSignUpResponse(response: response, message: message ?? "", successCode: success ?? "0")
        })
    }
    
    /// Call forgot password API
    ///
    /// - Parameter phone: Phone String
    func forgotPassword(phone: String) {
        worker = OTPVerificationWorker()
        worker?.forgotPassword(phone: phone, completionHandler: { (response, message, success) in
            self.presenter?.presentForgotPasswordResponse(response: response, message: message ?? "", success: success ?? "0")
        })
    }
    
    /// Call change phone number API
    ///
    /// - Parameter request: Change Mobile Number Request
    func changePhoneNumber(request: ChangeMobileNumber.Request) {
        worker = OTPVerificationWorker()
        worker?.changeMobileNumber(request: request, completionHandler: { (message, success) in
            self.presenter?.presentChangeMobileNumberResponse(message: message ?? "", success: success ?? "0")
        })
    }
}
