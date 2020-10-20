//
//  ChatViewController.swift
//  MadCollab
//
//  Created by Appineers India on 25/06/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage
import Foundation



protocol ChatDisplayLogic: class
{
    func displaySendMessageResponse(response: Bool)
    func displaySetConnectionResponse(response: Bool)
    func displayReportUserResponse(response: Bool)
    func displayDeleteMessageResponse(response: Bool)
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesDisplayDelegate {
    

    var interactor: ChatBusinessLogic?
    var router: (NSObjectProtocol & ChatRoutingLogic & ChatDataPassing)?

    //var currentUser: User = Auth.auth().currentUser!
    let refreshControl = UIRefreshControl()

    
    var user1Name: String = ""
    var user1ImgUrl: String = ""
    var user1UID: String = ""
    var user2UID: String = ""
    var user2Name: String = ""
    var user2ImgUrl: String = ""
    
    private var docReference: DocumentReference?
    
    var messages: [ChatMessage] = []
    var connection: Connection.ViewModel!
    var connType: String = ""
    var firebaseId: String = ""
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: Setup
    
    private func setup() {
      let viewController = self
      let interactor = ChatInteractor()
      let presenter = ChatPresenter()
      let router = ChatRouter()
      viewController.interactor = interactor
      viewController.router = router
      interactor.presenter = presenter
      presenter.viewController = viewController
      router.viewController = viewController
      router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let scene = segue.identifier {
        let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
        if let router = router, router.responds(to: selector) {
          router.perform(selector, with: segue)
        }
      }
    }

    func setConnection(connection: Connection.ViewModel) {
        self.connection = connection
        //connType = connection.type!
    }
    
    func setFirebaseId(firebaseId: String) {
        self.firebaseId = firebaseId
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let userData = UserDefaultsManager.getLoggedUserDetails()
        user1UID = userData?.userId as! String
        user1Name = userData?.userName as! String
        user1ImgUrl = userData?.userProfile as! String
        
        user2UID = connection.userId!
        user2Name = connection.userName!
        user2ImgUrl = connection.userImage!
        self.title = user2Name ?? "Chat"
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = false
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        loadChat()
    }
    
    func configureMessageCollectionView() {
       // messagesCollectionView = MessagesCollectionView(frame: .zero, collectionViewLayout: CustomMessagesFlowLayout())
      //  messagesCollectionView.register(CustomCell.self)
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = false // default false
        maintainPositionOnKeyboardFrameChanged = false // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadChat), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = AppConstants.appColor
        messageInputBar.sendButton.setTitleColor(AppConstants.appColor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            AppConstants.appColor!.withAlphaComponent(0.3),
            for: .highlighted
        )
        
        messageInputBar.isTranslucent = true
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.inputTextView.tintColor = AppConstants.appColor
        messageInputBar.inputTextView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        messageInputBar.inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        messageInputBar.inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        messageInputBar.inputTextView.layer.borderWidth = 1.0
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        configureInputBarItems()
    }

    private func configureInputBarItems() {
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.contentMode = .scaleToFill
        messageInputBar.sendButton.image = UIImage.init(named: "icon_arrow")
        //messageInputBar.sendButton.setBackgroundImage(UIImage.init(named: "icon_arrow"), for: UIControl.State.normal)
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
        let charCountButton = InputBarButtonItem()
            .configure {
                $0.title = "0/500"
                $0.contentHorizontalAlignment = .center
                $0.setTitleColor(UIColor(white: 0.6, alpha: 1), for: .normal)
                $0.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .bold)
                $0.setSize(CGSize(width: 50, height: 25), animated: false)
            }.onTextViewDidChange { (item, textView) in
                item.title = "\(textView.text.count)/500"
                let charCount = textView.text.count
                let isOverLimit = textView.text.count > 500
                //item.inputBarAccessoryView?.shouldManageSendButtonEnabledState = !isOverLimit // Disable automated management when over limit
                if isOverLimit {
                   // item.inputBarAccessoryView?.sendButton.isEnabled = false
                    textView.text = textView.text.substring(start: 0, end: 499)
                }
                //let color = isOverLimit ? .red : UIColor(white: 0.6, alpha: 1)
                //item.setTitleColor(color, for: .normal)
        }
        let bottomItems = [.flexibleSpace, charCountButton]
        
        configureInputBarPadding()
        
        messageInputBar.setStackViewItems(bottomItems, forStack: .bottom, animated: false)

        // This just adds some more flare
        messageInputBar.sendButton
            .onEnabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = AppConstants.appColor
                })
            }.onDisabled { item in
                UIView.animate(withDuration: 0.3, animations: {
                    item.imageView?.backgroundColor = UIColor(white: 0.85, alpha: 1)
                })
        }
    }
    
    /// The input bar will autosize based on the contained text, but we can add padding to adjust the height or width if neccesary
    /// See the InputBar diagram here to visualize how each of these would take effect:
    /// https://raw.githubusercontent.com/MessageKit/MessageKit/master/Assets/InputBarAccessoryViewLayout.png
    private func configureInputBarPadding() {
    
        // Entire InputBar padding
        messageInputBar.padding.bottom = 8
        
        // or MiddleContentView padding
        messageInputBar.middleContentViewPadding.right = -38

        // or InputTextView padding
        messageInputBar.inputTextView.textContainerInset.bottom = 8
        
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
      setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
    }
      
      // MARK: Class Instance
      class func instance() -> ChatViewController? {
          return StoryBoard.Chat.board.instantiateViewController(withIdentifier: AppClass.ChatVC.rawValue) as? ChatViewController
      }
    
    // MARK: - Custom messages handlers
    
    func createNewChat() {
        let users: [String] = [self.user1UID, self.user2UID]
         let data: [String: Any] = [
             "users":users
         ]
         
         let db = Firestore.firestore().collection("Chats")
         db.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                 self.loadChat()
             }
         }
    }
    
    @objc func loadChat() {
       // Auth.auth().signInAnonymously { (authResult, error) in
         //   guard let user = authResult?.user else { return }
            
            /*if Auth.auth().currentUser != nil {
                OnlineOfflineService.online(for: (Auth.auth().currentUser?.uid)!, status: true){ (success) in
                    print("User ==>", success)
                }
            }*/
        
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: self.user1UID ?? "Not Found User 1")
        
        
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
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    //Chat(s) found for currentUser
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat1(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(self.user2UID))! {
                            
                            self.docReference = doc.reference
                            self.firebaseId = doc.documentID
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {

                                        let msg = ChatMessage(dictionary: message.data())
                                        self.messages.append(msg!)
                                        print("Data: \(msg!.content ?? "No message found")")
                                    }
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToBottom(animated: true)
                                self.refreshControl.endRefreshing()
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    //}
    }

    
    func deletePost(msgId: String) {
        docReference?.collection("thread").getDocuments() { (threadQuery, error) in
             for message in threadQuery!.documents {
                print("document iD = \(message.documentID)")
                let msg = ChatMessage(dictionary: message.data())
                if(msg?.id == msgId) {
                    self.docReference?.collection("thread").document(message.documentID).delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            self.loadChat()
                        }
                    }
                }
            }
            
        }
    }
    
    private func save(_ message: ChatMessage) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            self.messagesCollectionView.scrollToBottom()
            self.sendMessage(msg: message.content)
        })
    }
    
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return !isPreviousTimestampSame(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].senderName == messages[indexPath.section - 1].senderName
    }
    
    func isPreviousTimestampSame(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        let currStr = MessageKitDateFormatter.shared.string(from: messages[indexPath.section].sentDate)
        let prevStr = MessageKitDateFormatter.shared.string(from: messages[indexPath.section - 1].sentDate)
        return (currStr == prevStr)
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].senderName == messages[indexPath.section + 1].senderName
    }
    
   /* func setTypingIndicatorViewHidden(_ isHidden: Bool, performUpdates updates: (() -> Void)? = nil) {
       // updateTitleView(title: "MessageKit", subtitle: isHidden ? "2 Online" : "Typing...")
        setTypingIndicatorViewHidden(isHidden, animated: true, whilePerforming: updates) { [weak self] success in
            if success, self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }*/
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return Sender(id: user1UID, displayName: user1Name )
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return (isFromCurrentSender(message: message) ? AppConstants.appColor : UIColor(red: 250/255, green: 234/255, blue: 228/255, alpha: 1))!
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        if message.sender.senderId == user1UID {
            if(user1ImgUrl == "") {
                avatarView.backgroundColor = UIColor.init(rgb: (r: 200, g: 200, b: 200))
                avatarView.image = UIImage.init(named: "watermark")
            } else {
                SDWebImageManager.shared.loadImage(with: URL(string: user1ImgUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    avatarView.image = image
                }
            }

        } else {
            if(user2ImgUrl == "") {
                avatarView.backgroundColor = UIColor.init(rgb: (r: 200, g: 200, b: 200))
                avatarView.image = UIImage.init(named: "watermark")
            } else {
                SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
                    avatarView.image = image
                }
            }
        }
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        return nil
    }
    
    /*func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }*/
    
    /*func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }*/
    @IBAction func actionButtonPressed(sender: UIBarButtonItem!) {
      /*  var type: String = "Block"
        if(connection.type == "Block") {
            type = "Unblock"
        }
        let optionMenu = UIAlertController(title: "Select Option", message: nil, preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "\(type) User", style: .default) { _ in
            self.addAnayltics(analyticsParameterItemID: "id-profileblock", analyticsParameterItemName: "Profile Block", analyticsParameterContentType: "event_profile")
            self.displayAlert(msg: "Are you sure you want to \(type) this user. You will no longer be a Match", ok: "Yes", cancel: "No", okAction: {
                if(self.connection.type == "Block") {
                    self.connType = ""
                    self.setConnectionStatus(type: "Unblock")
                } else {
                    self.connType = "Block"
                    self.setConnectionStatus(type: "Block")
                }
            }, cancelAction: {
                
            })
        }
        let reportAction = UIAlertAction(title: "Report User", style: .default) { _ in
            self.reportUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        if((connection.type == "Block") || (connection.type == "Like" && connection.reverseType == "Like")) {
            optionMenu.addAction(blockAction)
        }
        optionMenu.addAction(reportAction)
        optionMenu.addAction(cancelAction)
            
        AppConstants.appDelegate.window?.rootViewController!.present(optionMenu, animated: true, completion: nil)*/
    }
    
    func setConnectionStatus(type: String) {
        //connType = type
        if(connection != nil) {
           // self.interactor?.setConnection(userId: connection.id!, type: type)
        }
    }
    
    func sendMessage(msg: String) {
        if(connection != nil) {
           // self.interactor?.sendMessage(userId: connection.id!, firebaseId: self.firebaseId, message: msg)
        }
    }
    
    func deleteMessage(chat: Chat)
    {
        interactor?.deleteMessage(chat: chat)
    }
}


