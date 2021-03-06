//
//  UserProfileViewController.swift
//  canoodle
//
//  Created by Appineers India on 15/10/20.
//  Copyright (c) 2020 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import ImageSlideshow

protocol UserProfileDisplayLogic: class
{
    func didReceiveGetUserProfileResponse(response: [User.ViewModel]?, message: String, successCode: String)
    func didReceiveSetConnectionResponse(message: String, successCode: String)
    func didReceiveReportUserResponse(message: String, successCode: String)
    func didReceiveBlockUserResponse(message: String, successCode: String)
}

class UserProfileViewController: BaseViewControllerWithAd
{
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var petAboutTextView: UITextView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var akcLabel: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutPetView: UIView!
    @IBOutlet weak var status1Button: UIButton!
    @IBOutlet weak var status2Button: UIButton!


  var interactor: UserProfileBusinessLogic?
  var router: (NSObjectProtocol & UserProfileRoutingLogic & UserProfileDataPassing)?

    var userId: String = ""
    var user: User.ViewModel!
    var medias: [Media.ViewModel] = []

    var localSource: [KingfisherSource] = []
    
    var connStatus: String!
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
    let interactor = UserProfileInteractor()
    let presenter = UserProfilePresenter()
    let router = UserProfileRouter()
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
    class func instance() -> UserProfileViewController? {
        return StoryBoard.UserProfile.board.instantiateViewController(withIdentifier: AppClass.UserProfileVC.rawValue) as? UserProfileViewController
    }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.title = "User Profile"
    profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    profileImageView.layer.borderColor = AppConstants.appColor2!.cgColor
    profileImageView.layer.borderWidth = 2.0
    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 1200)
  }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-userprofilescreen", analyticsParameterItemName: "view_userprofilescreen", analyticsParameterContentType: "view_userprofilescreen")
        if(viewAd.isHidden) {
            detailView.frame = CGRect(x: detailView.frame.origin.x, y: self.viewAd.frame.origin.y, width: detailView.frame.width, height: self.view.frame.height - viewAd.frame.height)
        }
    }
    
    /// Method is called when view did appear
   override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       self.setAddMobView(viewAdd: self.viewAd)
        getUserProfile()
   }
    
    func setUserData() {
        nameLabel.text = user.userName
        locationLabel.text = "\(user.city!), \(user.state!)"
        if(user.description == "") {
            aboutTextView.text = "NA"
        } else {
            aboutTextView.text = user.description
        }
        profileImageView.setImage(with: "\(user.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
        if(user.connectionStatus != "Like" && user.connectionStatus != "Match" && user.connectionStatus != "Unlike") {
            statusView.isHidden = false
        } else {
            statusView.isHidden = true
        }
        
        if(user.connectionStatus == "Like" && user.reverseConnectionStatus == "Like") {
            status2Button.setImage(UIImage.init(named: "Chat"), for: UIControl.State.normal)
            status1Button.isHidden = true
            statusView.isHidden = false
        }
        
        
        petNameLabel.text = user.petName
        if(user.petAge != "") {
            petAgeLabel.text = "\(user.petAge!) years"
        }
        breedLabel.text = user.breed
        if(user.petDescription == "") {
            petAboutTextView.text = "NA"
        } else {
            petAboutTextView.text = user.petDescription
        }
        akcLabel.text = user.akcRegistered

        adjustUITextViewHeight(arg: aboutTextView)
        adjustUITextViewHeight(arg: petAboutTextView)
        aboutPetView.frame = CGRect(x: aboutPetView.frame.origin.x, y: aboutTextView.frame.origin.y + aboutTextView.frame.height + 30, width: aboutPetView.frame.width, height: petAboutTextView.frame.height + 200)
        setUpSlideshow()
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        //arg.translatesAutoresizingMaskIntoConstraints = true
       // arg.sizeToFit()
        let fixedWidth = arg.frame.size.width
        let newSize = arg.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        arg.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        arg.isScrollEnabled = false
    }
    
    func setUpSlideshow() {
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .customBottom(padding: 0))
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.pageIndicator = pageControl

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        localSource.removeAll()
        filterMedia()
        medias.forEach { media in
            localSource.append(KingfisherSource(urlString: media.mediaImages!)!)
        }
        slideshow.setImageInputs(localSource)

        if((medias.count) > 0) {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            slideshow.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
       fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @IBAction func btnImagedetailsAction(_ sender: Any) {
            if let customPopUp = ImageDetailsViewController.instance() {
                customPopUp.imgStr = self.user.userImage ?? ""
                self.present(customPopUp, animated: true, completion: nil)
            }
    }
    
    func filterMedia() {
        medias.removeAll()
        self.user.media?.forEach() { media in
            if(media.mediaType == "image/png") {
                medias.append(media)
            }
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: Any) {
       let optionMenu = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
       let blockAction = UIAlertAction(title: "Block User", style: .default) { handler in
        self.addAnayltics(analyticsParameterItemID: "id-blockprofile", analyticsParameterItemName: "click_blockprofile", analyticsParameterContentType: "click_blockprofile")
          self.blockUser()
       }

       let reportAction = UIAlertAction(title: "Report User", style: .destructive) { handler in
        self.addAnayltics(analyticsParameterItemID: "id-reportuser", analyticsParameterItemName: "click_reportuser", analyticsParameterContentType: "click_reportuser")
           self.reportUserProfile()
       }
       let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        if(user.connectionStatus == "Like" && user.reverseConnectionStatus == "Like") {
            optionMenu.addAction(blockAction)
        }
       optionMenu.addAction(reportAction)
       optionMenu.addAction(cancelAction)
           
       GlobalUtility.shared.currentTopViewController().present(optionMenu, animated: true, completion: nil)
   }
    
    func reportUserProfile() {
        let optionMenu = UIAlertController(title: "Please select reason for reporting", message: nil, preferredStyle: .alert)

        let viewAllAction = UIAlertAction(title: "Abusive User", style: .default) { _ in
            self.addAnayltics(analyticsParameterItemID: "id-reportuser", analyticsParameterItemName: "Report User", analyticsParameterContentType: "app_event")

            self.reportUser(otherUserId: self.userId, message: "Abusive User")
        }
        let type1Action = UIAlertAction(title: "Spam User", style: .default) { _ in
            self.addAnayltics(analyticsParameterItemID: "id-reportuser", analyticsParameterItemName: "Report User", analyticsParameterContentType: "app_event")
            self.reportUser(otherUserId: self.userId, message: "Spam User")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        optionMenu.addAction(viewAllAction)
        optionMenu.addAction(type1Action)
        optionMenu.addAction(cancelAction)
            
        AppConstants.appDelegate.window?.rootViewController!.present(optionMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        GlobalUtility.addClickEvent()
        self.addAnayltics(analyticsParameterItemID: "id-likeprofile", analyticsParameterItemName: "click_likeprofile", analyticsParameterContentType: "click_likeprofile")
        setConnection(userId: user.userId!, type: "Like")
    }
    
    @IBAction func unlikeButtonTapped(_ sender: Any) {
        if(user.connectionStatus == "Like" && user.reverseConnectionStatus == "Like") {
            if let chatVC = ChatViewController.instance() {
                let connection = Connection.ViewModel.init(dictionary: ["user_id": self.user.userId, "user_name": self.user.userName, "user_image": self.user.userImage])
                chatVC.setConnection(connection: connection!)
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        } else {
            self.addAnayltics(analyticsParameterItemID: "id-unlikeprofile", analyticsParameterItemName: "click_unlikeprofile", analyticsParameterContentType: "click_unlikeprofile")
            setConnection(userId: user.userId!, type: "Unlike")
            self.navigationController?.popViewController(animated: false)
        }
    }
  
  // MARK: Do something
    
    func setUserId(userId: String) {
        self.userId = userId
    }
    
    func getUserProfile() {
        let request = UserProfile.Request(otherUserId: self.userId)
        interactor?.getUserProfile(request: request)
    }
    
    func setConnection(userId: String, type: String) {
        connStatus = type
        let request = SetConnection.Request(connectionUserId: userId, connectionType: type)
        interactor?.setConnection(request: request)
    }
    
    func reportUser(otherUserId: String, message: String) {
        GlobalUtility.addClickEvent()
        self.addAnayltics(analyticsParameterItemID: "id-reportuserclick", analyticsParameterItemName: "click_reportuser", analyticsParameterContentType: "click_reportuser")
        let request = ReportUser.Request(reportOn: otherUserId, message: message)
        interactor?.reportUser(request: request)
    }
    
    func blockUser() {
        GlobalUtility.addClickEvent()
        self.addAnayltics(analyticsParameterItemID: "id-blockuserclick", analyticsParameterItemName: "click_blockuser", analyticsParameterContentType: "click_blockuser")
        let request = BlockUser.Request(connectionUserId: self.userId, connectionType: "Block")
        interactor?.blockUser(request: request)
    }
}

extension UserProfileViewController: UserProfileDisplayLogic {
    /// Call API To Display Something
    ///
    /// - Parameter viewModel: Request
    func didReceiveGetUserProfileResponse(response: [User.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            print(message)
            if let data = response {
                //usersList.removeAll()
                //self.usersList.append(contentsOf: data)
                user = data.first
                setUserData()
            }
        } else {
            //self.showTopMessage(message: message, type: .Error)
            //usersList.removeAll()
        }
    }
    
    func didReceiveSetConnectionResponse(message: String, successCode: String) {
        if successCode == "1" {
           // self.showTopMessage(message: message, type: .Success)
           /* if(connStatus == "Unlike") {
                self.navigationController?.popViewController(animated: false)
            } else if(connStatus == "Like" && user.reverseConnectionStatus == "Like"){
                if let canoodleVC = CanoodleViewController.instance() {
                    self.navigationController?.pushViewController(canoodleVC, animated: true)
                }
            } else {
                if let likeVC = LikeViewController.instance() {
                    self.navigationController?.pushViewController(likeVC, animated: true)
                }
            }*/
            getUserProfile()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveReportUserResponse(message: String, successCode: String) {
        if successCode == "1" {
            self.showTopMessage(message: "User reported successfully", type: .Success)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveBlockUserResponse(message: String, successCode: String) {
        if successCode == "1" {
            self.showTopMessage(message: "Blocked user successfully", type: .Success)
            if let blockedUserVC = BlockedUserViewController.instance() {
                self.navigationController?.pushViewController(blockedUserVC, animated: true)
            }
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}

extension UserProfileViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        //print("current page:", page)
    }
}
