//
//  SignUpViewControllerExtension.swift
//  WhiteLabelApp
//
//  Created by hb on 30/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleSignIn

// MARK: - TextField Delegates
extension SignUpViewController: UITextFieldDelegate {
    
    /// Method is called when textfield begins editing
    ///
    /// - Parameter textField: Textfield reference
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtFieldStreet {
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

// MARK: - UIPicker View Delegates
extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
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

// MARK: - API Response
extension SignUpViewController: SignUpDisplayLogic {
    // Social Signup response
    /// Did Receive Email Sign up Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveSocialSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                AppConstants.isLoginSkipped = false
                UserDefaultsManager.setLoggedUserDetails(userDetail: data[0])
                self.showTopMessage(message: message, type: .Success)
                router?.redirectToHome()
                UserDefaultsManager.resetFilter()
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Unique user Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    
    func didReceiveEmailSignUpResponse(viewModel: [Login.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            AppConstants.isLoginSkipped = false
            UserDefaultsManager.resetFilter()
            self.showTopMessage(message: message, type: .Success, displayDuration:8)
            if let loginVC = LoginEmailAndSocialViewController.instance() {
               // loginVC.onboarding = true
                //  UserDefaultsManager.profileSetUpDone = "No"
                let vc = NavController.init(rootViewController: loginVC)
                AppConstants.appDelegate.window?.rootViewController = vc
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    /// Did Receive Social Sign up Response
    ///
    /// - Parameters:
    ///   - Response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveUniqeUser(response: [CheckUniqueUser.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let data = response?[0] {
                self.showTopMessage(message: message, type: .Success)
                if isSocialType == SocialLoginType.none.rawValue {
                    AppConstants.isLoginSkipped = false
                    router?.redirectToOtpVarification(phoneNumber: self.txtFieldMobile.text ?? "", otp: data.otp ?? "", signUpRequest: self.signUpRequest, socialSignUpRequest: self.socialSignUpRequest, socialLogin: false)
                } else {
                    router?.redirectToOtpVarification(phoneNumber: self.txtFieldMobile.text ?? "", otp: data.otp ?? "", signUpRequest: self.signUpRequest, socialSignUpRequest: self.socialSignUpRequest, socialLogin: true)
                }
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
            
        }
    }
    
    /// Did Receive state list Response
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
