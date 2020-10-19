//
//  SignUpRouter.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Protocol for sign up routing
protocol SignUpRoutingLogic {
    func redirectToOtpVarification(phoneNumber: String, otp: String, signUpRequest: SignUp.SignUpPhoneModel.Request?, socialSignUpRequest: SignUp.SignUpSocialModel.Request?, socialLogin: Bool)
    func redirectToHome()
}

/// Protocol for signup data passing
protocol SignUpDataPassing {
    var dataStore: SignUpDataStore? { get }
}

/// Class for sign up router
class SignUpRouter: NSObject, SignUpRoutingLogic, SignUpDataPassing {
    
    /// Viewcontroller instance
    weak var viewController: SignUpViewController?
    /// Datastore instance
    var dataStore: SignUpDataStore?
    
    /// Redirect to OTP
    ///
    /// - Parameters:
    ///   - phoneNumber: Phone number
    ///   - otp: OTP
    ///   - signUpRequest: Sign up Request
    ///   - socialSignUpRequest: Social Request
    ///   - socialLogin: IS Social Login
    func redirectToOtpVarification(phoneNumber: String, otp: String, signUpRequest: SignUp.SignUpPhoneModel.Request?, socialSignUpRequest: SignUp.SignUpSocialModel.Request?, socialLogin: Bool) {
        if let otpVC = OTPVerificationViewController.instance() {
            otpVC.phoneNumber = phoneNumber
            otpVC.otp = otp
            otpVC.signUpRequest = signUpRequest
            otpVC.isFrom = "SignUp"
            otpVC.socialLogin = socialLogin
            otpVC.socialSignUpRequest = socialSignUpRequest
            viewController?.navigationController?.pushViewController(otpVC, animated: true)
        }
    }
    
    /// Redirect to home
    func redirectToHome() {
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            AppConstants.appDelegate.window?.rootViewController = tab
        }
    }
}
