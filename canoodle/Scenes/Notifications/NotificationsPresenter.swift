//
//  NotificationsPresenter.swift
//  MadCollab
//
//  Created by Appineers India on 28/04/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol NotificationsPresentationLogic
{
    func presentNotificationsResponse(response: [Notification.ViewModel]?, message: String, successCode: String)
}

class NotificationsPresenter: NotificationsPresentationLogic
{
  weak var viewController: NotificationsDisplayLogic?
  
  // MARK: Do something
    func presentNotificationsResponse(response: [Notification.ViewModel]?, message: String, successCode: String) {
          viewController?.didReceiveNotificationsResponse(response: response, message: message, successCode: successCode)
    }
}
