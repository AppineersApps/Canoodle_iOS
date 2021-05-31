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
    func didReceiveUploadMediaResponse(message: String, success: String)
    func didReceiveUpdatePetProfileResponse(message: String, success: String)
    func didReceiveDeleteMediaResponse(message: String, successCode: String)
}

class PetProfileViewController: BaseViewController
{
    @IBOutlet weak var clctnView: UICollectionView!
    @IBOutlet weak var petNameTextField: UITextField!
    @IBOutlet weak var petAgeTextField: UITextField!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var descTextView: CustomTextView!
    @IBOutlet weak var akcSwitch: UISwitch!
    @IBOutlet weak var lblDescriptionCharacterCount: UILabel!


  var interactor: PetProfileBusinessLogic?
  var router: (NSObjectProtocol & PetProfileRoutingLogic & PetProfileDataPassing)?
    
    /// Image Array to display images in scroll
    var user: User.ViewModel!
    var medias: [Media.ViewModel] = []
    var imageArray = [UIImage]() {
        didSet {
            clctnView.reloadData()
            self.scrollToBottom()
        }
    }
    var onboarding: Bool = false

    var breed: String = ""

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
    
    // MARK: Class Instance
    class func instance() -> PetProfileViewController? {
        return StoryBoard.PetProfile.board.instantiateViewController(withIdentifier: AppClass.PetProfileVC.rawValue) as? PetProfileViewController
    }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.title = "Add Pet Profile"
    descTextView.delegate = self
    self.addAnayltics(analyticsParameterItemID: "id-editpetprofilescreen", analyticsParameterItemName: "view_editpetprofilescreen", analyticsParameterContentType: "view_editpetprofilescreen")
    if(user != nil && user.petId != "") {
        breed = user.breed!
        setPetData()
    }
    if(onboarding) {
        self.navigationItem.leftBarButtonItem = nil
    }
  }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        petNameTextField.resignFirstResponder()
        petAgeTextField.resignFirstResponder()
        breedTextField.resignFirstResponder()
    }
    
    func setPetData() {
        self.title = "Edit Pet Profile"
        petNameTextField.text = user.petName
        petAgeTextField.text = user.petAge
        breedTextField.text = user.breed
        descTextView.text = user.petDescription
        self.lblDescriptionCharacterCount.text = "(\(descTextView.text.count)/500)"
        if(user.akcRegistered == "yes") {
            akcSwitch.isOn = true
        } else {
            akcSwitch.isOn = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        breedTextField.text = breed
    }
    
    /// Scroll colllecttionview to last index while add image
    func scrollToBottom() {
        DispatchQueue.main.async {
            if (self.imageArray.count + self.medias.count) == 5 {
                let indexPath = IndexPath(row: (self.imageArray.count + self.medias.count) - 1, section: 0)
                self.clctnView.scrollToItem(at: indexPath, at: .right, animated: false)
            } else {
                let indexPath = IndexPath(row: (self.imageArray.count + self.medias.count), section: 0)
                self.clctnView.scrollToItem(at: indexPath, at: .right, animated: false)
            }
        }
    }
    
    /// Open camera/gallery
    func addPhoto() {
        CustomImagePicker.shared.openImagePickerWith(mediaType: .MediaTypeImage, allowsEditing: true, actionSheetTitle: AppInfo.kAppName, message: "", cancelButtonTitle: "Cancel", cameraButtonTitle: "Camera", galleryButtonTitle: "Gallery") { (_, success, dict) in
            if success {
                if let img = (dict!["edited_image"] as? UIImage) {
                    self.imageArray.append(img)
                }
            }
        }
    }
    
    @IBAction func btnSaveAction(_ sender: Any) {
        updatePetProfile()
     }

     @IBAction func btnCancelAction(_ sender: Any) {
         self.displayAlert(msg: "Are you sure you want to Cancel? You will lose all changes", ok: "YES", cancel: "NO", okAction: {
             self.navigationController?.popViewController(animated: true)
         }, cancelAction: nil)
     }
  
  // MARK: Do something
  
    func setMedias(medias: [Media.ViewModel]) {
        self.medias = medias
    }
    
    func setUser(user: User.ViewModel) {
        self.user = user
        if(user.media != nil) {
            self.medias = user.media!
        }
        if(user.petId != "") {
            self.title = "Edit Pet Profile"
        }
    }
  
    func updatePetProfile()
    {
        var akc: String = "no"
        if(akcSwitch.isOn) {
            akc = "yes"
        }
        
        var petId: String = ""
        if(self.user != nil) {
            petId = self.user.petId!
        }
        
        if(petNameTextField.text == "") {
            self.showSimpleAlert(message: "Please enter Pet name")
            return
        }
        
        if(breedTextField.text == "") {
            self.showSimpleAlert(message: "Please select Breed")
            return
        }
        
        if(petId == "" && imageArray.count == 0) {
            self.showSimpleAlert(message: "Please add atleast one media")
            return
        }
        
        if(petId != "" && (imageArray.count == 0 && medias.count == 0)) {
            self.showSimpleAlert(message: "Please add atleast one media")
            return
        }
        
        if(descTextView.text.count < 150) {
            self.showSimpleAlert(message: "Please enter min 150 characters description for your pet")
            return
        }
        
        let request = UpdatePetProfile.Request(petId: petId, petName: petNameTextField.text!, breed: breedTextField.text!, petAge: petAgeTextField.text!, akcRegistered: akc, description: descTextView.text)
        interactor?.updatePetProfile(request: request)
    }
      
    
  func saveProfile()
  {
    if(imageArray.count == 0 && medias.count == 0) {
        if(onboarding) {
             UserDefaultsManager.profileSetUpDone = "Yes"
            if let aboutMeVC = AboutMeViewController.instance() {
                aboutMeVC.onboarding = true
                aboutMeVC.aboutDescription = ""
                self.navigationController?.pushViewController(aboutMeVC, animated: true)
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
        return
    }
    self.addAnayltics(analyticsParameterItemID: "id-imageupload", analyticsParameterItemName: "click_imageupload", analyticsParameterContentType: "click_imageupload")
    let request = UploadMedia.Request(imageArray: imageArray)
    interactor?.uploadMedia(request: request)
  }
    
    func deleteMedia(mediaId: String)
    {
        self.addAnayltics(analyticsParameterItemID: "id-imagedelete", analyticsParameterItemName: "click_imagedelete", analyticsParameterContentType: "click_imagedelete")
        let request = DeleteMedia.Request(media_id: mediaId)
        interactor?.deleteMedia(request: request)
    }
    
    @IBAction func breedButtonTapped(_ sender: Any) {
        petNameTextField.resignFirstResponder()
        petAgeTextField.resignFirstResponder()
        if let breedsVC = BreedsViewController.instance() {
            self.navigationController?.pushViewController(breedsVC, animated: true)
        }
    }
}

//UIcollectionview Methods
extension PetProfileViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    /// Method is called to get number of items to be displayed in collectionview
    ///
    /// - Parameters:
    ///   - collectionView: CollectionView
    ///   - section: Section
    /// - Returns: Return number of rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ((imageArray.count + medias.count) == 5) {
            return imageArray.count + medias.count
        } else {
            return imageArray.count + medias.count + 1
        }
    }
    
    /// Method is called to get cell for row at particular index
    ///
    /// - Parameters:
    ///   - collectionView: Collectionview
    ///   - indexPath: Indexpath
    /// - Returns: Return cell for indexpath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == (imageArray.count + medias.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImage", for: indexPath) as? SendFeedbackAddImageCollectionViewCell
            cell?.btnAddTappedClouser = {
                self.addPhoto()
            }
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as? SendFeedbackImageCollectionViewCell
            if(indexPath.row >= medias.count) {
                cell?.imgPicked.image = imageArray[indexPath.row - medias.count]
            } else {
                let media = medias[indexPath.row]
                cell?.imgPicked.setImage(with: media.mediaImages, placeHolder: UIImage.init(named: "placeholder"))
            }
            cell?.btnRemoveTappedClouser = {
                if(indexPath.row >= self.medias.count) {
                    self.imageArray.remove(at: (indexPath.row - self.medias.count))
                    self.clctnView.reloadData()
                } else {
                    self.displayAlert(msg: AlertMessage.deleteMessage, ok: "Yes", cancel: "No", okAction: {
                        let media = self.medias[indexPath.row]
                        self.deleteMedia(mediaId: media.mediaId!)
                        self.medias.remove(at: indexPath.row)
                        self.clctnView.reloadData()
                    }, cancelAction: nil)
                }
            }
            return cell!
        }
    }
}

