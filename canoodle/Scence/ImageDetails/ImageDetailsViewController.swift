//
//  ImageDetailsViewController.swift
//
//  Created by hb on 26/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

/// This class is used to display multiple photos with swipe left and right manner.
class ImageDetailsViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    var imgStr = ""
    
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgProfile.setImage(with: imgStr, placeHolder: #imageLiteral(resourceName: "signup_default_user"))
    }
    
    /// Instance
    ///
    /// - Returns: ImageDetailsViewController
    class func instance() -> ImageDetailsViewController? {
        return StoryBoard.ImageDetails.board.instantiateViewController(withIdentifier: AppClass.ImageDetailsVC.rawValue) as? ImageDetailsViewController
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Dismiss full screen view
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
