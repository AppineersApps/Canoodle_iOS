//
//  BlockedUserViewCell.swift
//  Time2Beat
//
//  Created by Appineers India on 17/09/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import UIKit

protocol BlockedUserViewCellProtocol: AnyObject {
    func unblockUser(otherUserId: String)
}

class BlockedUserViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    public weak var delegate: BlockedUserViewCellProtocol?
    
    var user: Connection.ViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.borderColor = AppConstants.appColor!.cgColor
        profileImageView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(data: Connection.ViewModel) {
        self.user = data
        nameLabel.text = "\(data.userName!)"
       // addressLabel.text = "\(data!), \(data.state!)"
        
        if(data.userImage != "") {
            profileImageView.setImage(with: "\(data.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
        }
        else {
            profileImageView.image = UIImage.init(named: "placeholder")
        }
    }
    
    @IBAction func unblockButtonTapped(_ sender: UIButton) {
        self.delegate?.unblockUser(otherUserId: self.user.userId!)
    }
    
}
