//
//  EditProfilePresenter.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit

/// Protocol for presentation
protocol EditProfilePresentationLogic {
    /// Present state list response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API  Message
    ///   - successCode: API Success
    func presentStateList(response: [StateList.ViewModel]?, message: String, successCode: String)
    ///Present EDIT Profile Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func presentEditProfileResponse(response: [Login.ViewModel]?, message: String, successCode: String)
}

class EditProfilePresenter: EditProfilePresentationLogic {
    /// View controller instance for edit profile
    weak var viewController: EditProfileDisplayLogic?
    
    /// Present state list response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API  Message
    ///   - successCode: API Success
    func presentStateList(response: [StateList.ViewModel]?, message: String, successCode: String) {
        viewController?.didReceiveStateListResponse(response: response, message: message, successCode: successCode)
    }
    
    ///Present EDIT Profile Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func presentEditProfileResponse(response: [Login.ViewModel]?, message: String, successCode: String) {
        viewController?.didReceiveEditProfileResponse(viewModel: response, message: message, successCode: successCode)
    }
}
