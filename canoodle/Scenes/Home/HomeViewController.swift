//
//  HomeViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.

import UIKit
import FBSDKLoginKit
#if canImport(TALogger)
import TALogger
#endif
import Lottie


/// Protocol for presenting response
protocol HomeDisplayLogic: class {
    /// Call API To Display Something
    ///
    /// - Parameter viewModel: Request
    func didReceiveGetUsersResponse(response: [User.ViewModel]?, message: String, successCode: String)
    func didReceiveSetConnectionResponse(message: String, successCode: String)
}

/// This class is used to display home screen of the app.
class HomeViewController: BaseViewControllerWithAd {
    /// Interactor for API Call
    var interactor: HomeBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var cardHolderView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var subscribeView: UIView!
    @IBOutlet weak var noUsersView: UIView!
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var overlayLabel1: UILabel!
    @IBOutlet weak var overlayLabel2: UILabel!
    @IBOutlet weak var overlayLabel3: UILabel!
    @IBOutlet weak var overlayButton: UIButton!
    
    var homeCardViews: [HomeCardView] = []
    
    var usersList = [User.ViewModel]()
    var currOverlayIndex: Int = 0
    var currPageIndex:Int = 0
    var onboarding: Bool = false

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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
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
        self.navigationItem.title = "Home"
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-homescreen", analyticsParameterItemName: "view_homescreen", analyticsParameterContentType: "view_homescreen")
        //addForceCrashButton()
    }
    
    func setUpSwipeAnimation() {
        switch currOverlayIndex {
        case 0:
            overlayLabel1.isHidden = false
            overlayButton.setTitle("NEXT", for: UIControl.State.normal)
            let swipeVerticalAnimationView : AnimationView = AnimationView(name: "VerticalSwipe")
            swipeVerticalAnimationView.contentMode = .scaleAspectFit
            swipeVerticalAnimationView.frame = CGRect(x: 50, y: 150, width: 100, height: 100)
            swipeVerticalAnimationView.loopMode = .loop
            swipeVerticalAnimationView.isHidden = false
            swipeVerticalAnimationView.tag = 100
            overlayView.addSubview(swipeVerticalAnimationView)
            swipeVerticalAnimationView.play { (played) in
                
            }

        case 1:
            overlayLabel2.isHidden = false
            overlayButton.setTitle("NEXT", for: UIControl.State.normal)
            let swipeHorizontalAnimationView : AnimationView = AnimationView(name: "HorizontalSwipe")
            swipeHorizontalAnimationView.contentMode = .scaleAspectFit
            swipeHorizontalAnimationView.frame = CGRect(x: overlayView.frame.width/2 - 60, y: 250, width: 120, height: 120)
            swipeHorizontalAnimationView.loopMode = .loop
            swipeHorizontalAnimationView.isHidden = false
            swipeHorizontalAnimationView.tag = 100
            overlayView.addSubview(swipeHorizontalAnimationView)
            swipeHorizontalAnimationView.play { (played) in
                
            }
        case 2:
            overlayLabel3.isHidden = false
            overlayButton.setTitle("GOT IT!", for: UIControl.State.normal)
            let scrollUpAnimationView : AnimationView = AnimationView(name: "ScrollUp")
            scrollUpAnimationView.contentMode = .scaleAspectFit
            scrollUpAnimationView.frame = CGRect(x: overlayView.frame.width/2 - 75, y: overlayView.frame.height - 300, width: 150, height: 150)
            scrollUpAnimationView.loopMode = .loop
            scrollUpAnimationView.isHidden = false
            scrollUpAnimationView.tag = 100
            //overlayView.addSubview(scrollUpAnimationView)
            scrollUpAnimationView.play { (played) in
                
            }
        default:
            print("")
        }

       // timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(shakeAnimation)), userInfo: nil, repeats: true)
    }
    
    func showOverlayView() {
        overlayView.subviews.forEach({
            if($0.tag == 100) {
                $0.removeFromSuperview()
            }
        })
        overlayLabel1.isHidden = true
        overlayLabel2.isHidden = true
        overlayLabel3.isHidden = true
        overlayView.removeFromSuperview()
        setUpSwipeAnimation()
        overlayView.frame = CGRect(x: 0, y: -20, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(overlayView)
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        if(currOverlayIndex < 2) {
            currOverlayIndex+=1
            showOverlayView()
        } else {
            TabbarController.onboarding = false
            overlayView.removeFromSuperview()
        }
    }
    
    func setUpHomeCardViews() {
        homeCardViews.removeAll()
        cardHolderView.subviews.forEach({
            if($0.tag == 100) {
                $0.removeFromSuperview()
            }
        })

        GlobalUtility.showHud()
        print("initialising home cards")
        if(usersList.count == 0) {
            GlobalUtility.hideHud()
            //self.showSimpleAlert(message: "No users to show")
            noUsersView.isHidden = false
            return
        }
        for n in 0...usersList.count - 1 {
            let homeCardView:HomeCardView = (UIView.viewFromNibName("HomeCardView") as? HomeCardView)!
            homeCardView.frame = CGRect(x: 0, y: cardHolderView.frame.size.height, width: cardHolderView.frame.size.width, height: cardHolderView.frame.size.height)
            homeCardView.setCornerRadiusAndShadow(cornerRe: 24)
            homeCardView.tag = 100
            cardHolderView.addSubview(homeCardView)
            homeCardView.frame = CGRect(x: 0, y: 5, width: homeCardView.frame.size.width, height: self.detailView.frame.size.height - 60)
            homeCardView.initCard(index: n, user: usersList[n])
            homeCardView.delegate = self
            homeCardViews.append(homeCardView)
        }
        let secondsToDelay = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
           print("This message is delayed")
           // Put any code you want to be delayed here
            GlobalUtility.hideHud()
        }

    }
    
    func addForceCrashButton() {
         let button = UIButton(type: .roundedRect)
         button.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
         button.setTitle("Force Crash", for: [])
         button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
         view.addSubview(button)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        fatalError()
    }
    
    @IBAction func reloadButtonTapped(_ sender: AnyObject) {
        //getUsers()
        if let filterVC = HomeFilterViewController.instance() {
            self.navigationController?.pushViewController(filterVC, animated: true)
        }
    }
    
    @IBAction func btnFilterAction(_ sender: UIButton) {
        if let filterVC = HomeFilterViewController.instance() {
            self.navigationController?.pushViewController(filterVC, animated: true)
        }
    }
    
    @IBAction func btnNotificationsAction(_ sender: UIButton) {
        if let notificationVC = NotificationsViewController.instance() {
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    @IBAction func btnSettingsAction(_ sender: UIBarButtonItem) {
        if let settingsVC = SettingViewController.instance() {
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
        noUsersView.isHidden = true
        getUsers()
        if(TabbarController.onboarding == true) {
            showOverlayView()
        }
    }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        if(viewAd.isHidden) {
            detailView.frame = CGRect(x: detailView.frame.origin.x, y: self.viewAd.frame.origin.y, width: detailView.frame.width, height: self.view.frame.height - viewAd.frame.height)
        }
    }
    
    // MARK: Class Instance
    class func instance() -> HomeViewController? {
        return StoryBoard.Home.board.instantiateViewController(withIdentifier: AppClass.HomeVC.rawValue) as? HomeViewController
    }
    
    func getUsers() {
        let filter = UserDefaultsManager.getFilter()
        let request = User.Request(gender: filter.gender!, radius: filter.distance!)
        interactor?.getUsers(request: request)
    }
    
    func setConnection(userId: String, type: String) {
        let request = SetConnection.Request(connectionUserId: userId, connectionType: type)
        interactor?.setConnection(request: request)
    }
}


extension HomeViewController: HomeCardViewProtocol {
    func showProfile(user: User.ViewModel) {
        if let userProfileVC = UserProfileViewController.instance() {
            userProfileVC.userId = user.userId!
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
    }
    
    func swipedCard(user: User.ViewModel, type: SwipeType) {
        GlobalUtility.addClickEvent()

        if(type == SwipeType.Right) {
           //showCollabView()
            #if canImport(TALogger)
            TALogger.shared.LogEvent(type: "Swipe", function:(#function),file:GlobalUtility.classNameAsString(obj: self) , name: "Swipe Right", description: "Swipe Event")
            #endif
            self.addAnayltics(analyticsParameterItemID: "id-likeprofile", analyticsParameterItemName: "click_likeprofile", analyticsParameterContentType: "click_likeprofile")
            setConnection(userId: user.userId!, type: "Like")
        } else {
            #if canImport(TALogger)
            TALogger.shared.LogEvent(type: "Swipe", function:(#function),file:GlobalUtility.classNameAsString(obj: self) , name: "Swipe Left", description: "Swipe Event")
            #endif
            self.addAnayltics(analyticsParameterItemID: "id-unlikeprofile", analyticsParameterItemName: "click_unlikeprofile", analyticsParameterContentType: "click_unlikeprofile")
            setConnection(userId: user.userId!, type: "Unlike")
        }
        if(cardHolderView.subviews.count == 1) {
            getUsers()
        }
    }
    
    func showSubscribeView() {
        subscribeView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(subscribeView)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        subscribeView.removeFromSuperview()
    }
    
    @IBAction func subscribeButtonTapped(_ sender: UIButton) {
        subscribeView.removeFromSuperview()
        if let subscriptionVC = SubscriptionViewController.instance() {
            self.navigationController?.pushViewController(subscriptionVC, animated: true)
        }
    }
}

extension HomeViewController: HomeDisplayLogic {
    /// Call API To Display Something
    ///
    /// - Parameter viewModel: Request
    func didReceiveGetUsersResponse(response: [User.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            print(message)
            if let data = response {
                usersList.removeAll()
                self.usersList.append(contentsOf: data)
                setUpHomeCardViews()
            }
        } else {
            //self.showTopMessage(message: message, type: .Error)
            usersList.removeAll()
        }
    }
    
    func didReceiveSetConnectionResponse(message: String, successCode: String) {
        if successCode == "1" {
            //self.showTopMessage(message: "User liked successfully", type: .Success)
        } else {
            if(message.contains("exceeded")) {
                showSubscribeView()
            }
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
