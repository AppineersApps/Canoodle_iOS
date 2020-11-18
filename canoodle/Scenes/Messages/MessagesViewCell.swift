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
        } else {
            nameLabel.text = message.receiverName
            if(message.receiverImage != "") {
                profileImageView.setImage(with: message.receiverImage, placeHolder: UIImage.init(named: "placeholder"))
            }
            else {
                profileImageView.image = UIImage.init(named: "placeholder")
            }
        }

    }
    
}

