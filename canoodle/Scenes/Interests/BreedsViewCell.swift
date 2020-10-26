//
//  BreedsViewCell.swift
//  MadCollab
//
//  Created by Appineers India on 29/04/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

protocol BreedsViewCellProtocol: AnyObject {
    func breedSelected(breed: Breeds.ViewModel)
}

class BreedsViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectedView: UIView!
    
    var isSelect: Bool = false
    
    public weak var delegate: BreedsViewCellProtocol?
    var breed: Breeds.ViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 20
        self.setShadow()
    }
    
    func setCellData(breed: Breeds.ViewModel) {
        self.breed = breed
        nameLabel.text = breed.breedName
        //imageView.image = UIImage.init(named: breed.imageUrl)
        if(breed.breedImage != "") {
            imageView.setImage(with: breed.breedImage, placeHolder: UIImage.init(named: "placeholder"))
        }
        else {
            imageView.image = UIImage.init(named: "placeholder")
        }
    }
    
    @IBAction func btnSelectedAction(_ sender: Any) {
        selectedView.isHidden = false
        delegate?.breedSelected(breed: self.breed)
    }

}
