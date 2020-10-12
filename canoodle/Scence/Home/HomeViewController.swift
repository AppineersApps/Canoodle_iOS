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
    func displaySomething(viewModel: Home.Something.ViewModel)
}

/// This class is used to display home screen of the app.
class HomeViewController: BaseViewControllerWithAd {
    /// Interactor for API Call
    var interactor: HomeBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
    
    @IBOutlet weak var viewAd: UIView!
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
        self.navigationItem.title = "Canoodle"
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-homescreen", analyticsParameterItemName: "view_homescreen", analyticsParameterContentType: "view_homescreen")
        //addForceCrashButton()
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
    
    
    @IBAction func Settingsbtn(_ sender: Any) {
        
        if let settingsVC = SettingViewController.instance() {
            let vc = NavController.init(rootViewController: settingsVC)
            AppConstants.appDelegate.window?.rootViewController = vc
        }
        
    }
    
    @IBAction func btnSettings(_ sender: UIButton) {
        
//     let settingViewController = SettingViewController(nibName: "SettingViewController", bundle: nil)
//      self.navigationController?.pushViewController(settingViewController, animated: true)
        
        if let settingsVC = SettingViewController.instance() {
            let vc = NavController.init(rootViewController: settingsVC)
            AppConstants.appDelegate.window?.rootViewController = vc
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

    }
    
    // MARK: Class Instance
    class func instance() -> HomeViewController? {
        return StoryBoard.Home.board.instantiateViewController(withIdentifier: AppClass.HomeVC.rawValue) as? HomeViewController
    }
}

extension HomeViewController: HomeDisplayLogic {
    /// Call API To Display Something
    ///
    /// - Parameter viewModel: Request
    func displaySomething(viewModel: Home.Something.ViewModel) {
        print("")
    }

}
