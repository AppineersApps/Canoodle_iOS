//
//  SignUpViewController.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit
import GooglePlaces
import GoogleSignIn
import AuthenticationServices

/// Protocol for presenting response
protocol SignUpDisplayLogic: class {
    /// Did Receive Email Sign up Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveEmailSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String)
    /// Did Receive Unique user Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveUniqeUser(response: [CheckUniqueUser.ViewModel]?, message: String, success: String)
    /// Did Receive Social Sign up Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String)
    /// Did Receive state list Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStateListResponse(response: [StateList.ViewModel]?, message: String, successCode: String)
}

/// This class is used for creating a new user account in the app.
class SignUpViewController: BaseViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFieldFirstName: CustomTextField!
    @IBOutlet weak var txtFieldLastName: CustomTextField!
    @IBOutlet weak var txtFieldGender: CustomTextField!
    @IBOutlet weak var txtFieldUserName: CustomTextField!
    @IBOutlet weak var txtFieldEmail: CustomTextField!
    @IBOutlet weak var txtFieldMobile: CustomTextField!
    @IBOutlet weak var txtFieldDateOfBirth: CustomTextField!
    @IBOutlet weak var txtFieldStreet: CustomTextField!
    @IBOutlet weak var txtFieldCity: CustomTextField!
    @IBOutlet weak var txtFieldState: CustomTextField!
    @IBOutlet weak var txtFieldZip: CustomTextField!
    @IBOutlet weak var txtFieldPassword: CustomTextField!
    @IBOutlet weak var txtFieldConfirmPassword: CustomTextField!
    @IBOutlet weak var btntermsConditions: WLButton!
    @IBOutlet weak var txtViewTerms: UITextView!
    @IBOutlet weak var btnCreate: WLButton!
    
    /// Interactor for API Call
    var interactor: SignUpBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & SignUpRoutingLogic & SignUpDataPassing)?
    var textFieldArray = [UITextField]()
    public var textFieldVisibleStatus = [Bool]()
    var textFieldOptionalStatus = [Bool]()
    var signUpField : SignUpConfig.SignUptextField!
    var uploadedFile: Data?
    var pickedImageName = ""
    var fileType = ""
    let datePicker = UIDatePicker()
    var latitude = ""
    var longitude = ""
    var addressArray = ["", "", "", ""]
    var signUpRequest: SignUp.SignUpPhoneModel.Request?
    var socialSignUpRequest: SignUp.SignUpSocialModel.Request?
    var facbookUserData = [String : AnyObject]()
    var googleDict:  GIDGoogleUser!
    var appleUserData = [String : AnyObject]()
    var isSocialType = ""
    var socialLoginId = ""
    var stateListData = [StateList.ViewModel]()
    var statePicker = UIPickerView()
    var genderPicker = UIPickerView()
    //var stateId = ""
    var addData = false
    var genderData = ["Male", "Female", "Non Binary", "Undisclosed"]
    
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
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
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
        self.setUpLayout()
        self.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Instance
    ///
    /// - Returns: SignUpViewController
    class func instance() -> SignUpViewController? {
        return StoryBoard.SignUp.board.instantiateViewController(withIdentifier: AppClass.signUpVC.rawValue) as? SignUpViewController
    }
    
    // MARK: Class Methods
    // SetUpLayout initial setup UI and hide/show button base on json
    func setUpLayout() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = AlertMessage.signUpTitle
        textFieldArray = [txtFieldFirstName, txtFieldLastName, txtFieldGender, txtFieldUserName, txtFieldEmail, txtFieldMobile, txtFieldDateOfBirth, txtFieldStreet, txtFieldCity, txtFieldState, txtFieldZip, txtFieldPassword, txtFieldConfirmPassword]
        self.showDatePicker()
        self.accessConfigFile()
        self.txtFieldMobile.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
        //statePicker.delegate = self
        //statePicker.dataSource = self
        //self.txtFieldState.inputView = statePicker
        //self.txtFieldState.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        genderPicker.delegate = self
        genderPicker.dataSource = self
        self.txtFieldGender.inputView = genderPicker
        self.txtFieldGender.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(genderSelectionDone))
        btnCreate.addLoginButtonShadowAndCornerRadius()
        if isSocialType == SocialLoginType.facebook.rawValue {
            txtFieldPassword.isHidden = true
            txtFieldConfirmPassword.isHidden = true
            txtFieldFirstName.text = facbookUserData["first_name"] as? String ?? ""
            txtFieldLastName.text = facbookUserData["last_name"] as? String ?? ""
            txtFieldEmail.text = facbookUserData["email"] as? String ?? ""
            let faceBookId = facbookUserData["id"] as? String ?? ""
            self.imgProfile.setImage(with: "http://graph.facebook.com/\(faceBookId)/picture?type=large&redirect=true&width=500&height=500", placeHolder:  #imageLiteral(resourceName: "signup_default_user"))
            socialLoginId = facbookUserData["id"] as? String ?? ""
        } else if isSocialType == SocialLoginType.google.rawValue {
            txtFieldPassword.isHidden = true
            txtFieldConfirmPassword.isHidden = true
            txtFieldFirstName.text = googleDict.profile.givenName ?? ""
            txtFieldLastName.text = googleDict.profile.familyName ?? ""
            txtFieldEmail.text = googleDict.profile.email ?? ""
            self.imgProfile.setImage(with: googleDict.profile.imageURL(withDimension: 500).absoluteString, placeHolder: #imageLiteral(resourceName: "signup_default_user"))
            socialLoginId = googleDict.userID ?? ""
            let img = imgProfile.image ?? UIImage()
            self.imgProfile.setBorder(color: #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1), size: 1)
            self.uploadedFile = img.compressTo(0.5)
            self.fileType = "png"
            self.pickedImageName = "\(NSTimeIntervalSince1970).png"
        } else if isSocialType == SocialLoginType.apple.rawValue {
            if #available(iOS 13.0, *) {
                if (appleUserData["data"] as? ASAuthorizationAppleIDCredential) != nil {
                    self.socialLoginId = KeychainItem.currentUserIdentifier ?? ""
                    txtFieldPassword.isHidden = true
                    txtFieldConfirmPassword.isHidden = true
                    txtFieldFirstName.text = KeychainItem.currentUserFirstName
                    txtFieldLastName.text = KeychainItem.currentUserLastName
                    txtFieldEmail.text = KeychainItem.currentUserEmail
                }
            }
        }
        /*if textFieldVisibleStatus[9] && !(WhiteLabelSessionHandler.shared.stateListDate.count > 0) {
            interactor?.callStateAPI()
        } else if textFieldVisibleStatus[9] && (WhiteLabelSessionHandler.shared.stateListDate.count > 0) {
            self.stateListData = WhiteLabelSessionHandler.shared.stateListDate
        }*/
        setUpTermsAndConditionPrivacyLabel()
    }
    
    /// Date picker value change event fire action
    @objc func datePickerValueChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConstants.dobFormate
        txtFieldDateOfBirth.text = formatter.string(from: datePicker.date)
        calcAge(birthday: txtFieldDateOfBirth.text!)
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = AppConstants.dobFormate
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        print("Age = \(age!)")
        return age!
    }
    
    /// Open date picker
    @objc func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = -18
        let minDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = minDate
        //datePicker.minimumDate = minDate
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        txtFieldDateOfBirth.inputView = datePicker
        self.txtFieldDateOfBirth.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(donedatePicker))
    }
    
    /// Access config file based on this hide show textfield
    func accessConfigFile() {
        
        self.signUpField = SignUpConfig.SignUptextField()
        print(signUpField.firstname.visible.booleanStatus())
        
        textFieldVisibleStatus = [signUpField.firstname.visible.booleanStatus(), signUpField.lastname.visible.booleanStatus(), signUpField.gender.visible.booleanStatus(), signUpField.username.visible.booleanStatus(), true, signUpField.phonenumber.visible.booleanStatus(), signUpField.dateofbirth.visible.booleanStatus(), signUpField.streetaddress.visible.booleanStatus(), signUpField.city.visible.booleanStatus(), signUpField.state.visible.booleanStatus(), signUpField.zip.visible.booleanStatus(), true, true]
        textFieldOptionalStatus = [signUpField.firstname.optional.booleanStatus(), signUpField.lastname.optional.booleanStatus(), signUpField.gender.optional.booleanStatus(), signUpField.username.optional.booleanStatus(), false, signUpField.phonenumber.optional.booleanStatus(), signUpField.dateofbirth.optional.booleanStatus(), signUpField.streetaddress.optional.booleanStatus(), signUpField.city.optional.booleanStatus(), signUpField.state.optional.booleanStatus(), signUpField.zip.optional.booleanStatus(), false, false]
        
        for (index, textField) in textFieldArray.enumerated() {
            textField.isHidden = !textFieldVisibleStatus[index]
            if textFieldOptionalStatus[index] {
                let placeHolder = textField.placeholder ?? ""
                textField.placeholder = placeHolder + " (optional)"
            }
        }
    }
    
    /// Validate required textfield check
    func validateFields() {
        do {
            _ = try fileType.checkContains(optional: signUpField.profilepictureoptional.booleanStatus())
            _ = try txtFieldFirstName.validatedText(validationType: ValidatorType.firstname,
                                                    visibility: signUpField.firstname.visible.booleanStatus(), optional: signUpField.firstname.optional.booleanStatus())
            _ = try txtFieldLastName.validatedText(validationType: ValidatorType.lastname,
                                                   visibility: signUpField.lastname.visible.booleanStatus(), optional: signUpField.lastname.optional.booleanStatus())

            _ = try txtFieldEmail.validatedText(validationType: ValidatorType.email,
                                                visibility: true, optional: false)
            _ = try txtFieldUserName.validatedText(validationType: ValidatorType.username,
                                                   visibility: signUpField.username.visible.booleanStatus(), optional: signUpField.username.optional.booleanStatus())
            _ = try txtFieldMobile.validatedText(validationType: ValidatorType.phone,
                                                 visibility: signUpField.phonenumber.visible.booleanStatus(), optional: signUpField.phonenumber.optional.booleanStatus())
            _ = try txtFieldStreet.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirestreetAddress),
                                                 visibility: signUpField.streetaddress.visible.booleanStatus(), optional: signUpField.streetaddress.optional.booleanStatus())
            _ = try txtFieldCity.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirecity),
                                               visibility: signUpField.city.visible.booleanStatus(), optional: signUpField.city.optional.booleanStatus())
            _ = try txtFieldState.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirestate),
                                                visibility: signUpField.state.visible.booleanStatus(), optional: signUpField.state.optional.booleanStatus())
            _ = try txtFieldZip.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requirezip),
                                              visibility: signUpField.zip.visible.booleanStatus(), optional: signUpField.zip.optional.booleanStatus())
            _ = try txtFieldZip.validatedText(validationType: ValidatorType.zipcode,
                                              visibility: signUpField.zip.visible.booleanStatus(), optional: signUpField.zip.optional.booleanStatus())
            _ = try txtFieldDateOfBirth.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requiredateOfBirth),
                                                      visibility: signUpField.dateofbirth.visible.booleanStatus(), optional: signUpField.dateofbirth.optional.booleanStatus())
            _ = try txtFieldPassword.validatedText(validationType: ValidatorType.password(message: AlertMessage.invalidPassword), visibility: isSocialType == SocialLoginType.none.rawValue ? true: false, optional: false)
            _ = try txtFieldConfirmPassword.validatedText(validationType: ValidatorType.requiredField(message: AlertMessage.requireConfirmPassword),
                                                          visibility: isSocialType == SocialLoginType.none.rawValue ? true: false, optional: false)
            _ = try txtFieldConfirmPassword.validatedText(validationType: ValidatorType.confirmpassword(password: txtFieldPassword.text ?? "", reqMessage: AlertMessage.requireConfirmPassword, equalMessage: AlertMessage.passwordConfirmPassword),
                                                          visibility: isSocialType == SocialLoginType.none.rawValue ? true: false, optional: false)
            _ = try btntermsConditions.checkSelection()
            callApi()
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    /// Set social Media image to profile image
    func setSocialImage() {
        let img = imgProfile.image ?? UIImage()
        self.imgProfile.setBorder(color: #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1), size: 1)
        self.uploadedFile = img.compressTo(0.5)
        self.fileType = "png"
        self.pickedImageName = "\(NSTimeIntervalSince1970).png"
    }
    
    /// Call Api
    func callApi() {
        if isSocialType == SocialLoginType.none.rawValue {
            switch AppConstants.appType {
            case LoginWith.email, LoginWith.socialEmail :
                interactor?.callSignUpEmailAPI(request: getSignupEmailModel())
            case LoginWith.phone, LoginWith.socialPhone:
                self.signUpRequest = getSignupPhoneModel()
                let uniqeUserRequest = CheckUniqueUser.Request(phone: self.txtFieldMobile.text?.getPhoneNumber() ?? "", email: self.txtFieldEmail.text ?? "", userName : self.txtFieldUserName.text ?? "")
                interactor?.checkUniqUser(request: uniqeUserRequest)
            }
        } else {
            if AppConstants.appType == LoginWith.socialEmail {
                setSocialImage()
                interactor?.callSocialSignUpAPI(request: getSocialSignupModel())
            } else if AppConstants.appType == LoginWith.socialPhone {
                setSocialImage()
                self.socialSignUpRequest = getSocialSignupModel()
                let uniqeUserRequest = CheckUniqueUser.Request(phone: self.txtFieldMobile.text?.getPhoneNumber() ?? "", email: self.txtFieldEmail.text ?? "", userName : self.txtFieldUserName.text ?? "")
                interactor?.checkUniqUser(request: uniqeUserRequest)
            }
        }
    }
    
    /// Create social signup request
    ///
    /// - Returns: SignUp.SignUpSocialModel.Request
    func getSocialSignupModel() -> SignUp.SignUpSocialModel.Request {
        let request = SignUp.SignUpSocialModel.Request(firstName: self.txtFieldFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", lastName: self.txtFieldLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", gender: self.txtFieldGender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Undisclosed", userName: self.txtFieldUserName.text ?? "", email: self.txtFieldEmail.text ?? "", mobileNo: self.txtFieldMobile.text?.getPhoneNumber() ?? "", userProfileName: self.pickedImageName, userProfile: self.uploadedFile ?? Data(), dob: (self.txtFieldDateOfBirth.text ?? "").convertDateFormaterForAPI(), age: String(calcAge(birthday: self.txtFieldDateOfBirth.text!)), address: self.txtFieldStreet.text ?? "", city: self.txtFieldCity.text ?? "", lat: self.latitude, long: self.longitude, state: self.txtFieldState.text ?? "", zipCode: self.txtFieldZip.text ?? "", socialLoginType: isSocialType, socialId: socialLoginId)
        return request
    }
    
    /// Create signup with email request
    ///
    /// - Returns: SignUp.SignUpEmailModel.Request
    func getSignupEmailModel() -> SignUp.SignUpEmailModel.Request {
        let request = SignUp.SignUpEmailModel.Request(firstName: self.txtFieldFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", lastName: self.txtFieldLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", gender: self.txtFieldGender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Undisclosed", userName: self.txtFieldUserName.text ?? "", email: self.txtFieldEmail.text ?? "", mobileNo: self.txtFieldMobile.text?.getPhoneNumber() ?? "", userProfileName: self.pickedImageName, userProfile: self.uploadedFile ?? Data(), dob: (self.txtFieldDateOfBirth.text ?? "").convertDateFormaterForAPI(), age: String(calcAge(birthday: self.txtFieldDateOfBirth.text!)), password: self.txtFieldPassword.text ?? "", address: self.txtFieldStreet.text ?? "", city: self.txtFieldCity.text ?? "", lat: self.latitude, long: self.longitude, state: self.txtFieldState.text ?? "", zipCode: self.txtFieldZip.text ?? "")
        return request
    }
    
    /// Create signup with Phone request
    ///
    /// - Returns: SignUp.SignUpPhoneModel.Request
    func getSignupPhoneModel() -> SignUp.SignUpPhoneModel.Request {
        let request = SignUp.SignUpPhoneModel.Request(firstName: self.txtFieldFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", lastName: self.txtFieldLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", userName: self.txtFieldUserName.text ?? "", email: self.txtFieldEmail.text ?? "", mobileNo: self.txtFieldMobile.text?.getPhoneNumber() ?? "", userProfileName: self.pickedImageName, userProfile: self.uploadedFile ?? Data(), dob: (self.txtFieldDateOfBirth.text ?? "").convertDateFormaterForAPI(), password: self.txtFieldPassword.text ?? "", address: self.txtFieldStreet.text ?? "", city: self.txtFieldCity.text ?? "", lat: self.latitude, long: self.longitude, state:self.txtFieldState.text ?? "", zipCode: self.txtFieldZip.text ?? "")
        return request
    }
    
    // MARK: WLButton Action
    @IBAction func btnUserProfileAction(_ sender: Any) {
        CustomImagePicker.shared.openImagePickerWith(mediaType: .MediaTypeImage, allowsEditing: true, actionSheetTitle: AppInfo.kAppName, message: "", cancelButtonTitle: "Cancel", cameraButtonTitle: "Camera", galleryButtonTitle: "Gallery") { (_, success, dict) in
            if success {
                self.addData = true
                if let img = (dict!["edited_image"] as?  UIImage) {
                    self.imgProfile.layer.cornerRadius = (self.imgProfile.frame.width) / 2
                    self.imgProfile.setBorder(color: #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1), size: 1)
                    self.uploadedFile = img.compressTo(0.5)
                    self.fileType = "png"
                    self.pickedImageName = "\(NSTimeIntervalSince1970).png"
                    self.imgProfile.image = img
                    self.imgProfile.contentMode = .scaleAspectFill
                }
            }
        }
    }
    
    /// Terms and Conditions checkbox tap action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnTermsConditionAction(_ sender: Any) {
        self.btntermsConditions.isSelected = !btntermsConditions.isSelected
    }
    
    /// Signup tap action
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnSignUpAction(_ sender: Any) {
         /*if let onboardingVC = OnboardingViewController.instance() {
             self.navigationController?.pushViewController(onboardingVC, animated: true)
         }*/
        if self.internetAvailable() {
            self.validateFields()
        }
    }
    
    /// Formate Phone number while editing
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldMobile.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10 {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldMobile.text = str
    }
    
    /// Date picker Done action
    @objc func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConstants.dobFormate
        txtFieldDateOfBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    /// Date picker cancel action
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    /// State picker done button tap action
    ///
    /// - Parameter sender: WLButton
    @objc func doneButtonClicked(_ sender: Any) {
        if stateListData.count > 0 {
            let aValue = self.stateListData[self.statePicker.selectedRow(inComponent: 0)]
            self.txtFieldState.text = aValue.state ?? ""
           // self.stateId = aValue.stateId ?? ""
        }
    }
    
    @objc func genderSelectionDone(_ sender: Any) {
        self.txtFieldGender.text = self.genderData[self.genderPicker.selectedRow(inComponent: 0)]
    }
    
    /// Check detail address
    ///
    /// - Parameter addressComponent: GMSAddressComponent
    func setSearchDetailsAddress(addressComponent: [GMSAddressComponent]) {
        var streetArray = [String]()
        for address in addressComponent {
            var addressStr = "\(address)"
            addressStr = addressStr.replacingOccurrences(of: "Types:", with: "")
            let addressArr = addressStr.components(separatedBy: ":")
            if addressStr.contains("street_number, Name") {
                streetArray.append(contentsOf: addressArr)
            } else if addressStr.contains("route, Name") {
                streetArray.append(contentsOf: addressArr)
                self.setAddress(addressArr: streetArray, textField: self.txtFieldStreet)
            } else if addressStr.contains("locality, political, Name") {
                self.setAddress(addressArr: addressArr, textField: self.txtFieldCity)
            } else if addressStr.contains("administrative_area_level_1") {
                self.setAddress(addressArr: addressArr, textField: self.txtFieldState)
            } else if addressStr.contains("postal_code") &&  !addressStr.contains("postal_code_suffix") {
                self.setAddress(addressArr: addressArr, textField: self.txtFieldZip)
            }
        }
        
       /* if txtFieldState.text != "" {
            let stateData = self.stateListData.filter {$0.state == self.txtFieldState.text}
            if stateData.count > 0 {
                self.stateId = stateData[0].stateId ?? ""
            }
        }*/
    }
    
    /// Set address to text fields
    ///
    /// - Parameters:
    ///   - addressArr: [String]
    ///   - textField: UITextField
    func setAddress(addressArr: [String], textField:UITextField) {
        if signUpField.city.visible.booleanStatus() && signUpField.state.visible.booleanStatus() && signUpField.zip.visible.booleanStatus() {
            if addressArr.count > 0 {
                if addressArr.count > 3 {
                    var string = ""
                    if addressArr[1].components(separatedBy: ",").count > 0 {
                        string.append(contentsOf: (addressArr[1].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces))
                        string.append(contentsOf: " ")
                        string.append(contentsOf: (addressArr[4].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces))
                    }
                    textField.text = string
                } else {
                    if addressArr[1].components(separatedBy: ",").count > 0 {
                        textField.text = (addressArr[1].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces)
                    }
                }
            }
        } else {
            if addressArr.count > 0 {
                if addressArr.count > 3 {
                    var string = ""
                    if addressArr[1].components(separatedBy: ",").count > 0 {
                        string.append(contentsOf: (addressArr[1].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces))
                        string.append(contentsOf: " ")
                        string.append(contentsOf: (addressArr[4].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces))
                    }
                    txtFieldStreet.text = string
                } else {
                    if addressArr[1].components(separatedBy: ",").count > 0 {
                        print((addressArr[1].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces))
                        self.txtFieldStreet.text = self.txtFieldStreet.text! + " " + (addressArr[1].components(separatedBy: ",")[0]).trimmingCharacters(in: .whitespaces)
                    }
                }
            }
        }
    }
    
    /// Set up terms and condition and privacy policy label
    func setUpTermsAndConditionPrivacyLabel() {
        txtViewTerms.textContainerInset = .zero
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        txtViewTerms.addGestureRecognizer(tapGesture)
        txtViewTerms.text = " I agree to \(AppInfo.kAppName) Terms & Conditions & Privacy Policy"
        let range = (txtViewTerms.text! as NSString).range(of: txtViewTerms.text)
        let underlineAttriString = NSMutableAttributedString(string: txtViewTerms.text!, attributes: nil)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14.0), range: range)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range)
        
        let range1 = (txtViewTerms.text! as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "1", range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range1)
        
        let range2 = (txtViewTerms.text! as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key(rawValue: "idnum"), value: "2", range: range2)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range2)
        
        let range3 = (txtViewTerms.text! as NSString).range(of: "Terms & Conditions")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range3)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15.0), range: range3)
        
        let range4 = (txtViewTerms.text! as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: range4)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 15.0), range: range4)
        txtViewTerms.attributedText = underlineAttriString
    }
    
    /// Manage tap on terms and policy and privacy policy
    ///
    /// - Parameter recognizer: Gesture calling this method
    @objc func tapLabel(recognizer: UITapGestureRecognizer) {
        if let textView = recognizer.view as? UITextView {
            var location: CGPoint = recognizer.location(in: textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            let charIndex = textView.layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            if charIndex < textView.textStorage.length {
                var range = NSRange(location: 0, length: 0)
                if (textView.attributedText?.attribute(NSAttributedString.Key(rawValue: "idnum"), at: charIndex, effectiveRange: &range) as? NSString) != nil {
                    let tappedPhrase = (textView.attributedText.string as NSString).substring(with: range)
                    if tappedPhrase == "Terms & Conditions" {
                        if let staticPageVC = StaticPageViewController.instance() {
                            staticPageVC.isFrom = StaticPageCode.termsCondition.rawValue
                            self.navigationController?.pushViewController(staticPageVC, animated: true)
                        }
                    }
                    if tappedPhrase == "Privacy Policy" {
                        if let staticPageVC = StaticPageViewController.instance() {
                            staticPageVC.isFrom = StaticPageCode.privacyPolicy.rawValue
                            self.navigationController?.pushViewController(staticPageVC, animated: true)
                        }
                    }
                }
                if let desc = textView.attributedText?.attribute(NSAttributedString.Key(rawValue: "desc"), at: charIndex, effectiveRange: &range) as? NSString {
                    print("desc: \(desc)")
                }
            }
        }
    }
}
