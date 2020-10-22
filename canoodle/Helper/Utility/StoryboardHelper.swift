//
//  StoryboardHelper.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit


/// Storyboard identifiers
enum AppClass: String {
    /// Storyboard instance for LoginPhoneVC
   case LoginPhoneVC = "LoginPhoneViewController"
    /// Storyboard instance for SignupVC
    case SignupVC = "SignupViewController"
    /// Storyboard instance for ForgotPasswordPhoneVC
    case ForgotPasswordPhoneVC = "ForgotPasswordPhoneViewController"
    /// Storyboard instance for otpVerificationVC
    case otpVerificationVC = "OTPVerificationViewController"
    /// Storyboard instance for resetPasswordVC
    case resetPasswordVC = "ResetPasswordViewController"
    /// Storyboard instance for signUpVC
    case signUpVC = "SignUpViewController"
    /// Storyboard instance for LoginEmailVC
    case LoginEmailVC = "LoginEmailViewController"
    /// Storyboard instance for LoginEmailAndSocialVC
   case LoginEmailAndSocialVC = "LoginEmailAndSocialViewController"
    /// Storyboard instance for LoginPhoneAndSocialVC
    case LoginPhoneAndSocialVC = "LoginPhoneAndSocialViewController"
    /// Storyboard instance for HomeVC
   case HomeVC = "HomeViewController"
    /// Storyboard instance for ForgotPasswordEmailVC
   case ForgotPasswordEmailVC = "ForgotPasswordEmailViewController"
    /// Storyboard instance for SettingVC
   case SettingVC = "SettingViewController"
    /// Storyboard instance for CanoodleVC
    case CanoodleVC = "CanoodleViewController"
    /// Storyboard instance for MessagesVC
    case MessagesVC = "MessagesViewController"
    /// Storyboard instance for ChangePasswordVC
   case ChangePasswordVC = "ChangePasswordViewController"
    /// Storyboard instance for ChangeMobileNumberVC
    case ChangeMobileNumberVC = "ChangeMobileNumberViewController"
    /// Storyboard instance for EditProfileVC
    case EditProfileVC = "EditProfileViewController"
    /// Storyboard instance for SendFeedbackVC
   case SendFeedbackVC = "SendFeedbackViewController"
    /// Storyboard instance for ImageDetailsVC
   case ImageDetailsVC = "ImageDetailsViewController"
    /// Storyboard instance for OnboardingVC
    case OnboardingVC = "OnboardingViewController"
    /// Storyboard instance for LikeVC
    case LikeVC = "LikeViewController"
    /// Storyboard instance for UserProfileVC
    case UserProfileVC = "UserProfileViewController"
    /// Storyboard instance for PetProfileVC
    case PetProfileVC = "PetProfileViewController"
    /// Storyboard instance for SubscriptionVC
    case SubscriptionVC = "SubscriptionViewController"
    /// Storyboard instance for HomeFilterVC
   case  HomeFilterVC = "HomeFilterViewController"
    /// Storyboard instance for AboutMeVC
   case  AboutMeVC = "AboutMeViewController"
    /// Storyboard instance for ChatVC
   case  ChatVC = "ChatViewController"
    /// Storyboard instance for NotificationsVC
    case NotificationsVC = "NotificationsViewController"
    /// Storyboard instance for BlockedUserVC
    case BlockedUserVC = "BlockedUserViewController"
}

/// Enum for Storyboard
enum StoryBoard: String {
    /// LoginPhone
    case LoginPhone
    /// LoginEmail
    case LoginEmail
    /// LoginEmailAndSocial
    case LoginEmailAndSocial
    /// LoginPhoneAndSocial
    case LoginPhoneAndSocial
    /// Signup
    case Signup
    /// ForgotPasswordPhone
    case ForgotPasswordPhone
    /// OTPVerification
    case OTPVerification
    /// ResetPassword
    case ResetPassword
    /// SignUp
    case SignUp
    /// Home
    case Home
    /// ForgotPasswordEmail
    case ForgotPasswordEmail
    /// Setting
    case Setting
    /// Canoodle
    case Canoodle
    /// Messages
    case Messages
    /// ChangePassword
    case ChangePassword
    /// ChangeMobileNumber
    case ChangeMobileNumber
    /// EditProfile
    case EditProfile
    /// SendFeedback
    case SendFeedback
    /// ImageDetails
    case ImageDetails
    /// Onboarding
    case Onboarding
    /// Like
    case Like
    /// UserProfile
    case UserProfile
    /// HomeFilter
    case HomeFilter
    /// Subscription
    case Subscription
    /// AboutMe
    case AboutMe
    /// Chat
    case Chat
    /// Notifications
    case Notifications
    /// BlockedUser
    case BlockedUser
    /// PetProfile
    case PetProfile

    
    /// Storyboard instance
    var board: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}



