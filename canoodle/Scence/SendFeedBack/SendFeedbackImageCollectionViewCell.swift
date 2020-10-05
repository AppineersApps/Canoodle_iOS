//
//  SendFeedbackImageCollectionViewCell.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class SendFeedbackImageCollectionViewCell: UICollectionViewCell {
    var btnRemoveTappedClouser: (() -> Void)?
    @IBOutlet weak var imgPicked: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    
    @IBAction func btnRemoveImageAction(_ sender: Any) {
        if btnRemoveTappedClouser != nil {
            btnRemoveTappedClouser!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgPicked.layer.cornerRadius = 3
        imgPicked.clipsToBounds = true
        imgPicked.contentMode = .scaleAspectFit
        //viewBg.dropShadow(color: #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1), opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgPicked.layoutIfNeeded()
        imgPicked.layer.cornerRadius = 4
    }
}
