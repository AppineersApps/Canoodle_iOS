//
//  AppConstant.swift
//  BaseProject
//
//  Created by hb on 27/08/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit


///Constants user in the app
struct AppConstants {
    
    /// App color
    static let appColor = UIColor(named: "AppColor")
    static let appColor2 = UIColor(named: "AppColor2")
    /// App Name
    static let appName = "Canoodle"
    /// App delegate object
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    /// Screen width
    static let screenWidth = UIScreen.main.bounds.size.width
    /// screen height
    static let screenHeight = UIScreen.main.bounds.size.height
    
    /// Base URL for API
    static let baseUrl = getBaseURL()
    /// Enable encryption for the api
    static var enableEncryption = false
    /// Enable checksum for the api
    static var enableChecksum = false
    /// Is debug mode on
    static var isDebug = false
    /// AES Encryption ket
    static let aesEncryptionKey = "CIT@WS!"
    /// Webservice checksum
    static let ws_checksum = "ws_checksum"
    
    /// Device vendor identifier
    static let deviceId = UIDevice.current.identifierForVendor?.uuidString
    /// Device name
    static let device_name = UIDevice.current.name
    /// Device model
    static let device_model = UIDevice.modelName
    /// Plateform
    static let platform = "iOS"
    /// OS Verison
    static let os_version = UIDevice.current.systemVersion
    
    /// Access Token
    static var accessToken: String?
    /// Disable button colorsi
    static let dissableButtonColor = #colorLiteral(red: 0.03921568627, green: 0.09411764706, blue: 0.3450980392, alpha: 0.5975462148)
    
    /// Date Format to be user in the app
    static let dobFormate = "MMM dd yyyy"
    /// Placeholder color for textfield
    static let placeholderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    /// Login type
    static var appType = LoginWith.socialEmail
    /// Background color user in the app
    static let backgroundColor = UIColor(named: "BackgroundColor")
    
    /// Subscription id for IAP
    static let goadfreeId = "goadfree"
    static let subscriptionId = "monthly"
    /// Is login skipped
    static var isLoginSkipped = false
    
    
     static let NavHeight = (deviceName == "iPhoneX") ? 84:64
     static let barHeight = (deviceName == "iPhoneX") ? 84:50
    
     static var deviceName : String {
         get {
             if UIDevice().userInterfaceIdiom == .phone {
                 switch UIScreen.main.nativeBounds.height {
                 case 1136:
                     return "iPhone5"
                 case 1334:
                     return "iPhone6"
                 case 1920, 2208:
                     return "iPhone6+"
                 case 2436,1792,2688:
                     return "iPhoneX"
                 default:
                     return "unknown"
                 }
             } else {
                 return "unknown"
             }
         }
     }
}

func getBaseURL()-> String {
    #if DEVELOPMENT
    return ApiServer.staging
    #elseif STAGING
    return ApiServer.staging
    #else
    return ApiServer.production
    #endif
}

/// Struct for the api
struct ApiServer {
    /// Local url
    static let development = "http://18.211.58.235/canoodle/WS"
    /// URL for staging
//    static let staging = "http://18.211.58.235/AppineersApp_V2/WS"
    static let staging = "http://3.225.83.133/canoodle/WS"
    /// URL for production
    static let production = "https://mobile.canoodleapp.com/WS"
}

/// Ad Mob Test details
struct AdMobTest {
    // Mark : Test Ids
    /// Banner AD Unit id
    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
    /// Interstitial AD Mob ID
    static let interstitialAdUnitId = "ca-app-pub-3940256099942544/4411468910"
}

/// Ad Mob Live details
struct AdMobLive {
    // Mark : Live Ids
    /// Banner AD Unit id
    static var bannerAdUnitID = "ca-app-pub-5439252228586946/7142817250"
    /// Interstitial AD Mob ID
    static var interstitialAdUnitId = "ca-app-pub-5439252228586946/4325082228"
}

/// Ad Mob details
struct ADMobDetail {
    // Mark : Test Ids
    /// AD Unit id
    static let adUnitID = "ca-app-pub-3940256099942544/4411468910"
    /// AD Mob ID
    static let admodId = "ca-app-pub-3940256099942544/2934735716"
}