extension ChatViewController {
    
    func reportUser() {
        let optionMenu = UIAlertController(title: "Please select reason for reporting", message: nil, preferredStyle: .alert)

        let viewAllAction = UIAlertAction(title: "Abusive User", style: .default) { handler in
           self.addAnayltics(analyticsParameterItemID: "id-reportuser", analyticsParameterItemName: "Report User", analyticsParameterContentType: "app_event")

           // self.interactor?.reportUser(userId: self.connection.id!, message: "Abusive User")
        }
        let type1Action = UIAlertAction(title: "Spam User", style: .default) { handler in
              self.addAnayltics(analyticsParameterItemID: "id-reportuser", analyticsParameterItemName: "Report User", analyticsParameterContentType: "app_event")
           // self.interactor?.reportUser(userId: self.connection.id!, message: "Spam User")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        optionMenu.addAction(viewAllAction)
        optionMenu.addAction(type1Action)
        optionMenu.addAction(cancelAction)
            
        AppConstants.appDelegate.window?.rootViewController!.present(optionMenu, animated: true, completion: nil)
    }
}

/// Protocol for presenting response
extension ChatViewController : ChatDisplayLogic {
    func displaySendMessageResponse(response: Bool) {
        if(response == true) {
            //self.showTopMessage(message: "Message sent successfully", type: .Success)
        } else {
            self.showTopMessage(message: "Error sending message. Please try again", type: .Error)
        }
    }
    
