//
//  LoginPhoneViewController.swift
//  WhiteLabel
//
//  Created by hb on 09/09/19.
//  Copyright (c) 2019 hb. All rights reserved.

import UIKit

/// Protocol for presenting response
protocol LoginPhoneDisplayLogic: class {
    /// Did Receive Login Phone API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveLoginResponse(response: Login.ViewModel?, message: String, success: String)
}

/// This class is used for login action of user. Login can be done using email and password.
class LoginPhoneViewController: BaseViewController {
    
    // MARK: IBOutlet
    /// Interactor for API Call
    var interactor: LoginPhoneBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & LoginPhoneRoutingLogic & LoginPhoneDataPassing)?
    
    @IBOutlet weak var txtFieldPhone: CustomTextField!
    @IBOutlet weak var txtFieldPassword: CustomTextField!
    @IBOutlet weak var btnLogin: WLButton!
    
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
    /// - Returns: LoginViewController
    class func instance() -> LoginPhoneViewController? {
        return StoryBoard.LoginPhone.board.instantiateViewController(withIdentifier: AppClass.LoginPhoneVC.rawValue) as? LoginPhoneViewController
    }
    
    // MARK: Setup
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = LoginPhoneInteractor()
        let presenter = LoginPhonePresenter()
        let router = LoginPhoneRouter()
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
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // SetUpLayout initial UI setup
    func setUpLayout() {
        self.navigationItem.title = AlertMessage.loginTitle
        btnLogin.addLoginButtonShadowAndCornerRadius()
        txtFieldPhone.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
    }
    
    /// Validiate all fields and call login api
    func validateFields() {
        guard self.internetAvailable() else {
            return
        }
        do {
            let phone = try txtFieldPhone.validatedText(validationType: ValidatorType.phone)
            let password = try txtFieldPassword.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirePassword))
            
            let phoneNumber = phone.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            
            self.interactor?.loginWithPhone(request: LoginPhoneModel.Request(mobileNumber: phoneNumber, password: password))
            
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    // MARK: WLButton Actions
    
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldPhone.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10 {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldPhone.text = str
        
    }
    
    /// Forgot Password Tap Action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        if let forgotPassword = ForgotPasswordPhoneViewController.instance() {
            self.navigationController?.pushViewController(forgotPassword, animated: true)
        }
    }
    
    /// Login tap action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnLoginTapped(_ sender: Any) {
        validateFields()
    }
    
    /// Create new account or signup tap action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btncreatenowTapped(_ sender: Any) {
        if let signUpVC = SignUpViewController.instance() {
            self.navigationController?.pushViewController(signUpVC, animated: true)
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

// MARK: - Lpgin API Response
extension LoginPhoneViewController: LoginPhoneDisplayLogic {
    /// Did Receive Login Phone API Response
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
}
