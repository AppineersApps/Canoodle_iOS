//
//  LoginEmailAndSocialViewController.swift
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
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import AuthenticationServices

/// Protocol for presenting response
protocol LoginEmailAndSocialDisplayLogic: class {
    /// Did Receive Login API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveLoginResponse(response: Login.ViewModel?, message: String, success: String)
    /// Did Receive Social Login API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialLoginResponse(response: Login.ViewModel?, message: String, success: String)
}

/// This class is used for login action of user. Login can be done using email or using social accounts.
class LoginEmailAndSocialViewController: BaseViewController {
    /// Interactor for API Call
    var interactor: LoginEmailAndSocialBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & LoginEmailAndSocialRoutingLogic & LoginEmailAndSocialDataPassing)?
    
    var socialLoginType = SocialLoginType.facebook.rawValue
    var facebookDict: [String: AnyObject]?
    var appleDict: [String: AnyObject]?
    var googleDict:  GIDGoogleUser!
    
    @IBOutlet weak var btnGoogle: WLButton!
    @IBOutlet weak var btnFacebook: WLButton!
    @IBOutlet weak var btnLogin: WLButton!
    @IBOutlet weak var txtFieldPassword: CustomTextField!
    @IBOutlet weak var txtFieldEmail: CustomTextField!
    @IBOutlet weak var btnApple: WLButton!
    @IBOutlet weak var viewAppleLogin: UIView!
    
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
    
    /// Instance
    ///
    /// - Returns: LoginEmailAndSocialViewController
    class func instance() -> LoginEmailAndSocialViewController? {
        return StoryBoard.LoginEmailAndSocial.board.instantiateViewController(withIdentifier: AppClass.LoginEmailAndSocialVC.rawValue) as? LoginEmailAndSocialViewController
    }
    
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = LoginEmailAndSocialInteractor()
        let presenter = LoginEmailAndSocialPresenter()
        let router = LoginEmailAndSocialRouter()
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
        setUpLayout()
    }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // SetUpLayout initial UI setup
    func setUpLayout() {
        self.navigationItem.title = AlertMessage.loginTitle
      //  btnLogin.addLoginButtonShadowAndCornerRadius()
        btnFacebook.addLoginButtonShadowAndCornerRadius()
        btnGoogle.addLoginButtonShadowAndCornerRadius()
        btnApple.addLoginButtonShadowAndCornerRadius()
        
        GIDSignIn.sharedInstance()?.clientID = ServiceApiKey.Google.kClientID
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        
        if #available(iOS 13.0, *) {
            self.btnApple.isHidden = false
        } else {
            self.btnApple.isHidden = true
        }
    }
    
    /// Validiate all fields and call login api
    func validateFields() {
        guard self.internetAvailable() else {
            return
        }
        do {
            let email = try txtFieldEmail.validatedText(validationType: ValidatorType.email)
            let password = try txtFieldPassword.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirePassword))
            self.interactor?.loginWithEmail(request: LoginEmailAndSocialModel.Request(email: email, password: password))
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    /// Facebook Login
    func loginWithFacebook() {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions.count > 0 {
                    if(fbloginresult.grantedPermissions.contains("email")) {
                        self.getFBUserData()
                       // fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    /// Get Facebook User Data
    func getFBUserData() {
        if((AccessToken.current) != nil) {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (_, result, error) -> Void in
                if (error == nil) {
                    if let aResult = result as? [String : AnyObject] {
                        //   print(aResult)
                        //   print("Social Login Id : \(aResult["id"] as! String)")
                        self.socialLoginType = SocialLoginType.facebook.rawValue
                        self.facebookDict = aResult
                        if let aSocialID = aResult["id"] as? String {
                            self.callSocialLoginApi(type: self.socialLoginType, id:aSocialID)
                        }
                        
                    }
                }
            })
        }
    }
    
    /// Google Login
    func loginWithGoogle() {
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    /// Call Social Login api
    ///
    /// - Parameters:
    ///   - type: Social Login type
    ///   - id: Social Login id
    func callSocialLoginApi(type: String, id: String) {
        self.interactor?.socialLogin(request: LoginEmailAndSocialModel.SocialRequest(type: type, id: id))
    }
    
    // MARK: WLButton Actions
    
    /// Forgot Password Tap Action
    ///
    /// - Parameter sender: WLButton
    @IBAction func forgotPasswordAction(_ sender: Any) {
        if let forgotPassword = ForgotPasswordEmailViewController.instance() {
            self.navigationController?.pushViewController(forgotPassword, animated: true)
        }
    }
    
    /// Login Button Tap Action
    ///
    /// - Parameter sender: WLButton
    @IBAction func loginAction(_ sender: Any) {
        validateFields()
    }
    
    /// Create new account or Signup
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnCreateNowTapped(_ sender: Any) {
        if let signUpVC = SignUpViewController.instance() {
            self.navigationController?.pushViewController(signUpVC, animated: true)
        }
    }
    
    /// Social Facebook Login action
    ///
    /// - Parameter sender: WLButton
    @IBAction func facebookTapAction(_ sender: Any) {
        loginWithFacebook()
    }
    
    /// Social Google Login action
    ///
    /// - Parameter sender: WLButton
    @IBAction func googleTapAction(_ sender: Any) {
        loginWithGoogle()
    }
    
    /// Social Apple Login action
    ///
    /// - Parameter sender: WLButton
    @IBAction func appleTapAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
    
    /// Skip to main home screen
    ///
    /// - Parameter sender: WLButton
    @IBAction func skipAction(_ sender: Any) {
        AppConstants.isLoginSkipped = true
        let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
            AppConstants.appDelegate.window?.rootViewController = tab
        }
    }
    
}

extension LoginEmailAndSocialViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if error != nil {
            print("(error.localizedDescription)")
        } else {
            if let user = user {
                self.socialLoginType = SocialLoginType.google.rawValue
                self.googleDict = user
                self.callSocialLoginApi(type: self.socialLoginType, id: user.userID)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}

@available(iOS 13.0, *)
extension LoginEmailAndSocialViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {

        print("")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            if appleIDCredential.fullName?.givenName != nil {
                KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
            }
            if appleIDCredential.fullName?.familyName != nil {
                KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
            }
            if appleIDCredential.email != nil {
                KeychainItem.currentUserEmail = appleIDCredential.email
            }
            
            self.socialLoginType = SocialLoginType.apple.rawValue
            self.appleDict = ["data":authorization.credential]
            self.callSocialLoginApi(type: self.socialLoginType, id: appleIDCredential.user)
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            
        }

    }
}

@available(iOS 13.0, *)
extension LoginEmailAndSocialViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

// MARK: - Login Email Social Response
extension LoginEmailAndSocialViewController: LoginEmailAndSocialDisplayLogic {
    /// Did Receive Login API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveLoginResponse(response: Login.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                UserDefaultsManager.setLoggedUserDetails(userDetail: data)
                AppConstants.isLoginSkipped = false
                router?.redirectToHome()
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Social Login API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialLoginResponse(response: Login.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                UserDefaultsManager.setLoggedUserDetails(userDetail: data)
                AppConstants.isLoginSkipped = false
                router?.redirectToHome()
            }
        } else if success == "2" {
            router?.navigateToSignup()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}