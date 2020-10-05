//
//  SendFeedbackAddImageCollectionViewCell.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class SendFeedbackAddImageCollectionViewCell: UICollectionViewCell {
    var btnAddTappedClouser: (() -> Void)?
    
    @IBOutlet weak var viewBg: UIView!
    @IBAction func btnAddAction(_ sender: Any) {
        if btnAddTappedClouser != nil {
            btnAddTappedClouser!()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //viewBg.dropShadow(color: #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1), opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
}
