//
//  SettingViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 23/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SwiftyStoreKit
import StoreKit
#if canImport(TALogger)
import TALogger
#endif
/// Protocol for presenting response
protocol SettingDisplayLogic: class {
    /// Did Receive Logout Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func logout(message: String, Success: String)
    /// Did Receive Delete account Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func deleteAccount(message: String, Success: String)
    /// Did Receive update push notification setting Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func updatePushNotification(message: String, Success: String)
    /// Did Receive Go Ad Free Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveGoAddFree(message: String, success: String)
    /// Did Receive send log file to admin Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSendLogFile(message: String, Success: String)
    
    /// Did Receive send database log file to admin Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSendDatabaseLogFile(message: String, Success: String)
}

/// This class is used for displaying all settings options: account settings and support options.
class SettingViewController: BaseViewControllerWithAd, exportLogFileToAdminDelegate {
    /// Interactor for API Call
    var interactor: SettingBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & SettingRoutingLogic & SettingDataPassing)?
    
    @IBOutlet weak var viewblank: UIView!
    @IBOutlet weak var viewAccountSetting: UIView!
    @IBOutlet weak var btnLogout: WLButton!
    @IBOutlet weak var viewLogout: UIView!
    @IBOutlet weak var btnGoAdFree: WLButton!
    @IBOutlet weak var btnEditProfile: WLButton!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var lblVersionNumber: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var btnSendFeedback: WLButton!
    @IBOutlet weak var btnChangePassword: WLButton!
    @IBOutlet weak var btnChangeMobileNumber: WLButton!
    @IBOutlet weak var btnAboutUs: WLButton!
    @IBOutlet weak var btnPrivacyPolicy: WLButton!
    @IBOutlet weak var btnTermsCondition: WLButton!
    @IBOutlet weak var btnEULA: WLButton!
    @IBOutlet weak var btnShareApp: WLButton!
    @IBOutlet weak var btnRateUs: WLButton!
    @IBOutlet weak var btnDeleteAccount: WLButton!
    @IBOutlet weak var btnWalkthrough: WLButton!

    /// Button For Logs
    @IBOutlet weak var btnLogs: WLButton!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var viewChangeMobileNumber: UIView!
    @IBOutlet weak var viewDeleteAccount: UIView!
    @IBOutlet weak var viewShareApp: UIView!
    @IBOutlet weak var viewRateUs: UIView!
    @IBOutlet weak var viewSendFeedback: UIView!
    @IBOutlet weak var viewTermsCondition: UIView!
    @IBOutlet weak var viewPrivacyPolicy: UIView!
    @IBOutlet weak var viewAboutUJs: UIView!
    @IBOutlet weak var viewAddFree: UIView!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewBuySubscription: UIView!
    /// View For Logs
    @IBOutlet weak var viewLogs: UIView!
    
    var dtFormatter = DateFormatter()
    var notificationOn = UserDefaultsManager.notificationEnable
    // MARK: Object lifecycle
    
     /// Override method to initialize with nib
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name
    ///   - nibBundleOrNil: Bundle in which nib is present
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
   /// Decoder
    ///
    /// - Parameter aDecoder: Decoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Class Instance
    class func instance() -> SettingViewController? {
        return StoryBoard.Setting.board.instantiateViewController(withIdentifier: AppClass.SettingVC.rawValue) as? SettingViewController
    }
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = SettingInteractor()
        let presenter = SettingPresenter()
        let router = SettingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: View lifecycle
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAddFree.isHidden = AppConstants.isLoginSkipped || (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        viewBuySubscription.isHidden = AppConstants.isLoginSkipped || (UserDefaultsManager.getLoggedUserDetails()?.premiumStatus?.booleanStatus() ?? false)
    }
    
    /// Set up UI
    func setUpUI() {
        self.navigationItem.title = AlertMessage.SettingTitle
        lblVersionNumber.text = "Version - \(AppInfo.kAppVersion).\(AppInfo.kAppBuildVersion)"

        btnLogout.addLoginButtonShadowAndCornerRadius()
        
        setSettingOptions()

        if !AppConstants.isLoginSkipped {
          
            if let socialLoginId = UserDefaultsManager.getLoggedUserDetails()?.socialLoginId, socialLoginId != "" {
                self.viewChangePassword.isHidden = true
            } else {
                self.viewChangePassword.isHidden = false
            }
            
            self.viewAddFree.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
            
            if(UserDefaultsManager.getLoggedUserDetails()?.logStatus == "Active") {
                self.viewLogs.isHidden = false
            }
            else if(AppConstants.isDebug == false){
                self.viewLogs.isHidden = true
            }
            
            self.viewChangeMobileNumber.isHidden = !(AppConstants.appType == LoginWith.phone || AppConstants.appType == LoginWith.socialPhone)
        }
        self.addAnayltics(analyticsParameterItemID: "id-settingsscreen", analyticsParameterItemName: "view_settingsscreen", analyticsParameterContentType: "view_settingsscreen")
    }
    
    /// Set setting options for guest user or login user
    func setSettingOptions() {
        self.viewNotification.isHidden = AppConstants.isLoginSkipped
        self.viewEdit.isHidden = AppConstants.isLoginSkipped
        self.viewChangePassword.isHidden = AppConstants.isLoginSkipped
        self.viewChangeMobileNumber.isHidden = AppConstants.isLoginSkipped || !(AppConstants.appType == LoginWith.phone || AppConstants.appType == LoginWith.socialPhone)
        self.viewDeleteAccount.isHidden = AppConstants.isLoginSkipped
        self.viewSendFeedback.isHidden = AppConstants.isLoginSkipped
        self.viewLogout.isHidden = AppConstants.isLoginSkipped
        viewAccountSetting.isHidden = AppConstants.isLoginSkipped
        viewAddFree.isHidden = AppConstants.isLoginSkipped || (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        viewBuySubscription.isHidden = AppConstants.isLoginSkipped || (UserDefaultsManager.getLoggedUserDetails()?.premiumStatus?.booleanStatus() ?? false)

        if(UserDefaultsManager.getLoggedUserDetails()?.logStatus == "Active") {
            self.viewLogs.isHidden = false
        }
        else if(AppConstants.isDebug == false){
            self.viewLogs.isHidden = true
        }
        viewblank.isHidden = AppConstants.isLoginSkipped
        if notificationOn == "Yes" {
            btnSwitch.isOn = true
        } else {
            btnSwitch.isOn = false
        }
    }
    
    /// Share Application
    func showSharePicker() {
        let atext = AlertMessage.shareApp
        let activityVC = UIActivityViewController(activityItems: [atext], applicationActivities: nil)
        activityVC.setValue("Download \(AppInfo.kAppName)", forKey: "subject")
        present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: In App Purchase for Go Ad Free
    
    /// In app Purchase for Go Ad Free
    ///
    /// - Parameter identifier: Purchase Identifer
    func buyProduct(withIdentifier identifier: String) {
        GlobalUtility.showHud()
        print("Asked:\(AppInfo.kBundleIdentifier! + "." + identifier)")
        
        SwiftyStoreKit.purchaseProduct((AppInfo.kBundleIdentifier! + "." + identifier), atomically: true) { result in
            GlobalUtility.hideHud()
            
            if case .success(let purchase) = result {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
                self.purchaseSuccess(purchase.productId)
                // Deliver content from server, then:
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.purchaseSuccess(AppInfo.kBundleIdentifier! + "." + identifier)
                }
            }
        }
    }
    
    /// Restore In app Purchase
    ///
    /// - Parameter identifier: purchase identifier
    func restoreProduct(withIdentifier identifier:String) {
        GlobalUtility.showHud()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            GlobalUtility.hideHud()
            
            var isPurchased = false
            for purchase in results.restoredPurchases {
                //  let downloads = purchase.transaction.downloads
                if purchase.productId == (AppInfo.kBundleIdentifier! + "." + identifier) {
                    isPurchased = true
                    self.showTopMessage(message: AlertMessage.subscriptionSuccess, type: .Success)
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    self.purchaseSuccess(AppInfo.kBundleIdentifier! + "." + identifier)
                }
            }
            
            if !isPurchased {
                self.displayAlert(msg: AlertMessage.restoreFail, ok: AlertMessage.yes, cancel: AlertMessage.no, okAction: {
                    self.buyProduct(withIdentifier: identifier)
                }, cancelAction: {
                    
                })
            }
        }
    }
    
    /// In app Purchase Success
    ///
    /// - Parameter identifier: Purchase Identifier
    func purchaseSuccess(_ identifier : String) {
       
            self.receiptDataVerification()
    }
    
    /// Receipt Verification
    func receiptDataVerification() {
        if !self.internetAvailable() {
            self.showTopMessage(message: AlertMessage.NetworkError, type: .Error)
            return
        }
        
        GlobalUtility.showHud()
        verifyReceipt { (result) in
            GlobalUtility.hideHud()
            
            switch result {
            case .success(let receipt):
                print(receipt.description)
                let req = GoAddFree.Request(oneTimeTransactionData: receipt.description)
                self.interactor?.goAddFree(request: req)
            case .error:
                break
            }
        }
    }
    
    /// Verify Receipt from Apple
    ///
    /// - Parameter completion: Description
    func verifyReceipt(completion: @escaping (FetchReceiptResult) -> Void) {
        
        GlobalUtility.showHud()
        SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
            switch result {
            case .success(let receiptData):
                let encryptedReceipt = receiptData.base64EncodedString(options: [])
                print("Fetch receipt success:\n\(encryptedReceipt)")
                
                completion(result)
                
            case .error(let error):
                print("Fetch receipt failed: \(error)")
            }
        }
    }

    
    // Mark : WLButton Actions
    
    /// Notification On/Off Action
    ///
    /// - Parameter sender: UISwitch
    @IBAction func notificationTapAction(_ sender: UISwitch) {
       /* UserDefaultsManager.notificationEnable = (btnSwitch.isOn ? "Yes" : "No")
        let req = UpdatePushNotificationSetting.Request(notification: UserDefaultsManager.notificationEnable)
        self.interactor?.updatePushNotification(request: req)*/
       //  UserDefaultsManager.notificationEnable = (btnSwitch.isOn ? "Yes" : "No")
        //redirect to settings
        self.addAnayltics(analyticsParameterItemID: "id-notification", analyticsParameterItemName: "click_notification", analyticsParameterContentType: "click_notification")
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    /// Setting Option tap Actions
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnSettingOptionAction(_ sender: WLButton) {
        switch sender {
        case btnGoAdFree:
            guard internetAvailable() else { return }
            self.goAdFree()
            
            self.addAnayltics(analyticsParameterItemID: "id-goadfree", analyticsParameterItemName: "click_goadfreeclick", analyticsParameterContentType: "click_goadfreeclick")
            
        case btnEditProfile:
            if let editProfileVC = EditProfileViewController.instance() {
                self.navigationController?.pushViewController(editProfileVC, animated: true)
            }
        case btnChangePassword:
            if let changePassword = ChangePasswordViewController.instance() {
                self.navigationController?.pushViewController(changePassword, animated: true)
            }
        case btnChangeMobileNumber:
            if let changePhoneNumber = ChangeMobileNumberViewController.instance() {
                self.navigationController?.pushViewController(changePhoneNumber, animated: true)
            }
        case btnDeleteAccount:
            guard internetAvailable() else { return }
             self.addAnayltics(analyticsParameterItemID: "id-deleteaccount", analyticsParameterItemName: "click_deleteaccount", analyticsParameterContentType: "click_deleteaccount")
            self.displayAlert(msg: AlertMessage.deleteAccountAlert, ok: AlertMessage.yes, cancel: AlertMessage.no, okAction: {
                self.interactor?.deleteAccount()
            }, cancelAction: nil)
            
        case btnAboutUs:
            if let staticPageVC = StaticPageViewController.instance() {
                staticPageVC.isFrom = StaticPageCode.aboutUs.rawValue
                self.navigationController?.pushViewController(staticPageVC, animated: true)
            }
        case btnPrivacyPolicy:
            if let staticPageVC = StaticPageViewController.instance() {
                staticPageVC.isFrom = StaticPageCode.privacyPolicy.rawValue
                self.navigationController?.pushViewController(staticPageVC, animated: true)
            }
        case btnTermsCondition:
            if let staticPageVC = StaticPageViewController.instance() {
                staticPageVC.isFrom = StaticPageCode.termsCondition.rawValue
                self.navigationController?.pushViewController(staticPageVC, animated: true)
            }
        case btnEULA:
            if let staticPageVC = StaticPageViewController.instance() {
                staticPageVC.isFrom = StaticPageCode.eula.rawValue
                self.navigationController?.pushViewController(staticPageVC, animated: true)
            }
        case btnSendFeedback:
            if let sendFeedbackVC = SendFeedbackViewController.instance() {
                self.navigationController?.pushViewController(sendFeedbackVC, animated: true)
            }
        case btnShareApp:
            self.showSharePicker()
             self.addAnayltics(analyticsParameterItemID: "id-shareapp", analyticsParameterItemName: "click_shareapp", analyticsParameterContentType: "click_shareapp")
        case btnRateUs:
                if let url = URL(string: "https://apps.apple.com/gb/app/id\(AppInfo.kAppstoreID)?action=write-review") {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    }
                    self.addAnayltics(analyticsParameterItemID: "id-rateus", analyticsParameterItemName: "Rate Us", analyticsParameterContentType: "button_click")
        case btnWalkthrough:
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
                TabbarController.onboarding = true
                AppConstants.appDelegate.window?.rootViewController = tab
            }
        case btnLogs:
            #if canImport(TALogger)
            TALogger.shared.ShowLogs()
            TALogger.delegate = self
            #endif
            
        default:
            break
        }
    }
    
    /// DO IAP to go ad free
    func goAdFree() {
        let alertController = UIAlertController(title:  AppInfo.kAppName, message: AlertMessage.purchaseAlert, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "Buy for $1.99", style: .default) { (_) in
            if Platform.isSimulator {
                let aModel = UserDefaultsManager.getLoggedUserDetails()
                aModel?.purchaseStatus = "Yes"
                UserDefaultsManager.setLoggedUserDetails(userDetail: aModel!)
                self.viewAddFree.isHidden = true
                self.showTopMessage(message: "Ads are removed successfully.", type: .Success)
            } else {
                self.buyProduct(withIdentifier: AppConstants.goadfreeId)
            }
        }
        alertController.addAction(OKAction)
        
        let RestoreAction = UIAlertAction(title: "Restore your Purchase", style: .default) { (_) in
            self.restoreProduct(withIdentifier: AppConstants.goadfreeId)
        }
        
        alertController.addAction(RestoreAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backbtn(_ sender: Any) {
        
//           let home = Home(nibName: "Home", bundle: nil)
//           self.navigationController?.pushViewController(home, animated: true)
        
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            AppConstants.appDelegate.window?.rootViewController = tab
        }

//        if let homeVC = HomeViewController.instance() {
//            let vc = NavController.init(rootViewController: homeVC)
//            AppConstants.appDelegate.window?.rootViewController = vc
//        }
        
    }
    
//    @IBAction func btnBack(_ sender: Any) {
//
//        if let homeVC = HomeViewController.instance() {
//            let vc = NavController.init(rootViewController: homeVC)
//            AppConstants.appDelegate.window?.rootViewController = vc
//        }
//
//    }
    
    /// Logout
    ///
    /// - Parameter sender: WLButton
    @IBAction func buySubscriptionAction(_ sender: WLButton) {
        guard internetAvailable() else { return }
        if let subscriptionVC = SubscriptionViewController.instance() {
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
        }
    }
    
    /// Logout
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnLogoutTapAction(_ sender: WLButton) {
        guard internetAvailable() else { return }
        self.displayAlert(msg: AlertMessage.logOutAlert, ok: AlertMessage.yes, cancel: AlertMessage.no, okAction: {
            self.interactor?.logout()
        }, cancelAction: nil)
    }
    
    func exportLogFile() {
        #if canImport(TALogger)
        TALogger.shared.ShowLogs()
        TALogger.delegate = self
        let logString = TALogger.shared.returnLogFile()
        let databaseLogString = TALogger.shared.returnDatabaseLogFile()

        print(logString.0)
        print(logString.1)
        print(logString.2)
        
        let request = SendAdminLog.Request(logFile: logString.1, logDatabase: databaseLogString.1, fileName: logString.2, databasefileName: databaseLogString.0)
        interactor?.sendLogFile(request: request)
        
        #endif
    }
    
    func exportDatabaseLogFile() {
        #if canImport(TALogger)
        TALogger.shared.ShowLogs()
        TALogger.delegate = self
        let logString = TALogger.shared.returnDatabaseLogFile()
        print(logString.0)
        print(logString.1)
        
        let request = SendAdminLog.Request(logFile: Data(), logDatabase: logString.1, fileName: logString.0, databasefileName: "")
        interactor?.sendDatabaseLogFile(request: request)
        
        #endif
    }
}

