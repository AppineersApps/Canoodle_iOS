//
//  SplashInteractor.swift
//  Test
//
//  Created by hb on 11/10/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

/// Protocol for Splash API
protocol SplashBusinessLogic {
    /// Call API for Version Check
    func callVersionCheckAPI()
}

/// /// Protocol for Splash Data Store
protocol SplashDataStore {
    //var name: String { get set }
}

/// Class for Splash interactor
class SplashInteractor: SplashBusinessLogic, SplashDataStore {
    /// Presentor instance
    var presenter: SplashPresentationLogic?
    /// Worker instance
    var worker: SplashWorker?
    
    /// Call API for Version Check
    func callVersionCheckAPI() {
        worker = SplashWorker()
        
        worker?.versionCheck(completionHandler: { (response, message, success) in
            self.presenter?.presentVersionCheckResponse(response: response, message: message ?? "", success: success ?? "0")
        })
    }
}
