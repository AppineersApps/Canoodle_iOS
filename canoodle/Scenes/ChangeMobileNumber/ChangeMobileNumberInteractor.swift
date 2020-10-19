//
//  ChangeMobileNumberInteractor.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.

import UIKit

/// Protocol for change mobile number API
protocol ChangeMobileNumberBusinessLogic {
    /// Call GET OTP API
    ///
    /// - Parameter request: Get OTP request
    func getOtp(request: CheckUniqueUser.Request)
}

/// Change Mobile Number Data Store
protocol ChangeMobileNumberDataStore {
    
}

/// Change Mobile Number Interactor
class ChangeMobileNumberInteractor: ChangeMobileNumberBusinessLogic, ChangeMobileNumberDataStore {
    /// Presentor instance
    var presenter: ChangeMobileNumberPresentationLogic?
    /// Worker instance
    var worker: ChangeMobileNumberWorker?
    
    /// Call GET OTP API
    ///
    /// - Parameter request: Get OTP request
    func getOtp(request: CheckUniqueUser.Request) {
        worker = ChangeMobileNumberWorker()
        worker?.getOtp(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentOtp(response: response, message: message ?? "", success: success ?? "0")
        })
    }
    
}
