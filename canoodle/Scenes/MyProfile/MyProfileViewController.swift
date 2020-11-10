//
//  MyProfileViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit
//import InitialsImageView
import ImageSlideshow


/// Protocol for presenting response
protocol MyProfileDisplayLogic: class {
    func didReceiveGetUserProfileResponse(response: [User.ViewModel]?, message: String, successCode: String) 
}

/// This class is used to display logged in user's profile view.
class MyProfileViewController: BaseViewControllerWithAd {
    
    // MARK: IBOutlet
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
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var aboutPetView: UIView!

    
    @IBOutlet weak var viewAd: UIView!
    /// Interactor for API Call
    var interactor: MyProfileBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & MyProfileRoutingLogic & MyProfileDataPassing)?
    
    var signUpField : SignUpConfig.SignUptextField!
    var textFieldArray = [UITextField]()
    var textFieldVisibleStatus = [Bool]()
    var textFieldOptionalStatus = [Bool]()
    
    var user: User.ViewModel!
    var medias: [Media.ViewModel] = []

    var localSource: [KingfisherSource] = []

    
    // MARK: Object lifecycle
    
     /// Override method to initialize with nib
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name
    ///   - nibBundleOrNil: Bundle in which nib is present
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
   /// Decoder
    ///
    /// - Parameter aDecoder: Decoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = MyProfileInteractor()
        let presenter = MyProfilePresenter()
        let router = MyProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    

    
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 850)
    }

    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-myprofilescreen", analyticsParameterItemName: "view_myprofilescreen", analyticsParameterContentType: "view_myprofilescreen")
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
    
    // MARK: Class Methods
    // SetUpLayout initial
    func setUpLayout() {
        self.title = AlertMessage.myProfileTitle
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderColor = AppConstants.appColor2!.cgColor
        profileImageView.layer.borderWidth = 2.0
    }
    
    //Set user login details
    
    func setUserData() {
        nameLabel.text = user.userName
        locationLabel.text = "\(user.city!), \(user.state!)"
        if(user.description == "") {
            aboutTextView.text = "NA"
        } else {
            aboutTextView.text = user.description
        }
        profileImageView.setImage(with: "\(user.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
        if(user.petName != "") {
            petNameLabel.text = user.petName
        }
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
        aboutPetView.frame = CGRect(x: aboutPetView.frame.origin.x, y: aboutTextView.frame.origin.y + aboutTextView.frame.height + 30, width: aboutPetView.frame.width, height: aboutTextView.frame.height + 50)
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

       /* if((item?.imageUrls.count)! > 0) {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(ItemListTableViewCell.didTap))
            slideshow.addGestureRecognizer(recognizer)
        }*/
    }
    
    func filterMedia() {
        medias.removeAll()
        self.user.media?.forEach() { media in
            if(media.mediaType == "image/png") {
                medias.append(media)
            }
            
        }
    }
    
    /// Open user profile in full screen
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnImagedetailsAction(_ sender: Any) {
        let logindata = UserDefaultsManager.getLoggedUserDetails()
        if logindata?.userProfile != "" {
            if let customPopUp = ImageDetailsViewController.instance() {
                let logindata = UserDefaultsManager.getLoggedUserDetails()
                customPopUp.imgStr = logindata?.userProfile ?? ""
                self.present(customPopUp, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnNotificationsAction(_ sender: Any) {
        if let notificationVC = NotificationsViewController.instance() {
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    @IBAction func btnEditAboutAction(_ sender: UIButton) {
        if let aboutMeVC = AboutMeViewController.instance() {
            aboutMeVC.onboarding = false
            aboutMeVC.aboutDescription = aboutTextView.text
            self.navigationController?.pushViewController(aboutMeVC, animated: true)
        }
    }
    
    @IBAction func btnEditPetProfileAction(_ sender: UIButton) {
        if let petProfileVC = PetProfileViewController.instance() {
            petProfileVC.setUser(user: self.user)
            self.navigationController?.pushViewController(petProfileVC, animated: true)
        }
    }
    
    @IBAction func blockedButtonTapped(_ sender: Any) {
       if let blockedUserVC = BlockedUserViewController.instance() {
           self.navigationController?.pushViewController(blockedUserVC, animated: true)
       }
   }
    
    @IBAction func btnEditProfileAction(_ sender: UIBarButtonItem) {
        if let editProfileVC = EditProfileViewController.instance() {
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    func getUserProfile() {
        let logindata = UserDefaultsManager.getLoggedUserDetails()
        let request = UserProfile.Request(otherUserId: (logindata?.userId!)!)
        interactor?.getUserProfile(request: request)
    }
}

/// Protocol for presenting response
extension MyProfileViewController: MyProfileDisplayLogic {
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
}

extension MyProfileViewController: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        //print("current page:", page)
    }
}
