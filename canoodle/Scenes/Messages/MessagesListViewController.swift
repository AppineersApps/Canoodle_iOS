//
//  MessagesViewController.swift
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
import CRRefresh
import Firebase
import MessageKit
import FirebaseFirestore


/// Protocol for presenting response
protocol MessagesDisplayLogic: class {
    func didReceiveGetMessagesResponse(response: [Message.ViewModel]?, message: String, successCode: String)
    func didReceiveDeleteMessageResponse(message: String, successCode: String)
}

/// This class is used for displaying all recent conversations happened between logged in user and other app users.
class MessagesListViewController: BaseViewControllerWithAd {
    
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var watermarkView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!


    /// Interactor for API Call
    var interactor: MessagesBusinessLogic?
    /// Router for navigation between the screens
    var router: (NSObjectProtocol & MessagesRoutingLogic & MessagesDataPassing)?
    
    var messagesList:[Message.ViewModel] = []
    var filteredList:[Message.ViewModel] = []
    
    var chatMessages: [ChatMessage] = []
    
    private var docReference: DocumentReference?
    var selectedRowIndex: Int = 0

    
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
    
    // MARK: Class Instance
    class func instance() -> MessagesListViewController? {
        return StoryBoard.Messages.board.instantiateViewController(withIdentifier: AppClass.MessagesVC.rawValue) as? MessagesListViewController
    }
    
    // MARK: Setup
    
