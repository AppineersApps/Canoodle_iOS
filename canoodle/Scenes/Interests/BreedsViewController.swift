//
//  BreedsViewController.swift
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
import CRRefresh


protocol BreedsDisplayLogic: class
{
    func didReceiveGetBreedsResponse(response: [Breeds.ViewModel]?, message: String, successCode: String)
}

class BreedsViewController: UIViewController
{
    @IBOutlet weak var breedCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
  var interactor: BreedsBusinessLogic?
  var router: (NSObjectProtocol & BreedsRoutingLogic & BreedsDataPassing)?
    
    var breedNamesArray = ["UI/UX", "PAINTING", "MODELING", "MUSICIAN", "FASHION DESIGN", "DIGITAL ARTIST", "SCULPTING", "MAKE UP", "PHOTOGRAPHY", "INTERIOR DECOR"]

    var breedsList:[Breeds.ViewModel] = []
    var user: User.ViewModel!
    var onboarding: Bool = false
    var selectedCellIndex: Int = 0
    
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
    
  // MARK: Class Instance
  class func instance() -> BreedsViewController? {
      return StoryBoard.Breeds.board.instantiateViewController(withIdentifier: AppClass.BreedsVC.rawValue) as? BreedsViewController
  }
    
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = BreedsInteractor()
    let presenter = BreedsPresenter()
    let router = BreedsRouter()
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
    setUpLayout()
    breedCollectionView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
        /// start refresh
        self!.getBreeds()
        DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: {
            /// Stop refresh when your job finished, it will reset refresh footer if completion is true
            self?.breedCollectionView.cr.endHeaderRefresh()
        })
    }
    /// manual refresh
    breedCollectionView.cr.beginHeaderRefresh()
    
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
    
    func setUpLayout() {
        self.navigationController?.navigationBar.isHidden = false
        self.title = "Select Breed"
        if(onboarding) {
            nextButton.isHidden = false
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            //self.navigationItem.rightBarButtonItem?.title = "Skip"
        } else {
            breedCollectionView.frame = CGRect(x: breedCollectionView.frame.origin.x, y: breedCollectionView.frame.origin.y, width: breedCollectionView.frame.width, height: self.view.frame.height - breedCollectionView.frame.origin.y)
        }
    }

  
  func getBreeds()
  {
        interactor?.getBreeds()
  }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension BreedsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breedsList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: BreedsViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedsViewCell", for: indexPath) as? BreedsViewCell
    if cell == nil {
        collectionView.register(UINib(nibName: "BreedsViewCell", bundle: nil), forCellWithReuseIdentifier: "BreedsViewCell")
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BreedsViewCell", for: indexPath) as? BreedsViewCell
    }
        // Configure the cell
        cell.setCellData(breed: breedsList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.breedCollectionView.frame.width / 2) - 15), height: ((self.breedCollectionView.frame.width / 2) - 25))
    }
}

extension BreedsViewController: BreedsViewCellProtocol {
    func breedSelected(breed: Breeds.ViewModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let vc: PetProfileViewController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2])! as! PetProfileViewController as PetProfileViewController
            vc.breed = breed.breedName!
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension BreedsViewController: BreedsDisplayLogic {
    func didReceiveGetBreedsResponse(response: [Breeds.ViewModel]?, message: String, successCode: String) {
        self.breedCollectionView.cr.endHeaderRefresh()
        if successCode == "1" {
            print(message)
            if let data = response {
                breedsList.removeAll()
                self.breedsList.append(contentsOf: data)
                breedCollectionView.reloadData()
            }
        } else {
            //self.showTopMessage(message: message, type: .Error)
            breedsList.removeAll()
            breedCollectionView.reloadData()
        }
    }
}