extension SettingViewController: SettingDisplayLogic {
    /// Did Receive Logout Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func logout(message: String, Success: String) {
        self.addAnayltics(analyticsParameterItemID: "id-logout", analyticsParameterItemName: "click_logout", analyticsParameterContentType: "click_logout")
        if Success == "1" {
            UserDefaultsManager.resetFilter()
            self.router?.redirectToLogin()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
     /// Did Receive Delete account Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    
    func updatePushNotification(message: String, Success: String) {
        if Success == "1" {
            let loginDetails = UserDefaultsManager.getLoggedUserDetails()
            let temp = loginDetails?.pushNotification
            if temp == "Yes" {
               loginDetails?.pushNotification = "No"
            } else {
                loginDetails?.pushNotification = "Yes"
            }
            UserDefaultsManager.setLoggedUserDetails(userDetail: loginDetails!)
            self.showTopMessage(message: message, type: .Success)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive update push notification setting Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveGoAddFree(message: String, success: String) {
        if success == "1" {
            let aModel = UserDefaultsManager.getLoggedUserDetails()
            aModel?.purchaseStatus = "Yes"
            UserDefaultsManager.setLoggedUserDetails(userDetail: aModel!)
            self.viewAddFree.isHidden = true
            self.showTopMessage(message: message, type: .Success)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    /// Did Receive Go Ad Free Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func deleteAccount(message: String, Success: String) {
        if Success == "1" {
            self.router?.redirectToLogin()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive send log file to admin Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSendLogFile(message: String, Success: String) {
        if Success == "1" {
            showTopMessage(message: message, type: .Success)
        } else {
            showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive send database log file to admin Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSendDatabaseLogFile(message: String, Success: String) {
        if Success == "1" {
            showTopMessage(message: message, type: .Success)
        } else {
            showTopMessage(message: message, type: .Error)
        }
    }
}
