//
//  SearchResultCell.swift
//  GoogleAutoComplete
//
//  Created by Apple on 29/04/18.
//  Copyright © 2018 leena. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var lblTitle :UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
