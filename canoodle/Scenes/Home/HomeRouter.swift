//
//  HomeRouter.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright (c) 2019 hb. All rights reserved.

import UIKit

/// Protocol for home routing
@objc protocol HomeRoutingLogic {
    
}

/// Protocol for home data passing
protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

/// Class for home router
class HomeRouter: NSObject, HomeRoutingLogic, HomeDataPassing {
    /// Viewcontroller instance
    weak var viewController: HomeViewController?
    /// Datastore instance
    var dataStore: HomeDataStore?
}
