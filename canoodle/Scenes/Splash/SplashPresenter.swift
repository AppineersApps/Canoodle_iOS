//
//  SplashPresenter.swift
//  Test
//
//  Created by hb on 11/10/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

/// Protocol for splash presentor
protocol SplashPresentationLogic {
    /// Present version check Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentVersionCheckResponse(response: Splash.ViewModel?, message: String, success: String)
}

/// Class for splash presentor
class SplashPresenter: SplashPresentationLogic {
    /// Viewcontroller for splash
    weak var viewController: SplashDisplayLogic?
    
    // MARK: Do something
    /// Present version check Response
    ///
    /// - Parameters:
    ///   - response: API Response
    ///   - message: API Message
    ///   - success: API Success
    func presentVersionCheckResponse(response: Splash.ViewModel?, message: String, success: String) {
        viewController?.didReceiveVersionCheckResponse(viewModel: response, message: message, successCode: success)
    }
}
