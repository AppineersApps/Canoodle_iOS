//
//  SplashViewController.swift
//  AppineersWhiteLabel

import UIKit

/// Protocol for presenting response
protocol SplashDisplayLogic: class {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - viewModel: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveVersionCheckResponse(viewModel: Splash.ViewModel?, message: String, successCode: String)
}

/// This class is used to launch the app and do operations which need to perform in backgroud during app launch.
class SplashViewController: BaseViewController {
    
    /// Interactor for API Call
    var interactor: SplashBusinessLogic?
    var configModel: Splash.ViewModel?
    private var observer: NSObjectProtocol?
    var isAPiCallFail = false
    
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
    
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: ViewLifeCycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.internetAvailable() {
            interactor?.callVersionCheckAPI()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        } else {
            self.isAPiCallFail = true
            self.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
                
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { (_) in
            if self.isAPiCallFail {
                self.interactor?.callVersionCheckAPI()
            }
        })
        
        //  self.setViewController()
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Set View Controller after pop up for version number
    func setViewController() {
        if (UserDefaultsManager.getLoggedUserDetails() != nil) {
            if configModel?.termsConditionsUpdated  == "1" {
                if let staticPageVC = StaticPageViewController.instance() {
                    let aNav = NavController(rootViewController: staticPageVC)
                    staticPageVC.showAgreeBtn = true
                    staticPageVC.isFrom = StaticPageCode.termsCondition.rawValue
                    aNav.modalPresentationStyle = .fullScreen
                    staticPageVC.updateCompletion = {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) {
                            self.checkPrivacyPolicy()
                        }
                        
                    }
                    self.present(aNav, animated: true, completion: nil)
                }
            } else {
                self.checkPrivacyPolicy()
            }
        } else {
            self.pushToMainScreen()
        }
    }
    
    /// Check Privacy Policy version
    func checkPrivacyPolicy() {
        if configModel?.privacyPolicyUpdated  == "1" {
            if let staticPageVC = StaticPageViewController.instance() {
                let aNav = NavController(rootViewController: staticPageVC)
                staticPageVC.showAgreeBtn = true
                staticPageVC.isFrom = StaticPageCode.privacyPolicy.rawValue
                aNav.modalPresentationStyle = .fullScreen
                staticPageVC.updateCompletion = {
                    self.pushToMainScreen()
                }
                self.present(aNav, animated: true, completion: nil)
            }
        } else {
            self.pushToMainScreen()
        }
    }
    
    ///Push to login or home screen
    func pushToMainScreen() {
        if UserDefaultsManager.onboardingDone != "Yes" {
            if let VC = OnboardingViewController.instance() {
                VC.modalPresentationStyle = .fullScreen
                self.present(VC, animated: true, completion: nil)
            }
        } else {
            if (UserDefaultsManager.getLoggedUserDetails() != nil) {
                // MARK: - Home screen setup autologin
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
                    AppConstants.appDelegate.window?.rootViewController = tab
                }
            } else {
                GlobalUtility.redirectToLogin()
            }
        }
    }
    
    /// Redirect app to app store
    func redirectToAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - For Splash API Reponse
extension SplashViewController: SplashDisplayLogic {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - viewModel: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveVersionCheckResponse(viewModel: Splash.ViewModel?, message: String, successCode: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if successCode == "1" {
            if let data = viewModel {
                self.configModel = data
                let aVersion = AppInfo.kAppVersion
                let aIOSVersion = data.iosVersion ?? "1.0"
                if (UserDefaultsManager.getLoggedUserDetails() != nil) {
                    let loginData = UserDefaultsManager.getLoggedUserDetails()
                    loginData?.logStatus = configModel?.logStatusUpdated
                    UserDefaultsManager.setLoggedUserDetails(userDetail: loginData!)
                }
                if data.versionUpdateCheck == "1" {
                    if aVersion != aIOSVersion {
                        if data.versionUpdateOptional == "1" {
                            self.displayAlert(msg: data.alertMessage, ok: AlertMessage.update, cancel: AlertMessage.notNow, okAction: {
                                self.redirectToAppStore()
                                if data.versionUpdateOptional == "1" {
                                    self.setViewController()
                                }
                            }, cancelAction: {
                                if data.versionUpdateOptional == "1" {
                                    self.setViewController()
                                }
                            })
                        } else {
                            self.showSimpleAlert(message: data.alertMessage!, okAction: {
                                self.redirectToAppStore()
                            })
                        }
                    } else {
                        self.setViewController()
                    }
                } else {
                    self.setViewController()
                }
            }
        } else {
            
            isAPiCallFail = true
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
