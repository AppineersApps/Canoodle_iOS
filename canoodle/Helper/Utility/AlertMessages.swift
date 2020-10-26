//
//  AlertMessages.swift
//  Note
//
//  Created by hb1 on 17/10/18.
//  Copyright © 2018 Hidden Brains. All rights reserved.
//

import Foundation

/// Alert Messages to be used in whole app
struct AlertMessage {
    // General Messages
    static let yes = "Yes"
    static let no = "No"
    static let cancel = "Cancel"
    static let ok = "Ok"
    
    static let shareApp = NSLocalizedString("Try \(AppInfo.kAppName) App on Appstore:\nhttps://itunes.apple.com/us/app/apple-store/id\(AppInfo.kAppstoreID)", comment: "")
    
    static let logoutMessage = NSLocalizedString("You are logged out now because you have logged in from some other device.", comment: "")
    
    static let NetworkError = NSLocalizedString("Server is not responding! Please try after sometime.", comment: "")
    static let InternetError = NSLocalizedString("Please check your internet connection and try again.",comment:"")
    static let defaultError = NSLocalizedString("Something went wrong, Please try again.",comment:"")

    
    static let NetworkTimeOutError = NSLocalizedString("Connection Time Out or Lost.\nPlease try again.", comment: "")
    static let otpSend = NSLocalizedString("OTP Send successfully", comment: "")
    static let success = NSLocalizedString("Success", comment: "")
    static let invalidProjectIdentifer = NSLocalizedString("Invalid Project Identifier Format", comment: "")
    
    // Camera and PhotoLibrary Access
    static let cameraAccess  = "To capture photos, allow \(AppInfo.kAppName) to access camera. Please allow it from settings."
    static let photoLibraryAccess  = "To pick photos, allow \(AppInfo.kAppName) to access photo library. Please allow it from settings."
    
    // Login Messages
    
    static let loginTitle = NSLocalizedString("Login", comment: "")
    static let requireEmail = NSLocalizedString("Please enter email", comment: "")
    static let invalidEmail = NSLocalizedString("Please enter valid email", comment: "")
    static let requireMobile = NSLocalizedString("Please enter phone number", comment: "")
    static let invalidMobile = NSLocalizedString("Please enter valid phone number", comment: "")
    static let requireUserId = NSLocalizedString("Please enter user id", comment: "")
    static let invalidUserId = NSLocalizedString("Please enter valid user id", comment: "")
    static let requirePassword = NSLocalizedString("Please enter password", comment: "")
    static let requireConfirmPassword = NSLocalizedString("Please enter confirm password", comment: "")
    
    
    // Signup Messages
    static let requirefirstName = NSLocalizedString("Please enter first name", comment: "")
    static let requirelastName = NSLocalizedString("Please enter last name", comment: "")
    static let signUpTitle = NSLocalizedString("Create Account", comment: "")
    static let invalidPassword = NSLocalizedString("Password must contain at least 6 to 15 characters, including lower case, upper case and at least one number.", comment: "")
    static let enterUserName = NSLocalizedString("Please enter username", comment: "")
    static let minValueUserName = NSLocalizedString("Username must contain at least 5 characters.", comment: "")
    static let maxValueUserName = NSLocalizedString("Username shoudn't conain more than 20 characters", comment: "")
    static let invalidUserName = NSLocalizedString("Please enter a valid Username. Special characters and white spaces are not allowed.", comment: "")
    
    static let minValueZip = NSLocalizedString("Zipcode must contain more than 5 characters", comment: "")
    static let maxValueZip = NSLocalizedString("Zipcode shoudn't conain more than 10 characters", comment: "")
    static let invalidZip = NSLocalizedString("Invalid Zip code, zip code should not contain whitespaces, numbers or special characters", comment: "")
    
