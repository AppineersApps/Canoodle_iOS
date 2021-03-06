//
//  BlockedUserViewController.swift
//  Time2Beat
//
//  Created by Appineers India on 17/09/20.
//  Copyright (c) 2020 The Appineers. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BlockedUserDisplayLogic: class
{
   func didReceiveBlockedUsersResponse(response: [Connection.ViewModel]?, message: String, successCode: String)
    func didReceiveUnblockUserResponse(message: String, successCode: String)
}

class BlockedUserViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var watermarkView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!


  var interactor: BlockedUserBusinessLogic?
  var router: (NSObjectProtocol & BlockedUserRoutingLogic & BlockedUserDataPassing)?
    
    var blockedUserList = [Connection.ViewModel]()
    var filteredList = [Connection.ViewModel]()

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
    let interactor = BlockedUserInteractor()
    let presenter = BlockedUserPresenter()
    let router = BlockedUserRouter()
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
    class func instance() -> BlockedUserViewController? {
        return StoryBoard.BlockedUser.board.instantiateViewController(withIdentifier: AppClass.BlockedUserVC.rawValue) as? BlockedUserViewController
    }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.title = "Blocked Users"
    self.addAnayltics(analyticsParameterItemID: "id-blockeduserscreen", analyticsParameterItemName: "view_blockeduserscreen", analyticsParameterContentType: "view_blockeduserscreen")
    getBlockedUsers()
  }
  
  // MARK: Do something
  
  func getBlockedUsers() {
    let request = Connection.Request(connectionType: "Block")
    interactor?.getBlockedUsers(request: request)
  }
}

// UITableView Delegate methods
extension BlockedUserViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filteredList.count == 0) {
            tableView.isHidden = true
            watermarkView.isHidden = false
        } else {
            tableView.isHidden = false
            watermarkView.isHidden = true
        }
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BlockedUserViewCell! = tableView.dequeueReusableCell(withIdentifier: "BlockedUserViewCell") as? BlockedUserViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "BlockedUserViewCell", bundle: nil), forCellReuseIdentifier: "BlockedUserViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "BlockedUserViewCell") as? BlockedUserViewCell
        }
        cell.delegate = self
        cell.setCellData(data: filteredList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userProfileVC = UserProfileViewController.instance() {
            let user: Connection.ViewModel = blockedUserList[indexPath.row]
            userProfileVC.setUserId(userId: user.userId!)
            self.navigationController?.pushViewController(userProfileVC, animated: true)
        }
    }
}

extension BlockedUserViewController: BlockedUserViewCellProtocol {
    func unblockUser(otherUserId: String) {
        let request = BlockUser.Request(connectionUserId: otherUserId, connectionType: "Unblock")
        interactor?.unblockUser(request: request)
    }
}

extension BlockedUserViewController: BlockedUserDisplayLogic {
    func didReceiveBlockedUsersResponse(response: [Connection.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            print(message)
            if let data = response {
                blockedUserList.removeAll()
                self.blockedUserList.append(contentsOf: data)
                filteredList = blockedUserList
                tableView.reloadData()
            }
        } else {
            if(successCode != "0") {
                self.showTopMessage(message: message, type: .Error)
            }
            blockedUserList.removeAll()
            filteredList = blockedUserList
            tableView.reloadData()
        }
    }
    
    func didReceiveUnblockUserResponse(message: String, successCode: String) {
        if successCode == "1" {
            self.showTopMessage(message: "User unblocked successfully", type: .Success)
            getBlockedUsers()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}

// Search
extension BlockedUserViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //self.searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
       // self.searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text == "") {
            searchBar.resignFirstResponder()
            filteredList = blockedUserList
            tableView.reloadData()
        }
        else {
            filterSearchResults()
        }
        
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchBar.resignFirstResponder()
            }
        }
        
    }// called when text changes (including clear)
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n") {
            searchBar.resignFirstResponder()
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.placeholder = "Enter name"
        searchBar.resignFirstResponder()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func filterSearchResults() {
        var filteredArray:[Connection.ViewModel] = []
        blockedUserList.forEach {
            let user:Connection.ViewModel = $0
            let name:String = user.userName!
            let searchText:String = self.searchBar.text!
            if(name.lowercased().contains(searchText.lowercased())) {
                filteredArray.append(user)
            }
        }
        filteredList = filteredArray
        tableView.reloadData()
    }
}
