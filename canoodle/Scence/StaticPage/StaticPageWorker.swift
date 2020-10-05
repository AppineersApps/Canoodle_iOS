//
//  StaticPageWorker.swift
//  Pups
//
//  Created by hb on 07/05/19.

import UIKit

/// Class for static page API calls
class StaticPageWorker {
    /// API call for static page data
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func getStaticPageResponse(request:StaticPage.Request, showLoader: Bool, completionHandler: @escaping ([StaticPage.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: StaticPageAPIRouter.staticPage(request: request), showHud:showLoader ) { (responce: WSResponse<StaticPage.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
        }
    }
    
    /// API call for static page data
    ///
    /// - Parameters:
    ///   - request: Request for API Params
    ///   - completionHandler: Completion handle for api call
    func updateAPIVersion(request:StaticPage.Request, showLoader: Bool, completionHandler: @escaping ([StaticPage.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: StaticPageAPIRouter.staticPageVersionUpdate(request: request), showHud:showLoader ) { (responce: WSResponse<StaticPage.ViewModel>?, error: NetworkError?) in
            if let detail = responce {
                if let resparray = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                    completionHandler(resparray, msg, detail.setting?.success)
                } else {
                    completionHandler(nil, detail.setting?.message, detail.setting?.success)
                }
            } else {
                completionHandler(nil, error?.erroMessage(), "0")
            }
        }
    }
}
