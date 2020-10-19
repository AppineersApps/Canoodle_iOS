//
//  OTPVerificationViewController.swift
//  AppineersWhiteLabel
//
//  Created by hb on 04/09/19.

import UIKit
import SVPinView

/// Protocol for presenting response
protocol OTPVerificationDisplayLogic: class {
    /// Did Receive Sign up Phone API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceivePhoneSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String)
    /// Did Receive Unique User API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveUniqeUser(response: [CheckUniqueUser.ViewModel]?, message: String, success: String)
    /// Did Receive Social Sign up API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String)
    /// Did Receive Forgot Password API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveForgotPasswordResponse(response: ForgotPasswordPhone.ViewModel?, message: String, success: String)
    /// Did Receive Change Mobile Number API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveChangeMobileNumberResponse(message: String, success: String)
}

/// This class is used for allowing user to enter OTP verification code which they will receive via SMS.
class OTPVerificationViewController: BaseViewController {
    /// Interactor for API Call
    var interactor: OTPVerificationBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & OTPVerificationRoutingLogic & OTPVerificationDataPassing)?
    
    @IBOutlet weak var viewOtp: SVPinView!
    @IBOutlet weak var btnSubmit: WLButton!
    @IBOutlet weak var lblVerificationNumber: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnResend: WLButton!
    @IBOutlet weak var otpDummyTxtField: UITextField!
    
    private var time = 30
    private var timer = Timer()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var otp = ""
    var phoneNumber = ""
    var signUpRequest: SignUp.SignUpPhoneModel.Request?
    var socialSignUpRequest: SignUp.SignUpSocialModel.Request?
    var isFrom = ""
    var socialLogin = false
    var forgotPasswrdResponse: ForgotPasswordPhone.ViewModel?
    
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
        let interactor = OTPVerificationInteractor()
        let presenter = OTPVerificationPresenter()
        let router = OTPVerificationRouter()
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
        self.setupLayout()
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.viewOtp.becomeFirstResponderAtIndex = 0
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.timer.invalidate()
        super.viewWillDisappear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        super.viewDidAppear(animated)

    }
    
    // MARK: Class Instance
    class func instance() -> OTPVerificationViewController? {
        return StoryBoard.OTPVerification.board.instantiateViewController(withIdentifier: AppClass.otpVerificationVC.rawValue) as? OTPVerificationViewController
    }
    
    /// Initial UIsetup
    /// Set title
    func setupLayout() {
        self.navigationItem.title = AlertMessage.otpVerificationPasswordtitle
        self.lblVerificationNumber.text = AlertMessage.verificationNumber + phoneNumber.toPhoneNumber()
        self.setTimer()
        self.btnResend.isEnabled = false
        self.otpDummyTxtField.text = otp
        viewOtp.font = UIFont.systemFont(ofSize: 20.0)
        viewOtp.keyboardType = .asciiCapableNumberPad
    }
    
    /// Set timer for resent otp
    func setTimer() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
        })
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(OTPVerificationViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    /// Update timer for reset otp
    @objc func updateTimer() {
        time -= 1
        if time == 0 {
            self.timer.invalidate()
            self.showTopMessage(message: AlertMessage.timeOut, type: .Error)
            self.btnSubmit.isEnabled = false
            self.btnSubmit.backgroundColor = AppConstants.dissableButtonColor
            self.btnResend.isEnabled = true
            self.lblTime.isHidden = true
        }
        self.lblTime.text = "in \(String(format: "%02d", time)) seconds"
    }
    
    /// Submit otp tap action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnSubmitTapAction(_ sender: Any) {
        if self.internetAvailable() {
            if self.viewOtp.getPin() == "" {
                self.showTopMessage(message: AlertMessage.optRequire, type: .Error)
                self.viewOtp.clearPin()
                self.viewOtp.becomeFirstResponderAtIndex = 0
            } else if self.viewOtp.getPin() != self.otp {
                self.showTopMessage(message: AlertMessage.optNotMatch, type: .Error)
                self.viewOtp.clearPin()
                self.viewOtp.becomeFirstResponderAtIndex = 0
            } else {
                self.timer.invalidate()
                if isFrom == "SignUp" && self.signUpRequest != nil && socialLogin == false {
                    interactor?.callSignUpPhoneAPI(request: self.signUpRequest!)
                } else if isFrom == "SignUp" && self.socialSignUpRequest != nil {
                    interactor?.callSocialSignUpAPI(request: self.socialSignUpRequest!)
                } else if isFrom == "ForgotPassword" {
                    self.btnSubmit.isEnabled = false
                    self.btnSubmit.backgroundColor = AppConstants.dissableButtonColor
                    self.btnResend.isEnabled = true
                    self.lblTime.isHidden = true
                    if let resetPasswordVC = ResetPasswordViewController.instance() {
                        resetPasswordVC.forgotPasswordData = forgotPasswrdResponse
                        resetPasswordVC.mobileNumber = phoneNumber
                        self.navigationController?.pushViewController(resetPasswordVC, animated: true)
                    }
                } else if isFrom == "changePhoneNumber" {
                    self.interactor?.changePhoneNumber(request: ChangeMobileNumber.Request(mobileNumber: self.phoneNumber))
                }
            }
        }
    }
    
    /// Button Resent otp tap action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnResendTapAcion(_ sender: Any) {
        if self.internetAvailable() {
            if isFrom == "SignUp" || isFrom == "changePhoneNumber" {
                let request = CheckUniqueUser.Request(phone: phoneNumber.getPhoneNumber(), email: "", userName: "")
                interactor?.checkUniqUser(request: request)
            } else if isFrom == "ForgotPassword" {
                self.interactor?.forgotPassword(phone: phoneNumber)
            }
        }
    }
}