    /// Set Up For API Calls 
    private func setup() {
        let viewController = self
        let interactor = MessagesInteractor()
        let presenter = MessagesPresenter()
        let router = MessagesRouter()
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
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(notification:)), name: NSNotification.Name("UserNotification"), object: nil)
        self.navigationItem.title = "Messages"
       // UserDefaultsManager.msgCount = 0
        NotificationCenter.default.post(name: NSNotification.Name("ChatNotification"), object: nil, userInfo: nil)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.premiumStatus?.booleanStatus() ?? false)
        self.addAnayltics(analyticsParameterItemID: "id-messagelistscreen", analyticsParameterItemName: "view_messagelistscreen", analyticsParameterContentType: "view_messagelistscreen")
    }
    
     /// Method is called when view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // UserDefaultsManager.msgCount = 0
        NotificationCenter.default.post(name: NSNotification.Name("ChatNotification"), object: nil, userInfo: nil)
        self.setAddMobView(viewAdd: self.viewAd)
       // updateNotificationBadge()
        messagesTableView.cr.addHeadRefresh(animator: FastAnimator()) { [weak self] in
            /// start refresh
            self!.getMessages()
            DispatchQueue.main.asyncAfter(deadline: .now() + 60, execute: {
                /// Stop refresh when your job finished, it will reset refresh footer if completion is true
                self?.messagesTableView.cr.endHeaderRefresh()
            })
        }
        /// manual refresh
        messagesTableView.cr.beginHeaderRefresh()
    }
    
    /// Method is called when view will appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewAd.isHidden = (UserDefaultsManager.getLoggedUserDetails()?.premiumStatus?.booleanStatus() ?? false)
        if(viewAd.isHidden) {
            detailView.frame = CGRect(x: detailView.frame.origin.x, y: self.viewAd.frame.origin.y, width: detailView.frame.width, height: self.view.frame.height - viewAd.frame.height)
        }
    }
    
    /*@objc func notificationReceived(notification: Notification.ViewModel) {
       // updateNotificationBadge()
    }*/
    
    @objc func loadChat(user2UID: String, index: Int) {
        let userData = UserDefaultsManager.getLoggedUserDetails()
        let user1UID = userData?.userId as! String
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: user1UID ?? "Not Found User 1")
        
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    //self.createNewChat()
                    print("no chats created")
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat1(dictionary: doc.data())
                        print("chat thread: \(doc.documentID)")

                        //Get the chat which has user2 id
                        if (chat?.users.contains(user2UID))! {
                            
                            self.docReference = doc.reference
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.chatMessages.removeAll()
                                    for message in threadQuery!.documents {

                                        let msg = ChatMessage(dictionary: message.data())
                                        self.chatMessages.append(msg!)
                                        print("Data: \(msg!.content ?? "No message found")")
                                    }
                                var count: Int = 0
                                self.chatMessages.forEach { chatMessage in
                                    if(chatMessage.senderID == user2UID && !chatMessage.readStatus) {
                                        count += 1
                                    }
                                }
                                let cell: MessagesViewCell = self.messagesTableView.cellForRow(at: IndexPath.init(row: index, section: 0))! as! MessagesViewCell
                                cell.setCellData(message: self.messagesList[index], unread: count)
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    func getMessages() {
        interactor?.getMessages()
    }
    
    func deleteMessage(messageId: String)
    {
        let request = DeleteMessage.Request(message_id: messageId)
        interactor?.deleteMessage(request: request)
    }
    
    func getUnreadMessagesCount(index: Int) -> Int {
        var count: Int = 0
        let message: Message.ViewModel = messagesList[index]
        let loginData = UserDefaultsManager.getLoggedUserDetails()
        if(loginData?.userId == message.receiverId!) {
            loadChat(user2UID: message.senderId!, index: index)

        } else {
            loadChat(user2UID: message.receiverId!, index: index)
        }

        return count
    }
    
    /*func getFirebaseId(user2Id: String) -> String {
        let userData = UserDefaultsManager.getLoggedUserDetails()
        let user1UID = userData?.userId as! String
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: user1UID ?? "Not Found User 1")
        
        var firebaseId:String  = ""
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    //If documents count is zero that means there is no chat available and we need to create a new instance
                    //self.createNewChat()
                    print("no chats created")
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat1(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(user2Id))! {
                            firebaseId = doc.documentID
                            print("chat thread: \(doc.documentID)")
                            self.docReference = doc.reference
                            self.deleteThread(threadId: doc.documentID)
                            
                            return
                        } //end of if
                    } //end of for
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
        return firebaseId
    }*/
    
    func deleteThread(threadId: String) {
        let userData = UserDefaultsManager.getLoggedUserDetails()
        let user1UID = userData?.userId as! String

        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: user1UID )
        Firestore.firestore().collection("Chats").document(threadId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func filterBlockedUsers() {
        var filteredArray:[Message.ViewModel] = []
        messagesList.forEach {
            let message:Message.ViewModel = $0
            if(message.connectionStatus == "Like") {
                filteredArray.append(message)
            }
        }
        messagesList = filteredArray
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
}

extension MessagesListViewController: MessagesDisplayLogic {
    
    func didReceiveGetMessagesResponse(response: [Message.ViewModel]?, message: String, successCode: String) {
        self.messagesTableView.cr.endHeaderRefresh()
        if successCode == "1" {
            print(message)
            if let data = response {
                messagesList.removeAll()
                self.messagesList.append(contentsOf: data)
                filterBlockedUsers()
                filteredList = messagesList
                messagesTableView.reloadData()
            }
        } else {
            if(successCode != "0") {
                self.showTopMessage(message: message, type: .Error)
            }
            messagesList.removeAll()
            filteredList = messagesList
            messagesTableView.reloadData()
        }
    }
    
    func didReceiveDeleteMessageResponse(message: String, successCode: String) {
        if successCode == "1" {
            self.showTopMessage(message: message, type: .Success)
            getMessages()
        } else {
            self.showTopMessage(message: message, type: .Error)
        }
    }
}

// UITableView Delegate methods
extension MessagesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(filteredList.count == 0) {
            watermarkView.isHidden = false
            messagesTableView.isHidden = true
        } else {
            watermarkView.isHidden = true
            messagesTableView.isHidden = false
        }
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: MessagesViewCell! = tableView.dequeueReusableCell(withIdentifier: "MessagesViewCell") as? MessagesViewCell
        
        if cell == nil {
            tableView.register(UINib(nibName: "MessagesViewCell", bundle: nil), forCellReuseIdentifier: "MessagesViewCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "MessagesViewCell") as? MessagesViewCell
        }
        //cell.delegate = self
        cell.setCellData(message: filteredList[indexPath.row], unread: getUnreadMessagesCount(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let loginData = UserDefaultsManager.getLoggedUserDetails()
        let message: Message.ViewModel = filteredList[indexPath.row]
        var connection: Connection.ViewModel!
        if let chatVC = ChatViewController.instance() {
            if(loginData?.userId == message.receiverId!) {
                connection = Connection.ViewModel.init(dictionary: ["user_id": message.senderId!, "user_name": message.senderName!, "user_image": message.senderImage!, "connection_status": message.connectionStatus!])

            } else {
                connection = Connection.ViewModel.init(dictionary: ["user_id": message.receiverId!, "user_name": message.receiverName!, "user_image": message.receiverImage!, "connection_status": message.connectionStatus!])
            }
            chatVC.setConnection(connection: connection!)
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let message: Message.ViewModel = filteredList[indexPath.row]
        if editingStyle == .delete {
            self.displayAlert(msg: "Are you sure you want to delete chat with this user?", ok: "Yes", cancel: "No", okAction: {
                self.selectedRowIndex = indexPath.row
                self.deleteMessage(messageId: message.messageId!)
            }, cancelAction: nil)
        }
    }
}

// Search
extension MessagesListViewController : UISearchBarDelegate {
    
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
            filteredList = messagesList
            messagesTableView.reloadData()
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
        var filteredArray:[Message.ViewModel] = []
        messagesList.forEach {
            let message:Message.ViewModel = $0
            let name:String = message.receiverName!
            let searchText:String = self.searchBar.text!
            if(name.lowercased().contains(searchText.lowercased())) {
                filteredArray.append(message)
            }
        }
        filteredList = filteredArray
        messagesTableView.reloadData()
    }
}
