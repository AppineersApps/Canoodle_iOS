//
//  BreedsRouter.swift
//  MadCollab
//
//  Created by Appineers India on 29/04/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol BreedsRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol BreedsDataPassing
{
  var dataStore: BreedsDataStore? { get }
}

class BreedsRouter: NSObject, BreedsRoutingLogic, BreedsDataPassing
{
  weak var viewController: BreedsViewController?
  var dataStore: BreedsDataStore?
  
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
  
  //func navigateToSomewhere(source: BreedsViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: BreedsDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