    func displaySetConnectionResponse(response: Bool) {
        if(response == true) {
            if(connection != nil) {
               // connection.type = connType
            } else {
               // user.connectionType = connType
            }
            if(connType == "Block") {
                self.showTopMessage(message: "Blocked user successfully", type: .Success)
            } else if(connType == "Like") {
                self.showTopMessage(message: "Liked user successfully", type: .Success)
            } else {
                self.showTopMessage(message: "Unblocked user successfully", type: .Success)
            }
        } else {
            self.showTopMessage(message: "Error connecting. Please try again", type: .Error)
        }
    }
    
    func displayReportUserResponse(response: Bool) {
        if(response == true) {
            self.showTopMessage(message: "User reported successfully", type: .Success)
        } else {
            self.showTopMessage(message: "Error reporting user. Please try again", type: .Error)
        }
       // self.navigationController?.popViewController(animated: true)
    }
    
    func displayDeleteMessageResponse(response: Bool)
    {
        if(response == true) {
            self.showTopMessage(message: "Message deleted successfully", type: .Success)
         }
        else {
            self.showTopMessage(message: "Error deleting message. Please try again", type: .Error)
        }
    }
}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
                    inputBar.inputTextView.resignFirstResponder()
                    if(connection != nil) {
                       /* if(connection.type == "Block") {
                            GlobalUtility.shared.currentTopViewController().displayAlert(msg: "Please Unblock user to send message", ok: "Unblock", cancel: "Cancel", okAction: {
                                self.connType = ""
                                self.setConnectionStatus(type: "Unblock")
                            }, cancelAction: nil)
                            return
                        }
                        
                        if(connection.reverseType == "Block") {
                            self.showSimpleAlert(message: "Failed to send message. You are blocked by this user")
                            return
                        }
                        
                        if(connection.type == "" || connection.type == "Unlike") {
                            GlobalUtility.shared.currentTopViewController().displayAlert(msg: "Please collab with user to send message", ok: "Collab", cancel: "Cancel", okAction: {
                                self.connType = "Like"
                                self.setConnectionStatus(type: "Like")
                            }, cancelAction: nil)
                            return
                        }
                        
                        if(connection.reverseType == "" || connection.reverseType == "Unlike") {
                            GlobalUtility.shared.currentTopViewController().showSimpleAlert(message: "Other user needs to accept your collab request to message")
                            return
                        }*/
                    }
                    let currentTime = Date().toMillis()

