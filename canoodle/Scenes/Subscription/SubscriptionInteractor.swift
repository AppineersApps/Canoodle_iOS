//
//  SubscriptionInteractor.swift
//  Tyst
//
//  Created by hb on 27/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol SubscriptionBusinessLogic {
    func manageSubscription(request: ManageSubscription.Request)
}

protocol SubscriptionDataStore {
    //var name: String { get set }
}

class SubscriptionInteractor: SubscriptionBusinessLogic, SubscriptionDataStore {
    var presenter: SubscriptionPresentationLogic?
    var worker: SubscriptionWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    func manageSubscription(request: ManageSubscription.Request) {
        worker = SubscriptionWorker()
        worker?.manageSubscription(request: request, completionHandler: { (message, success) in
            self.presenter?.presentManageSubscription(message: message ?? "", success: success ?? "0")
        })
    }
}
