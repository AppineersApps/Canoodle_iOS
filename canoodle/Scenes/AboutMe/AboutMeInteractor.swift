//
//  AboutMeInteractor.swift
//  MadCollab
//
//  Created by Appineers India on 07/09/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AboutMeBusinessLogic
{
    func updateProfile(request: UpdateProfile.Request)
}

protocol AboutMeDataStore
{
  //var name: String { get set }
}

class AboutMeInteractor: AboutMeBusinessLogic, AboutMeDataStore
{
  var presenter: AboutMePresentationLogic?
  var worker: AboutMeWorker?
  //var name: String = ""
  
  // MARK: Do something
    func updateProfile(request: UpdateProfile.Request) {
        worker = AboutMeWorker()
        worker?.updateProfile(request: request, completionHandler: { (message, success) in
            self.presenter?.presentUpdateProfileResponse(message: message ?? "", success: success ?? "")
        })
    }
}