        let message: ChatMessage = ChatMessage(id: UUID().uuidString, content: text.trimmingCharacters(in: .whitespacesAndNewlines), created: Timestamp(date: Date()), senderID: user1UID, senderName: user1Name)
                    
                      //messages.append(message)
                      insertNewMessage(message)
                      save(message)
        
                      inputBar.inputTextView.text = ""
                      messagesCollectionView.reloadData()
                      messagesCollectionView.scrollToBottom(animated: true)
    }

    
    private func insertNewMessage(_ message: ChatMessage) {
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            //self.messagesCollectionView.scrollToBottom(animated: true)
        }
        
    }
}

extension ChatViewController: MessageCellDelegate {

    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        let indexPath = messagesCollectionView.indexPath(for: cell)
        let message = messageForItem(at: indexPath!, in: messagesCollectionView)
        print("Message tapped : \(message.messageId)")
        print("Message index : \(indexPath?.row ?? 0)")
        let loginData = UserDefaultsManager.getLoggedUserDetails()
        if(loginData?.userId != message.sender.senderId) {
            print("other user message")
            return
        }

         self.displayAlert(msg: "Are you sure you want to delete this message?", ok: "Yes", cancel: "No", okAction: {
             //self.deleteMessage(chat: self.chatList[self.selectedRowIndex])
            let lastMessage = self.messages[self.messages.count - 1]
            let lastMsgId = lastMessage.messageId
            if(lastMsgId == message.messageId) {
                let prevMsg = self.messages[self.messages.count - 2]
                self.sendMessage(msg: prevMsg.content)
            }
            self.deletePost(msgId: message.messageId)
         }, cancelAction: nil)
    }
}


extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 1
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 2
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 1
    }
    
}
