//
//  EditProfileInteractor.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit

/// Protocol for edit profile API
protocol EditProfileBusinessLogic {
    /// Call state list API
    func callStateAPI()
    /// Call Edit profile API
    ///
    /// - Parameter request: Edit profile Request
    func callEditProfileAPI(request: EditProfile.Request)
}

protocol EditProfileDataStore {
    //var name: String { get set }
}

/// Class for edit profile interactor
class EditProfileInteractor: EditProfileBusinessLogic, EditProfileDataStore {
    /// Presentor instance
    var presenter: EditProfilePresentationLogic?
    /// Worker instance
    var worker: EditProfileWorker?
    //var name: String = ""
    
    /// Call state list API
    func callStateAPI() {
        worker = EditProfileWorker()
        worker?.getStateListResponse(completionHandler: { (response, message, success) in
            self.presenter?.presentStateList(response: response, message: message ?? "", successCode: success ?? "0")
        })
    }
    
    /// Call Edit profile API
    ///
    /// - Parameter request: Edit profile Request
    func callEditProfileAPI(request: EditProfile.Request) {
        worker = EditProfileWorker()
        worker?.getEditProfileResponse(request: request, completionHandler: { (response, message, successCode) in
            self.presenter?.presentEditProfileResponse(response: response, message: message ?? "", successCode: successCode ?? "0")
        })
    }
}