// MARK: - OTP Verification Response
extension OTPVerificationViewController: OTPVerificationDisplayLogic {
    /// Did Receive Sign up Phone API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceivePhoneSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                UserDefaultsManager.setLoggedUserDetails(userDetail: data[0])
                self.showTopMessage(message: message, type: .Success)
                router?.redirectToHome()
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Unique User API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveUniqeUser(response: [CheckUniqueUser.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let data = response?[0] {
                self.showTopMessage(message: message, type: .Success)
                self.viewOtp.clearPin()
                self.time = 31
                self.otp = data.otp ?? ""
                self.otpDummyTxtField.text = data.otp ?? ""
                self.setTimer()
                self.btnSubmit.isEnabled = true
                self.btnSubmit.backgroundColor = AppConstants.appColor
                self.btnResend.isEnabled = false
                self.lblTime.isHidden = false
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Social Sign up API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                UserDefaultsManager.setLoggedUserDetails(userDetail: data[0])
                self.showTopMessage(message: message, type: .Success)
                router?.redirectToHome()
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Forgot Password API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveForgotPasswordResponse(response: ForgotPasswordPhone.ViewModel?, message: String, success: String) {
        if success == "1" {
            self.showTopMessage(message: message, type: .Success)
            self.viewOtp.clearPin()
            self.time = 31
            self.otp = response?.otp ?? ""
            self.forgotPasswrdResponse = response
            self.otpDummyTxtField.text = response?.otp ?? ""
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(OTPVerificationViewController.updateTimer)), userInfo: nil, repeats: true)
            self.btnSubmit.isEnabled = true
            self.btnSubmit.backgroundColor = AppConstants.appColor
            self.btnResend.isEnabled = false
            self.lblTime.isHidden = false
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Change Mobile Number API Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveChangeMobileNumberResponse(message: String, success: String) {
        if success == "1" {
            self.showTopMessage(message: message, type: .Success)
            let user = UserDefaultsManager.getLoggedUserDetails()
            user?.mobileNo = self.phoneNumber
            UserDefaultsManager.setLoggedUserDetails(userDetail: user!)
            self.btnSubmit.isEnabled = false
            self.btnSubmit.backgroundColor = AppConstants.dissableButtonColor
            self.btnResend.isEnabled = true
            self.lblTime.isHidden = true
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
