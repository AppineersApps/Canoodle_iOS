//
//  SendFeedbackPresenter.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.

import UIKit

/// Protocol for presentation
protocol SendFeedbackPresentationLogic {
    /// Present Send Feedback Response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - successCode: API Success Code
    func presentSendFeedbackResponse(message: String, successCode: String)
}

/// Presenter class for API Response
class SendFeedbackPresenter: SendFeedbackPresentationLogic {
    
    /// View controller instance for send feedback
    weak var viewController: SendFeedbackDisplayLogic?
    
    /// Present Send Feedback Response
    ///
    /// - Parameters:
    ///   - message: API Message
    ///   - successCode: API Success Code
    func presentSendFeedbackResponse(message: String, successCode: String) {
        viewController?.didReceiveSendFeedbackResponse(message: message, successCode: successCode)
    }
}
