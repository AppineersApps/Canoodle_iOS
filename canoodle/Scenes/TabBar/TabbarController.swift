//
//  TabBarViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        self.delegate = weakSelf
    }
    
    // MARK: Class Instance
    class func instance() -> TabbarController? {
        return UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabbarController") as? TabbarController
    }
}

extension TabbarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if AppConstants.isLoginSkipped {
            var displayVC : UIViewController?
            if let aNavVC = viewController as? NavController {
                displayVC = aNavVC.topViewController
            } else {
                displayVC = viewController
            }
            if displayVC is MyProfileViewController {
                GlobalUtility.redirectToLogin()
                return false
            }
        }
        
        return true
    }
}
