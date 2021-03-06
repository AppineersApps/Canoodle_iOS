//
//  NotificationsWorker.swift
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

class NotificationsWorker
{
    
    func getNotifications(completionHandler: @escaping ([Notifications.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
      GetNetworkService.dataRequest(with: NotificationsAPIRouter.getNotifications, showHud: true) { (responce: WSResponse<Notifications.ViewModel>?, error: NetworkError?) in
          if let detail = responce {
              if let data = detail.arrayData, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                  completionHandler(data, msg, detail.setting?.success)
              } else {
                  completionHandler(nil, detail.setting?.message, detail.setting?.success)
              }
          } else {
              completionHandler(nil, error?.erroMessage() ?? AlertMessage.defaultError, "0")
          }
      }
    }
    
    func deleteNotification(request: Notifications.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
      GetNetworkService.updateDataRequest(with: NotificationsAPIRouter.deleteNotification(request: request)) { (responce: WSResponse<SetConnection.Response>?, error: NetworkError?) in
          if let detail = responce {
              if  detail.arrayData != nil, let success = detail.setting?.isSuccess, let msg = detail.setting?.message, success {
                  completionHandler( msg, detail.setting?.success)
              } else {
                  completionHandler(detail.setting?.message, detail.setting?.success)
              }
          } else {
              completionHandler(error?.erroMessage(), "0")
          }
      }
    }
}
