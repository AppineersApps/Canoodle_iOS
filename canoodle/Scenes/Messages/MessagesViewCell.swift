//
//  MessagesViewCell.swift
//  MadCollab
//
//  Created by Appineers India on 28/04/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class MessagesViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(message: Message.ViewModel) {
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 2

        nameLabel.text = message.receiverName
        messageLabel.text = message.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a, MMM dd yyyy"
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter1.date(from: message.updatedAt!)
        timeLabel.text = dateFormatter.string(from: date!)
        if(message.receiverImage != "") {
            profileImageView.setImage(with: message.receiverImage, placeHolder: UIImage.init(named: "watermark"))
        }
        else {
            profileImageView.image = UIImage.init(named: "watermark")
        }
    }
    
}