/// MoPubTest details
struct MoPubTest {
    // Mark : Live Ids
    /// Banner AD Unit id
    static var bannerAdUnitID = "0ac59b0996d947309c33f59d6676399f"
    /// Interstitial AD Mob ID
    static var interstitialAdUnitId = "4f117153f5c24fa6a3a92b818a5eb630"
}

/// MoPubLive details
struct MoPubLive {
    // Mark : Live Ids
    /// Banner AD Unit id
    static var bannerAdUnitID = "866e3fd2af2f46dcab784d8c33f20969"
    /// Interstitial AD Mob ID
    static var interstitialAdUnitId = "c14097acc1c24e2ba26fa59311d8df55"
}

/// App Info
struct AppInfo {
    /// App Name
    static let kAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Application"
    /// App Version
    static let kAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    /// App Build version
    static let kAppBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    /// App Bundle identifier
    static let kBundleIdentifier = Bundle.main.bundleIdentifier
    /// App Store ID
    static let kAppstoreID = "1548258713"
    /// Play store bundle id
    static let kAndriodAppId = "com.app.whitelabel"
}

struct AppleKeychainKeys {
    static let userIdentifier = "userIdentifier"
    static let userFirstName = "userIFirstName"
    static let userLastName = "userLastName"
    static let userEmail = "userEmail"

}

/// Third Party SDK API Key and Credentials
struct ServiceApiKey {
    /// Google Keys
    struct Google {
        /// Client ID for google login
       // static let kClientID = "699060553821-8gcrb4mrrdqkfj91e32b4poepi4foq6g.apps.googleusercontent.com"
        static let kClientID = "292328770347-0q3vldbotuqvqoof38hj90k7ri7e56c8.apps.googleusercontent.com"

        ///Key for google places search
       // static let kGMSServicesAPIKey = "AIzaSyA0wwldrxqyK6HsLKSSOU0-w5Iz7ECkhZc"
        static let kGMSServicesAPIKey = "AIzaSyCGzj6upzB1VLMLG7cZwPt-FMgZA0-4XV8"
    }
    
}

/// Social type
///
/// - facebook: Facebook
/// - google: Google
/// - none:none
enum SocialLoginType: String  {
/// Facebook
    case facebook = "facebook"
/// Google
    case google = "google"
    /// Apple
    case apple = "apple"
 /// None
    case none = ""
}

/// Device Plateform
struct Platform {
    
    /// Check if app is tested on simulator
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
}

/// Userdefaults key
struct UserDefaultsKey {
    /// Device Token Key
    static let deviceTokenKey = "deviceTokenKey"
    /// Webservice token Key
    static let ws_token = "ws_token"
    /// User Detail
    static let userDetail = "user_detail"
    /// Notification Enabled
    static let notificationEnable = "notification_enable"
    /// Onboarding
    static let onboarding = "onboarding"
    /// Profile Setup
    static let profileSetUp = "profile_setup"
}

//// Enable or Disable Print Log
//public func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
//    if AppConstants.isDebug == true {
//        let output = items.map { "\($0)" }.joined(separator: separator)
//        Swift.print(output, terminator: terminator)
//    }
//}

/// Position for the shadow
///
/// - top: Top
/// - bottom: Bottom
/// - full: Full
/// - line: Line
enum shadowPosition {
    /// - Position: Top
    case top
    /// - Position: bottom
    case bottom
    /// - Position: full
    case full
    /// - Position: line
    case line
}

/// Toast Notificaiton type
///
/// - Error: Error
/// - Success: Success
/// - Info: Info
enum NotificationType : String {
    /// - Type: Error
    case Error
    /// - Type: Success
    case Success
    /// - Type: Info
    case Info
}

/// Static page code
///
/// - privacyPolicy: PRivacy Polcy
/// - termsCondition: Terms and condition
/// - aboutUs: ABout Us
enum StaticPageCode: String {
    /// - Code: Privacy Policy
    case privacyPolicy = "privacypolicy"
    /// - Code: Terms And Conditions
    case termsCondition = "termsconditions"
    /// - Code: About US
    case aboutUs = "aboutus"
    /// - Code: Eula
    case eula = "eula"
}


/// Login with
///
/// - email: Email
/// - phone: Phone
/// - socialEmail: Social Email
/// - socialPhone: Social Phone
enum LoginWith {
    /// - Login With: Email
    case email
    /// - Login With: Phone
    case phone
    /// - Login With: SocialEmail
    case socialEmail
    /// - Login With: SocialPhone
    case socialPhone
}