//UITextfield Delegate
extension PetProfileViewController: UITextFieldDelegate {
    
    /// Method is called when textfield begins editing
    ///
    /// - Parameter textField: Textfield reference
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == breedTextField {
            textField.resignFirstResponder()
            petNameTextField.resignFirstResponder()
            petAgeTextField.resignFirstResponder()
            if let breedsVC = BreedsViewController.instance() {
                self.navigationController?.pushViewController(breedsVC, animated: true)
            }
        }
    }
}

extension PetProfileViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //self.lblDescriptionCharacterCount.isHidden = false
        if textView.text.count > 500 {
            var str = textView.text ?? ""
            str = String(str.prefix(500))
            self.descTextView.text = str
        }
    }
    
    /// Method is called when textview text changes
    ///
    /// - Parameter textView: TextView
    func textViewDidChange(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 16.0
        if textView.text.count > 500 {
            var str = textView.text ?? ""
            str = String(str.prefix(500))
            self.descTextView.text = str
        }
        self.lblDescriptionCharacterCount.text = "(\(textView.text.count)/500)"
    }
}

extension PetProfileViewController: PetProfileDisplayLogic {
    
    func didReceiveUploadMediaResponse(message: String, success: String) {
        if success == "1" {
            self.showTopMessage(message: "Pet Media added successfully", type: .Success)
            //self.navigationController?.popViewController(animated: true)
            if(onboarding) {
                 UserDefaultsManager.profileSetUpDone = "Yes"
                if let aboutMeVC = AboutMeViewController.instance() {
                    aboutMeVC.onboarding = true
                    aboutMeVC.aboutDescription = ""
                    self.navigationController?.pushViewController(aboutMeVC, animated: true)
                }
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveUpdatePetProfileResponse(message: String, success: String) {
        if success == "1" {
            self.showTopMessage(message: "Profile updated successfully", type: .Success)
            saveProfile()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveDeleteMediaResponse(message: String, successCode: String) {
        if successCode == "1" {
            self.showTopMessage(message: "Media deleted successfully", type: .Success)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
