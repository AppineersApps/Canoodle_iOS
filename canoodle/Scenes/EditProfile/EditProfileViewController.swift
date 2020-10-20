//
//  EditProfileViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit
import GooglePlaces

/// Protocol for presenting response
protocol EditProfileDisplayLogic: class {
    /// Did Receive  Edit Profile Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveEditProfileResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String)
    /// Did Receive State List Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStateListResponse(response: [StateList.ViewModel]?, message: String, successCode: String)
}

/// This class is used for updating user account details for logged in user.
class EditProfileViewController: BaseViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFieldFirstName: CustomTextField!
    @IBOutlet weak var txtFieldLastName: CustomTextField!
    @IBOutlet weak var txtFieldGender: CustomTextField!
    @IBOutlet weak var txtFieldUserName: CustomTextField!
    @IBOutlet weak var txtFieldMobile: CustomTextField!
    @IBOutlet weak var txtFieldDateOfBirth: CustomTextField!
    @IBOutlet weak var txtFieldStreet: CustomTextField!
    @IBOutlet weak var txtFieldCity: CustomTextField!
    @IBOutlet weak var txtFieldState: CustomTextField!
    @IBOutlet weak var txtFieldZip: CustomTextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var btnUpdate: WLButton!
    
    /// Interactor for API Call
    var interactor: EditProfileBusinessLogic?
    
    var textFieldArray = [UITextField]()
    var textFieldVisibleStatus = [Bool]()
    var textFieldOptionalStatus = [Bool]()
    var signUpField : SignUpConfig.SignUptextField!
    var stateId = ""
    var latitude = ""
    var longitude = ""
    var uploadedFile: Data?
    var pickedImageName = ""
    var fileType = ""
    var stateListData = [StateList.ViewModel]()
    var statePicker = UIPickerView()
    var genderPicker = UIPickerView()
    let datePicker = UIDatePicker()
    
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
        let interactor = EditProfileInteractor()
        let presenter = EditProfilePresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
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
    class func instance() -> EditProfileViewController? {
        return StoryBoard.EditProfile.board.instantiateViewController(withIdentifier: AppClass.EditProfileVC.rawValue) as? EditProfileViewController
    }
    
    // MARK: Class Methods
    // SetUpLayout initial setup UI and hide/show button base on json
    func setUpLayout() {
        self.title = AlertMessage.editProfileTitle
        textFieldArray = [txtFieldFirstName, txtFieldLastName, txtFieldGender, txtFieldUserName, txtFieldMobile, txtFieldDateOfBirth, txtFieldStreet, txtFieldCity, txtFieldState, txtFieldZip]
        self.accessConfigFile()
        self.setUserData()
        self.showDatePicker()
        self.txtFieldMobile.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
        if (AppConstants.appType == LoginWith.phone) || (AppConstants.appType == LoginWith.socialPhone) {
            self.txtFieldMobile.isHidden = true
        } else {
            self.lblPhoneNumber.isHidden = true
        }
        self.txtFieldMobile.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
        //statePicker.delegate = self
        //statePicker.dataSource = self
        //self.txtFieldState.inputView = statePicker
        //self.txtFieldState.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        genderPicker.delegate = self
        genderPicker.dataSource = self
        self.txtFieldGender.inputView = genderPicker
        self.txtFieldGender.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(genderSelectionDone))
       // btnUpdate.addLoginButtonShadowAndCornerRadius()
        if textFieldVisibleStatus[8] && !(WhiteLabelSessionHandler.shared.stateListDate.count > 0) {
            interactor?.callStateAPI()
        } else if textFieldVisibleStatus[8] && (WhiteLabelSessionHandler.shared.stateListDate.count > 0) {
            self.stateListData = WhiteLabelSessionHandler.shared.stateListDate
        }
    }
    
    /// Set UserData prefilled
    func setUserData() {
        let loginData = UserDefaultsManager.getLoggedUserDetails()
        self.txtFieldFirstName.text = loginData?.firstName
        self.txtFieldLastName.text = loginData?.lastName
        self.txtFieldGender.text = loginData?.gender
        self.lblEmail.text = loginData?.email
        self.txtFieldUserName.text = loginData?.userName
        self.txtFieldMobile.text = (loginData?.mobileNo ?? "").toPhoneNumber()
        self.lblPhoneNumber.text = (loginData?.mobileNo ?? "").toPhoneNumber()
        self.txtFieldStreet.text = loginData?.address
        self.txtFieldCity.text = loginData?.city
        self.txtFieldState.text = loginData?.state
        self.txtFieldZip.text = loginData?.zipCode
        self.txtFieldDateOfBirth.text = (loginData?.dob ?? "").convertDateFormaterForAPP()
        self.stateId = loginData?.stateId ?? ""
        self.imgProfile.setImage(with: loginData?.userProfile, placeHolder: #imageLiteral(resourceName: "signup_default_user"))
    }
    
    /// Access config file based on this hide show textfield
    func accessConfigFile() {
        self.signUpField = SignUpConfig.SignUptextField()
        
        textFieldVisibleStatus = [signUpField.firstname.visible.booleanStatus(), signUpField.lastname.visible.booleanStatus(), signUpField.gender.visible.booleanStatus(), signUpField.username.visible.booleanStatus(), signUpField.phonenumber.visible.booleanStatus(), signUpField.dateofbirth.visible.booleanStatus(), signUpField.streetaddress.visible.booleanStatus(), signUpField.city.visible.booleanStatus(), signUpField.state.visible.booleanStatus(), signUpField.zip.visible.booleanStatus(), true, true]
        
        textFieldOptionalStatus = [signUpField.firstname.optional.booleanStatus(), signUpField.lastname.optional.booleanStatus(), signUpField.gender.optional.booleanStatus(), signUpField.username.optional.booleanStatus(), signUpField.phonenumber.optional.booleanStatus(), signUpField.dateofbirth.optional.booleanStatus(), signUpField.streetaddress.optional.booleanStatus(), signUpField.city.optional.booleanStatus(), signUpField.state.optional.booleanStatus(), signUpField.zip.optional.booleanStatus(), false, false]
        
        for (index, textField) in textFieldArray.enumerated() {
            textField.isHidden = !textFieldVisibleStatus[index]
            if textFieldOptionalStatus[index] {
                let placeHolder = textField.placeholder ?? ""
                textField.placeholder = placeHolder + " (optional)"
            }
        }
    }
    
    /// Set address to text fields
    ///
    /// - Parameters:
    ///   - addressArr: [String]
    ///   - textField: UITextField
    func setAddress(addressArr: [String], textField:UITextField) {
        if signUpField.city.visible.booleanStatus() && signUpField.state.visible.booleanStatus() {
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
                //                self.setAddress(addressArr: addressArr, textField: self.txtFieldStreet)
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
            self.stateId = ""
            let stateData = self.stateListData.filter {$0.state == self.txtFieldState.text}
            if stateData.count > 0 {
                self.stateId = stateData[0].stateId ?? ""
            }
        }*/
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
    
    /// Validate required textfield check
    func validateFields() {
        do {
            _ = try fileType.checkContains(optional: signUpField.profilepictureoptional.booleanStatus())
            _ = try txtFieldFirstName.validatedText(validationType: ValidatorType.firstname,
                                                    visibility: signUpField.firstname.visible.booleanStatus(), optional: signUpField.firstname.optional.booleanStatus())
            _ = try txtFieldLastName.validatedText(validationType: ValidatorType.lastname,
                                                   visibility: signUpField.lastname.visible.booleanStatus(), optional: signUpField.lastname.optional.booleanStatus())
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
            
            let request = EditProfile.Request(firstName: self.txtFieldFirstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", lastName: self.txtFieldLastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", gender: self.txtFieldGender.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", userName: self.txtFieldUserName.text ?? "", mobileNo: self.txtFieldMobile.text?.getPhoneNumber() ?? "", userProfileName: self.pickedImageName, userProfile: self.uploadedFile ?? Data(), dob: (self.txtFieldDateOfBirth.text ?? "").convertDateFormaterForAPI(), age: String(calcAge(birthday: self.txtFieldDateOfBirth.text!)) , address: self.txtFieldStreet.text ?? "", city: self.txtFieldCity.text ?? "", lat: self.latitude, long: self.longitude, stateName: self.txtFieldState.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", zipCode: self.txtFieldZip.text ?? "")
            interactor?.callEditProfileAPI(request: request)
        } catch(let error) {
            self.showTopMessage(message: (error as? ValidationError)?.message, type: .Error)
        }
    }
    
    // MARK: WLButton Action
    ///
    /// - Parameter sender: WLButton
    @objc func doneButtonClicked(_ sender: Any) {
        if stateListData.count > 0 {
            let aValue = self.stateListData[self.statePicker.selectedRow(inComponent: 0)]
            self.txtFieldState.text = aValue.state ?? ""
            self.stateId = aValue.stateId ?? ""
        }
    }
    
    @objc func genderSelectionDone(_ sender: Any) {
        self.txtFieldGender.text = self.genderData[self.genderPicker.selectedRow(inComponent: 0)]
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
    
    /// Formate Phone number while editing
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldMobile.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10 {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldMobile.text = str
    }
    
    /// Date picker value change event fire action
    @objc func datePickerValueChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConstants.dobFormate
        txtFieldDateOfBirth.text = formatter.string(from: datePicker.date)
    }
    
    /// Open date picker
    @objc func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.year = -18
        let minDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = minDate
        //datePicker.minimumDate = minDate
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        txtFieldDateOfBirth.inputView = datePicker
        self.txtFieldDateOfBirth.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(donedatePicker))
    }
    
    // MARK: WLButton Action
    @IBAction func btnUserProfileAction(_ sender: Any) {
        CustomImagePicker.shared.openImagePickerWith(mediaType: .MediaTypeImage, allowsEditing: true, actionSheetTitle: AppInfo.kAppName, message: "", cancelButtonTitle: "Cancel", cameraButtonTitle: "Camera", galleryButtonTitle: "Gallery") { (_, success, dict) in
            if success {
                if let img = (dict!["edited_image"] as? UIImage) {
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
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        if self.internetAvailable() {
            self.validateFields()
        }
    }
}

//API Response
extension EditProfileViewController: EditProfileDisplayLogic {
    /// Did Receive  Edit Profile Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveEditProfileResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                UserDefaultsManager.setLoggedUserDetails(userDetail: data[0])
                self.showTopMessage(message: message, type: .Success)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
        
    }
    /// Did Receive State List Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveStateListResponse(response: [StateList.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = response {
                WhiteLabelSessionHandler.shared.setStateList(data: data)
                self.stateListData = data
            }
        }
    }
}

