//
//  CanoodleViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for presenting response
protocol CanoodleDisplayLogic: class {
    func didReceiveGetConnectionsResponse(response: [Connection.ViewModel]?, message: String, successCode: String) 
}

/// This class is used for showing list of Canoodle of logged in user.
class CanoodleViewController: BaseViewControllerWithAd {
    /// Interactor for API Call
    var interactor: CanoodleBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & CanoodleRoutingLogic & CanoodleDataPassing)?
    
    @IBOutlet weak var viewAd: UIView!
    @IBOutlet weak var connectionsTableView: UITableView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var watermarkView: UIView!

    
    var connectionsList = [Connection.ViewModel]()

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
    
    // MARK: Class Instance
    class func instance() -> CanoodleViewController? {
        return StoryBoard.Canoodle.board.instantiateViewController(withIdentifier: AppClass.CanoodleVC.rawValue) as? CanoodleViewController
    }
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = CanoodleInteractor()
        let presenter = CanoodlePresenter()
        let router = CanoodleRouter()
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
        self.addAnayltics(analyticsParameterItemID: "id-canoodlescreen", analyticsParameterItemName: "view_canoodlescreen", analyticsParameterContentType: "view_canoodlescreen")
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setAddMobView(viewAdd: self.viewAd)
        getConnections()
    }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false)
        if(viewAd.isHidden) {
            detailView.frame = CGRect(x: detailView.frame.origin.x, y: self.viewAd.frame.origin.y, width: detailView.frame.width, height: self.view.frame.height - viewAd.frame.height)
        }
    }
    
    @IBAction func ShowAddAction(_ sender: UIBarButtonItem) {
        if !(UserDefaultsManager.getLoggedUserDetails()?.purchaseStatus?.booleanStatus() ?? false) {
            WhiteLabelSessionHandler.shared.addCount += 1
        }
    }
    
    @IBAction func btnNotificationsAction(_ sender: Any) {
        if let notificationVC = NotificationsViewController.instance() {
            self.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    @IBAction func btnSettingsAction(_ sender: Any) {
        if let settingsVC = SettingViewController.instance() {
            self.navigationController?.pushViewController(settingsVC, animated: true)
        }
    }
    

    
    func getConnections() {
        let request = Connection.Request(connectionType: "Match")
        interactor?.getConnections(request: request)
    }
}

// UITableView Delegate methods
extension CanoodleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(connectionsList.count == 0) {
            watermarkView.isHidden = false
            connectionsTableView.isHidden = true
        } else {
            watermarkView.isHidden = true
            connectionsTableView.isHidden = false
        }
        return connectionsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CanoodleViewCell! = tableView.dequeueReusableCell(withIdentifier: "CanoodleViewCell") as? CanoodleViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "CanoodleViewCell", bundle: nil), forCellReuseIdentifier: "CanoodleViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CanoodleViewCell") as? CanoodleViewCell
        }
        cell.delegate = self
        cell.setCellData(connection: connectionsList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userProfileVC = UserProfileViewController.instance() {
            let user: Connection.ViewModel = connectionsList[indexPath.row]
            userProfileVC.setUserId(userId: user.userId!)
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
    }

}

extension CanoodleViewController: CanoodleViewCellProtocol {
    func messageUser(user: Connection.ViewModel) {
        if let chatVC = ChatViewController.instance() {
            chatVC.setConnection(connection: user)
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func showProfileImage(user: Connection.ViewModel) {
        if let customPopUp = ImageDetailsViewController.instance() {
            customPopUp.imgStr = user.userImage ?? ""
            self.present(customPopUp, animated: true, completion: nil)
        }
    }
}


extension CanoodleViewController: CanoodleDisplayLogic {
    func didReceiveGetConnectionsResponse(response: [Connection.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            print(message)
            if let data = response {
                connectionsList.removeAll()
                self.connectionsList.append(contentsOf: data)
                connectionsTableView.reloadData()
            }
        } else {
            if(successCode != "0") {
                self.showTopMessage(message: message, type: .Error)
            }
            connectionsList.removeAll()
            connectionsTableView.reloadData()
        }
    }
}
