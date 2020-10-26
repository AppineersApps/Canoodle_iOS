//
//  BlockedUserWorker.swift
//  Time2Beat
//
//  Created by Appineers India on 17/09/20.
//  Copyright (c) 2020 The Appineers. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class BlockedUserWorker
{
  func blockedUsers(request: Connection.Request, completionHandler: @escaping ([Connection.ViewModel]?, _ message: String?, _ successCode: String?) -> Void) {
    GetNetworkService.dataRequest(with: GetConnectionAPIRouter.getConnections(request: request), showHud: true) { (responce: WSResponse<Connection.ViewModel>?, error: NetworkError?) in
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
    
    func unblockUser(request: BlockUser.Request, completionHandler: @escaping ( _ message: String?, _ successCode: String?) -> Void) {
        NetworkService.dataRequest(with: BlockUserAPIRouter.blockUser(request: request)) { (responce: WSResponse<BlockUser.Response>?, error: NetworkError?) in
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