    static let minValueFirstName = NSLocalizedString("Firstname must contain more than 1 character", comment: "")
    static let maxValueFirstName = NSLocalizedString("Firstname shoudn't conain more than 80 characters", comment: "")
    static let invalidFirstName = NSLocalizedString("Please enter a valid first name. Numbers and special characters are not allowed.", comment: "")
    static let minValueLastName = NSLocalizedString("Lastname must contain more than 1 character", comment: "")
    static let maxValueLastName = NSLocalizedString("Lastname shoudn't conain more than 80 characters", comment: "")
    static let invalidLastName = NSLocalizedString("Please enter a valid last name. Numbers and special characters are not allowed.", comment: "")
    static let requiredateOfBirth = NSLocalizedString("Please enter date of birth", comment: "")
    static let passwordConfirmPassword = NSLocalizedString("Password and confirm password must be same", comment: "")
    static let requirestreetAddress = NSLocalizedString("Please select address", comment: "")
    static let requirecity = NSLocalizedString("Please enter city", comment: "")
    static let requirestate = NSLocalizedString("Please enter state", comment: "")
    static let requirezip = NSLocalizedString("Please enter zip code", comment: "")
    static let acceptTermsCondition = NSLocalizedString("To create an account, please agree the terms & conditions and privacy policy.", comment: "")
    static let addProfile = NSLocalizedString("Please add profile picture", comment: "")
    static let backToView = NSLocalizedString("Are you sure you want to discard this registration?", comment: "")
    
    
    
    // ForgotPassword
    static let ForgotPasswordTitle = NSLocalizedString("Forgot Password", comment: "")
    
    
    //OTPVerification
    static let otpVerificationPasswordtitle = NSLocalizedString("Verification Code", comment: "")
    static let optNotMatch = NSLocalizedString("Entered OTP is invalid", comment: "")
    static let optRequire = NSLocalizedString("Please enter OTP", comment: "")
    static let verificationNumber = NSLocalizedString("Please type the verification code sent to \n+1 ", comment: "")
    static let timeOut = NSLocalizedString("Your current OTP is expired. Please resend OTP, to generate the new one", comment: "")
    
    //ResetPassword
    static let resetPasswordTitle = NSLocalizedString("Reset Password", comment: "")
    
    //Setting
    static let SettingTitle = NSLocalizedString("Settings", comment: "")
    static let logOutAlert = "Are you sure you want to logout?"
    static let deleteAccountAlert = "Are you sure you want to delete account?"
    
    //MYProfile
     static let myProfileTitle = NSLocalizedString("My Profile", comment: "")
    
    // Change Password
    static let changePasswordTitle = NSLocalizedString("Change Password", comment: "")
    static let requireOldPassword = NSLocalizedString("Please enter old password", comment: "")
    static let requireNewPassword = NSLocalizedString("Please enter new password", comment: "")
    static let invalidNewPassword = NSLocalizedString("New password length must be between 6 and 15 characters and contain at least one number, one capital letter, one small letter", comment: "")
    static let newConfirmPassword = NSLocalizedString("New Password and confirm password must be same", comment: "")
    
    //EditProfile
    static let editProfileTitle = NSLocalizedString("Edit Profile", comment: "")
    

    //Sendfeeedback
    static let sendFeedbackTitle = NSLocalizedString("Send Feedback", comment: "")
    static let sendFeedbackText = NSLocalizedString("You can send us your feedback about \(AppInfo.kAppName) application. We would love to here suggestions from you.", comment: "")
    static let deleteMessage = NSLocalizedString("Are you sure you want to remove this image?", comment: "")
    static let enterFeedback = NSLocalizedString("Please enter brief explanation ", comment: "")
    

    static let changePhoneTitle = NSLocalizedString("Change Phone Number", comment: "")
    
    // Go Add Free
    static let purchaseItem = "Please purchase the item as it cannot be restored. Do you want to purchase this subscription?"
    static let purchaseFail = "Something went wrong with your purchase, Please try again."
    static let subscriptionSuccess = "You have subscribed successfully."
    static let restoreFail = "Please purchase the item as it cannot be restored. Do you want to purchase this subscription?"
    static let purchaseAlert = "Do you want to purchase Go Ad Free to remove ads throughout this app? Tap on Buy. If you've already purchased then tap on Restore option."
    static let subscriptionPurchaseAlert = "Do you want to purchase Premium Subscription to acess full app features? Tap on Buy. If you've already purchased then tap on Restore option."

    
    //Splash
    static let notNow = NSLocalizedString("Not Now", comment: "")
    static let update = NSLocalizedString("Update", comment: "")
}
