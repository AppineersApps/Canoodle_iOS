//
//  LikeInteractor.swift
//  canoodle
//
//  Created by Appineers India on 12/10/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LikeBusinessLogic
{
    func getConnections(request: Connection.Request)
}

protocol LikeDataStore
{
  //var name: String { get set }
}

class LikeInteractor: LikeBusinessLogic, LikeDataStore
{
  var presenter: LikePresentationLogic?
  var worker: LikeWorker?
  //var name: String = ""
  
  // MARK: Do something
  
    func getConnections(request: Connection.Request) {
        worker = LikeWorker()
        worker?.getConnections(request: request, completionHandler: { (response, message, success) in
            self.presenter?.presentGetConnectionsResponse(response: response, message: message ?? "", successCode: success ?? "0")
        })
    }
}