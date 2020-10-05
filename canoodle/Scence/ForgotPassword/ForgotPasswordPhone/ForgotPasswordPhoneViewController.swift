//
//  ForgotPasswordPhoneViewController.swift
//  WhiteLabel
//

import UIKit

/// Protocol for presenting response
protocol ForgotPasswordPhoneDisplayLogic: class {
    /// Did Receive Forgot Password Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveForgotPasswordResponse(response: ForgotPasswordPhone.ViewModel?, message: String, success: String)
}

/// This class is used for asking user to enter phone number so they can initiate forgot password process.
class ForgotPasswordPhoneViewController: BaseViewController {
    
    // MARK: IBOutlet
    /// Interactor for API Call
    var interactor: ForgotPasswordPhoneBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & ForgotPasswordPhoneRoutingLogic & ForgotPasswordPhoneDataPassing)?
    
    @IBOutlet weak var txtFieldPhoneNumber: CustomTextField!
    
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
    /// - Returns: ForgotPasswordPhoneViewController
    class func instance() -> ForgotPasswordPhoneViewController? {
        return StoryBoard.ForgotPasswordPhone.board.instantiateViewController(withIdentifier: AppClass.ForgotPasswordPhoneVC.rawValue) as? ForgotPasswordPhoneViewController
    }
    
    // MARK: Setup
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = ForgotPasswordPhoneInteractor()
        let presenter = ForgotPasswordPhonePresenter()
        let router = ForgotPasswordPhoneRouter()
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
    
    // MARK: ClassMethod
    /// Set title
    func setupLayout() {
        self.navigationItem.title = AlertMessage.ForgotPasswordTitle
        txtFieldPhoneNumber.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.txtFieldPhoneNumber.becomeFirstResponder()
    }
    
    /// Formate Phone number while textfield editing
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldPhoneNumber.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10 {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldPhoneNumber.text = str
        
    }
    
    /// Validiate all fields and call login api
    func validateFields() {
        guard self.internetAvailable() else {
            return
        }
        do {
            let phone = try txtFieldPhoneNumber.validatedText(validationType: ValidatorType.phone)
            
            let phoneNumber = phone.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            
            self.interactor?.forgotPassword(phone: phoneNumber)
            
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    // MARK: IBAction
    @IBAction func btnSendAction(_ sender: Any) {
        validateFields()
    }
    
}

// MARK: - Forgot Password API Response
extension ForgotPasswordPhoneViewController: ForgotPasswordPhoneDisplayLogic {
    /// Did Receive Forgot Password Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveForgotPasswordResponse(response: ForgotPasswordPhone.ViewModel?, message: String, success: String) {
        if success == "1" {
            router?.navigateToOtp(response: response)
             self.showTopMessage(message: message, type: .Success)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
