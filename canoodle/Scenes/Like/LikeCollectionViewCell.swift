//
//  LikeCollectionViewCell.swift
//  canoodle
//
//  Created by Appineers India on 04/11/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import UIKit

class LikeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var blurImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 20.0
    }

    func setCellData(connection: Connection.ViewModel, index: Int) {
        nameLabel.text = connection.userName
        profileImageView.setImage(with: "\(connection.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
        if(index == 1) {
           // blurImageView.setImage(with: "\(connection.userImage!)", placeHolder: UIImage.init(named: "placeholder"))
            blurImageView.isHidden = false
            blurImageView.addBlurEffect(9)
        } else {
            blurImageView.isHidden = true
        }

        /*if(index == 0) {
            statusView.isHidden = true
        } else {
            statusView.isHidden = false
        }*/
    }
}