//UITextfield Delegate
extension EditProfileViewController: UITextFieldDelegate {
    
    /// Method is called when textfield begins editing
    ///
    /// - Parameter textField: Textfield reference
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFieldCity {
            if let googleApi = GoogleSearch.instance() {
                googleApi.completion = {predictor, error in
                    guard error == nil else {return}
                    self.txtFieldStreet.text = ""
                    if let predictor = predictor {
                        let placeClient = GMSPlacesClient.shared()
                        placeClient.lookUpPlaceID(predictor.placeID) { (place, error) in
                            if error == nil {
                                self.txtFieldStreet.text = ""
                                self.txtFieldState.text = ""
                                self.txtFieldCity.text = ""
                                self.txtFieldZip.text = ""
                                self.stateId = ""
                                self.latitude = String(describing: (place?.coordinate.latitude)!)
                                self.longitude = String(describing: (place?.coordinate.longitude)!)
                                self.setSearchDetailsAddress(addressComponent: (place?.addressComponents)!)
                            }
                        }
                    }
                }
                googleApi.modalPresentationStyle = .fullScreen
                self.present(googleApi, animated: true, completion: nil)
            }
        }
    }
}

//UIPickerview Method
extension EditProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// Returns Number of componenets in picker view
    ///
    /// - Parameter pickerView: Pickerview Reference
    /// - Returns: Number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Returns number of rows in pickerview
    ///
    /// - Parameters:
    ///   - pickerView: Pickerview reference
    ///   - component: Component in pickerview
    /// - Returns: Returns array count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.isEqual(genderPicker)) {
            return genderData.count
        }
        return self.stateListData.count
    }
    
    /// Title for picker view
    ///
    /// - Parameters:
    ///   - pickerView: picker view reference
    ///   - row: Row for pickerview
    ///   - component: component
    /// - Returns: Returns string value
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.isEqual(genderPicker)) {
            return genderData[row]
        }
        return stateListData[row].state ?? ""
    }
}
