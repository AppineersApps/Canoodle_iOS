//
//  PetProfileViewController.swift
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

protocol PetProfileDisplayLogic: class
{
  func displaySomething(viewModel: PetProfile.Something.ViewModel)
}

class PetProfileViewController: UIViewController, PetProfileDisplayLogic
{
  var interactor: PetProfileBusinessLogic?
  var router: (NSObjectProtocol & PetProfileRoutingLogic & PetProfileDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = PetProfileInteractor()
    let presenter = PetProfilePresenter()
    let router = PetProfileRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = PetProfile.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: PetProfile.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
