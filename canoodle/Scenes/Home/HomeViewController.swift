//
//  HomeViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.

import UIKit
import FBSDKLoginKit
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

    
    var homeCardViews: [HomeCardView] = []
    
    var usersList = [User.ViewModel]()

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
        getUsers()
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
            self.showSimpleAlert(message: "No users to show")
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
                /* UIView.animate(withDuration: 0.3,
                           delay: 0.0,
                           options: [.curveEaseInOut, .allowUserInteraction],
                           animations: {
                            homeCardView.frame = CGRect(x: 16, y: 0, width: self.cardHolderView.frame.size.width - 32, height: self.cardHolderView.frame.size.height)
            },
                           completion: { finished in
                            homeCardView.initCard(user: self.usersList[n])
                            homeCardView.delegate = self
            })*/
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
        setUpHomeCardViews()
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
    
    @IBAction func btnSettingsAction(_ sender: Any) {
        if let settingsVC = SettingViewController.instance() {
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
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
        let request = User.Request(gender: filter.gender!)
        interactor?.getUsers(request: request)
    }
    
    func setConnection(userId: String, type: String) {
        let request = SetConnection.Request(connectionUserId: userId, connectionType: type)
        interactor?.setConnection(request: request)
    }
}


extension HomeViewController: HomeCardViewProtocol {
    func swipedCard(user: User.ViewModel, type: SwipeType) {
        if(type == SwipeType.Right) {
           //showCollabView()
            self.addAnayltics(analyticsParameterItemID: "id-likeprofile", analyticsParameterItemName: "click_likeprofile", analyticsParameterContentType: "click_likeprofile")
            setConnection(userId: user.userId!, type: "Like")
        } else {
            self.addAnayltics(analyticsParameterItemID: "id-unlikeprofile", analyticsParameterItemName: "click_unlikeprofile", analyticsParameterContentType: "click_unlikeprofile")
           // setConnection(userId: user.userId!, type: "Unlike")
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
            self.showTopMessage(message: message, type: .Success)
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}
