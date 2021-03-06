//
//  ChatInteractor.swift
//  MadCollab
//
//  Created by Appineers India on 17/05/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChatBusinessLogic
{
    func sendMessage(request: SendMessage.Request)
    func deleteMessage(request: DeleteMessage.Request)
    func blockUser(request: BlockUser.Request)
}

protocol ChatDataStore
{
  //var name: String { get set }
}

class ChatInteractor: ChatBusinessLogic, ChatDataStore
{
  var presenter: ChatPresentationLogic?
  var worker: ChatWorker?
  //var name: String = ""
  
  // MARK: Do something
    func sendMessage(request: SendMessage.Request)
    {
      worker = ChatWorker()
      worker?.sendMessage(request: request, completionHandler: { (message, success) in
          self.presenter?.presentSendMessageResponse(message: message ?? "", successCode: success ?? "0")
      })
    }
    
    func deleteMessage(request: DeleteMessage.Request)
    {
      worker = ChatWorker()
      worker?.deleteMessage(request: request, completionHandler: { (message, success) in
          self.presenter?.presentDeleteMessageResponse(message: message ?? "", successCode: success ?? "0")
      })
    }
    
    func blockUser(request: BlockUser.Request)
    {
      worker = ChatWorker()
      worker?.blockUser(request: request, completionHandler: { (message, success) in
          self.presenter?.presentBlockUserResponse(message: message ?? "", successCode: success ?? "0")
      })
    }
}
