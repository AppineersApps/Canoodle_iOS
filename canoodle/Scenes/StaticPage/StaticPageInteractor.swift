//
//  StaticPageInteractor.swift
//  Pups
//
//  Created by hb on 07/05/19.

import UIKit

/// Protocol for Static Page API
protocol StaticPageBusinessLogic {
    /// Call Static Page API
    ///
    /// - Parameter request: Static Page request
    ///   - showLoader: Allow loader to be visible during API call
    func callStaticPageAPI(request: StaticPage.Request, showLoader: Bool)
    /// Call Static Page API Vwrsion Update
    ///
    /// - Parameter request: Static Page request
    ///   - showLoader: Allow loader to be visible during API call
    func callPageVersionUpdate(request: StaticPage.Request, showLoader: Bool)
}

/// Class for Static Page interactor
class StaticPageInteractor: StaticPageBusinessLogic {
    
    /// Presentor instance
    var presenter: StaticPagePresentationLogic?
    /// Worker instance
    var worker: StaticPageWorker?
    
    /// Call Static Page API
    ///
    /// - Parameter request: Static Page request
    ///   - showLoader: Allow loader to be visible during API call
    func callStaticPageAPI(request: StaticPage.Request, showLoader: Bool) {
        worker = StaticPageWorker()
        worker?.getStaticPageResponse(request: request, showLoader: showLoader, completionHandler: { (response, message, successCode) in
            self.presenter?.presentStaticPageResponse(response: response, message: message ?? "", successCode: successCode ?? "0")
        })
    }
    
    /// Call Static Page API for Version number update
    /// - Parameter request: Static Page request
    /// - Parameter showLoader:  Allow loader to be visible during API call
    func callPageVersionUpdate(request: StaticPage.Request, showLoader: Bool) {
        worker = StaticPageWorker()
       weak var weakSelf = self
        
        worker?.updateAPIVersion(request: request, showLoader: true, completionHandler: { (response, message, successcode) in
            weakSelf?.presenter?.presentStaticPageUpdateResponse(response: response, message: message ?? "", successCode: successcode ?? "0")
        })
    }
}
