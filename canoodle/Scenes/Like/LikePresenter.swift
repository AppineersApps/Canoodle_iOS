//
//  LikePresenter.swift
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

protocol LikePresentationLogic
{
    func presentGetConnectionsResponse(response: [Connection.ViewModel]?, message: String, successCode: String)
}

class LikePresenter: LikePresentationLogic
{
  weak var viewController: LikeDisplayLogic?
  
  // MARK: Do something
    func presentGetConnectionsResponse(response: [Connection.ViewModel]?, message: String, successCode: String) {
      viewController?.didReceiveGetConnectionsResponse(response: response, message: message, successCode: successCode)
    }
}