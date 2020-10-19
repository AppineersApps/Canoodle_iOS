//
//  SubscriptionRouter.swift
//  Tyst
//
//  Created by hb on 27/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

@objc protocol SubscriptionRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol SubscriptionDataPassing {
    var dataStore: SubscriptionDataStore? { get }
}

class SubscriptionRouter: NSObject, SubscriptionRoutingLogic, SubscriptionDataPassing {
    weak var viewController: SubscriptionViewController?
    var dataStore: SubscriptionDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: SubscriptionViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: SubscriptionDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
