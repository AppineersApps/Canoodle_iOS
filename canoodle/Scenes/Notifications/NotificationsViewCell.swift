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
}

class NotificationsViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
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
        if(notification.userImage != "") {
            profileImageView.setImage(with: notification.userImage, placeHolder: UIImage.init(named: "watermark"))
            profileImageView.setImage(with: "\(notification.userImage!)", placeHolder: UIImage.init(named: "watermark"))
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
            messageLabel.text = "wants to collab with you"
        case "Message":
            messageLabel.text = "has sent you a message"
        case "Match":
            messageLabel.text = "has accepted your collab request"
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
    
}