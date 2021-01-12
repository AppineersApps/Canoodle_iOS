//
//  MessagesViewCell.swift
//  MadCollab
//
//  Created by Appineers India on 28/04/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MessagesViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    var chatMessages: [ChatMessage] = []
    private var docReference: DocumentReference?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(message: Message.ViewModel, unread: Int) {
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2

        readCountLabel.layer.cornerRadius = 10.0
        readCountLabel.text = "\(unread)"
        if(unread == 0) {
            readCountLabel.isHidden = true
        } else {
            readCountLabel.isHidden = false
        }
        messageLabel.text = message.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a, MMM dd yyyy"
        dateFormatter.timeZone = TimeZone.current
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter1.date(from: message.updatedAt!)
        timeLabel.text = dateFormatter.string(from: date!)
        
        let loginData = UserDefaultsManager.getLoggedUserDetails()
        if(loginData?.userId == message.receiverId!) {
            nameLabel.text = message.senderName
            if(message.receiverImage != "") {
                profileImageView.setImage(with: message.senderImage, placeHolder: UIImage.init(named: "placeholder"))
            }
            else {
                profileImageView.image = UIImage.init(named: "placeholder")
            }
            self.loadChat(user2UID: message.senderId!)

        } else {
            nameLabel.text = message.receiverName
            if(message.receiverImage != "") {
                profileImageView.setImage(with: message.receiverImage, placeHolder: UIImage.init(named: "placeholder"))
            }
            else {
                profileImageView.image = UIImage.init(named: "placeholder")
            }
            self.loadChat(user2UID: message.receiverId!)
        }
    }
    
    func loadChat(user2UID: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a, MMM dd yyyy"
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
                                var count = self.chatMessages.count-1
                                if(count >= 0) {
                                    let chatMessage: ChatMessage = self.chatMessages[count]
                                    print("chat message = \(chatMessage.content)")
                                    self.messageLabel.text = chatMessage.content
                                    self.timeLabel.text = dateFormatter.string(from: chatMessage.sentDate)
                                }
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
    
}

