//
//  NotificationsViewCell.swift
//  MadCollab
//
//  Created by Appineers India on 28/04/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

protocol NotificationsViewCellProtocol: AnyObject {
    func messageUser(notification: Notification.ViewModel)
    func showUser(notification: Notification.ViewModel)
    func showProfileImage(userImage: String)
}

class NotificationsViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!

    public weak var delegate: NotificationsViewCellProtocol?
    
    var notification: Notification.ViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(notification: Notification.ViewModel) {
        self.notification = notification
        nameLabel.text = notification.userName
        messageLabel.text = notification.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a, MMM dd yyyy"
        dateFormatter.timeZone = TimeZone.current

        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")

        
        let date = dateFormatter1.date(from: notification.notificationDate!)
        dateLabel.text = dateFormatter.string(from: date!)
        //dateLabel.text = notification.notificationDate?.convertDateTimeFormatterForAPP()
        if(notification.userImage != "") {
            profileImageView.setImage(with: notification.userImage, placeHolder: UIImage.init(named: "placeholder"))
            profileImageView.setImage(with: "\(notification.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
        }
        else {
            profileImageView.image = UIImage.init(named: "placeholder")
        }


        if(notification.notificationType == "Message") {
            connectButton.setTitle("Message", for: UIControl.State.normal)
        }
        else {
            connectButton.setTitle("View Profile", for: UIControl.State.normal)
        }
        
        switch notification.notificationType {
        case "Like":
            messageLabel.text = "Liked your Profile"
        case "Message":
            messageLabel.text = "has sent you a message"
        case "Match":
            messageLabel.text = "Matched with your Profile"
        default:
            messageLabel.text = notification.message
        }
    }
    
     @IBAction func showButtonAction(_ sender: UIButton) {
        if(connectButton.titleLabel?.text == "Message") {
            delegate?.messageUser(notification: notification)
            //delegate?.showUser(notification: notification)
        }
        else {
            delegate?.showUser(notification: notification)
        }
    }
    
    @IBAction func btnImagedetailsAction(_ sender: Any) {
        delegate?.showProfileImage(userImage: self.notification.userImage!)
    }
}
