//
//  SubscriptionPresenter.swift
//  Tyst
//
//  Created by hb on 27/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

protocol SubscriptionPresentationLogic {
    func presentManageSubscription(message: String, success: String)
}

class SubscriptionPresenter: SubscriptionPresentationLogic {
    weak var viewController: SubscriptionDisplayLogic?
    
    // MARK: Do something
    
    func presentManageSubscription(message: String, success: String) {
        self.viewController?.didReceiveManageSubscriptionResponse(message: message, success: success)
    }
}
