//
//  CanoodleViewCell.swift
//  canoodle
//
//  Created by Appineers India on 15/10/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

protocol CanoodleViewCellProtocol: AnyObject {
    func messageUser(user: Connection.ViewModel)
}

class CanoodleViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    public weak var delegate: CanoodleViewCellProtocol?
    
    var user: Connection.ViewModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderColor = AppConstants.appColor2!.cgColor
        profileImageView.layer.borderWidth = 2.0
        //profileImageView.addCircularShadow(profileImageView.frame.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(connection: Connection.ViewModel) {
        self.user = connection
        nameLabel.text = connection.userName
        profileImageView.setImage(with: "\(connection.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
    }
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.delegate?.messageUser(user: self.user)
    }
}
