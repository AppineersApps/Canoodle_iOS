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
    @IBOutlet var slideshow: ImageSlideshow!
    
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
    }

    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-myprofilescreen", analyticsParameterItemName: "view_myprofilescreen", analyticsParameterContentType: "view_myprofilescreen")
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
        aboutTextView.text = user.description
        profileImageView.setImage(with: "\(user.userImage!)", placeHolder: UIImage.init(named: "watermark"))
        setUpSlideshow()
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
