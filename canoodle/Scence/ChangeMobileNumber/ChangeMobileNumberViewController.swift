//
//  ChangeMobileNumberViewController.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.

import UIKit

/// Protocol for presenting response
protocol ChangeMobileNumberDisplayLogic: class {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceivecOtpResponse(response: CheckUniqueUser.ViewModel?, message: String, success: String)
}

/// This class is used to change phone number of user account.
class ChangeMobileNumberViewController: BaseViewController {
    /// Interactor for API Call
    var interactor: ChangeMobileNumberBusinessLogic?
    // /// Router for navigation between the screens
   // var router: (NSObjectProtocol & ChangeMobileNumberRoutingLogic & ChangeMobileNumberDataPassing)?
    
    @IBOutlet weak var btnSendLink: WLButton!
    @IBOutlet weak var txtFieldPhone: CustomTextField!
    
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
    
    /// Insatance
    ///
    /// - Returns: ChangeMobileNumberViewController
    class func instance() -> ChangeMobileNumberViewController? {
        return StoryBoard.ChangeMobileNumber.board.instantiateViewController(withIdentifier: AppClass.ChangeMobileNumberVC.rawValue) as? ChangeMobileNumberViewController
    }
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = ChangeMobileNumberInteractor()
        let presenter = ChangeMobileNumberPresenter()
        //  let router = ChangeMobileNumberRouter()
        viewController.interactor = interactor
        // viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        //   router.viewController = viewController
        //   router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    /// Setup ui
    func setupLayout() {
        self.navigationItem.title = AlertMessage.changePhoneTitle
        btnSendLink.addLoginButtonShadowAndCornerRadius()
        txtFieldPhone.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.txtFieldPhone.becomeFirstResponder()
    }
    
    /// Valididate input fields
    fileprivate func validiateInput() {
        guard self.internetAvailable() else {
            return
        }
        self.view.endEditing(true)
        do {
            let phone = try txtFieldPhone.validatedText(validationType: ValidatorType.phone)
            let phoneNumber = phone.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            
            let request = CheckUniqueUser.Request(phone: phoneNumber, email: "", userName:"")
            interactor?.getOtp(request: request)
            
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    /// Send Verification code on entered number
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnSendPasswordLinkAction(_ sender: WLButton) {
        validiateInput()
    }
    
    /// Phone number formateing while text field editing
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldPhone.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10 {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldPhone.text = str
    }
}

extension ChangeMobileNumberViewController: ChangeMobileNumberDisplayLogic {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceivecOtpResponse(response: CheckUniqueUser.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                self.showTopMessage(message: message, type: .Success)
                let phone = txtFieldPhone.text?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                if let verifyOtp = OTPVerificationViewController.instance() {
                    verifyOtp.isFrom = "changePhoneNumber"
                    verifyOtp.otp = data.otp!
                    verifyOtp.phoneNumber = phone ?? ""
                    self.navigationController?.pushViewController(verifyOtp, animated: true)
                }
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
