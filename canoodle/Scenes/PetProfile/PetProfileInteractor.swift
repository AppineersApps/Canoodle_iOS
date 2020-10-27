//
//  PetProfileInteractor.swift
//  canoodle
//
//  Created by Appineers India on 20/10/20.
//  Copyright (c) 2020 The Appineers. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PetProfileBusinessLogic
{
    func uploadMedia(request: UploadMedia.Request)
    func updatePetProfile(request: UpdatePetProfile.Request)
    func deleteMedia(request: DeleteMedia.Request)
}

protocol PetProfileDataStore
{
  //var name: String { get set }
}

class PetProfileInteractor: PetProfileBusinessLogic, PetProfileDataStore
{
  var presenter: PetProfilePresentationLogic?
  var worker: PetProfileWorker?
  //var name: String = ""
  
  // MARK: Do something
  
    func uploadMedia(request: UploadMedia.Request) {
        worker = PetProfileWorker()
        worker?.uploadMedia(request: request, completionHandler: { (message, success) in
            self.presenter?.presentUploadMediaResponse(message: message ?? "", success: success ?? "")
        })
    }
    
    func updatePetProfile(request: UpdatePetProfile.Request) {
        worker = PetProfileWorker()
        worker?.updatePetProfile(request: request, completionHandler: { (message, success) in
            self.presenter?.presentUpdatePetProfileResponse(message: message ?? "", success: success ?? "")
        })
    }
    
    func deleteMedia(request: DeleteMedia.Request)
    {
      worker = PetProfileWorker()
      worker?.deleteMedia(request: request, completionHandler: { (message, success) in
          self.presenter?.presentDeleteMediaResponse(message: message ?? "", successCode: success ?? "0")
      })
    }
}
