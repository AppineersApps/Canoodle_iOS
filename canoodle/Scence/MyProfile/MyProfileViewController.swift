//
//  MyProfileViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit
//import InitialsImageView

/// Protocol for presenting response
protocol MyProfileDisplayLogic: class {
    
}

/// This class is used to display logged in user's profile view.
class MyProfileViewController: BaseViewControllerWithAd {
    
    // MARK: IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var viewAd: UIView!
    /// Interactor for API Call
    var interactor: MyProfileBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & MyProfileRoutingLogic & MyProfileDataPassing)?
    
    var signUpField : SignUpConfig.SignUptextField!
    var textFieldArray = [UITextField]()
    var textFieldVisibleStatus = [Bool]()
    var textFieldOptionalStatus = [Bool]()
    
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
        self.setUserData()
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-myprofilescreen", analyticsParameterItemName: "view_myprofilescreen", analyticsParameterContentType: "view_myprofilescreen")
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
    }
    
    // MARK: Class Methods
    // SetUpLayout initial
    func setUpLayout() {
        self.title = AlertMessage.myProfileTitle
    }
    
    //Set user login details
    func setUserData() {
        let logindata = UserDefaultsManager.getLoggedUserDetails()
        self.imgProfile.setImage(with: logindata?.userProfile)
        self.lblFullName.text = (logindata?.firstName ?? "") + " " + (logindata?.lastName ?? "")
        self.imgProfile.setImage(with: logindata?.userProfile, placeHolder: #imageLiteral(resourceName: "signup_default_user"))
//        if logindata?.userProfile == "" {
//            self.imgProfile.setImageForName(self.lblFullName.text ?? "", gradientColors: (top: AppConstants.appColor!, bottom: AppConstants.appColor!), circular: true, textAttributes: nil)
//        }
        self.lblUserName.text = logindata?.userName
        if (logindata?.userName == "") || (logindata?.userName == nil) {
            self.lblUserName.isHidden = true
        } else {
            self.lblUserName.isHidden = false
        }
        
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)

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
}

/// Protocol for presenting response
extension MyProfileViewController : MyProfileDisplayLogic {
    
}
