//
//  TabBarViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 18/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
#if canImport(TALogger)
import TALogger
#endif

class TabbarController: UITabBarController {
    public static var onboarding: Bool = false

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
    
    func setOnboarding(value: Bool) {
        TabbarController.onboarding = value
    }
    
    func getOnboarding() -> Bool {
        return TabbarController.onboarding
    }
}

extension TabbarController : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        var displayVC : UIViewController?
        if let aNavVC = viewController as? NavController {
            displayVC = aNavVC.topViewController
        }
        #if canImport(TALogger)
        let className = GlobalUtility.classNameAsString(obj: viewController)
        TALogger.shared.LogEvent(type: "Tab Menu", function:"\(#function)", file:className, name: self.tabBar.selectedItem?.title ?? "--", description: "Tab Bar Event")
        #endif
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
