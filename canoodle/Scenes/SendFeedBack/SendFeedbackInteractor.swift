//
//  SendFeedbackInteractor.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.

import UIKit

/// Protocol for send feedback API
protocol SendFeedbackBusinessLogic {
    /// Call Sendfeedback API
    ///
    /// - Parameter request: Send feedback request
    func callSendFeedbackAPI(request: SendFeedback.Request)
}

/// Protocol Send feedback datastore
protocol SendFeedbackDataStore {
    //var name: String { get set }
}

/// Class for send feedback interactor
class SendFeedbackInteractor: SendFeedbackBusinessLogic, SendFeedbackDataStore {
    /// Presentor instance
    var presenter: SendFeedbackPresentationLogic?
    /// Worker instance
    var worker: SendFeedbackWorker?
    
    /// Call Sendfeedback API
    ///
    /// - Parameter request: Send feedback request
    func callSendFeedbackAPI(request: SendFeedback.Request) {
        worker = SendFeedbackWorker()
        worker?.sendFeedback(request: request, completionHandler: { (message, success) in
            self.presenter?.presentSendFeedbackResponse(message: message ?? "", successCode: success ?? "0")
        })
    }
}
