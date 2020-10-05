//
//  NavController.swift
//  AppineersWhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

/// Customized Navigation Controller
final class NavController: UINavigationController {
    
    // MARK: - Private Properties
    
    /// Check status of variable when pushed
    fileprivate var duringPushAnimation = false
    
    // MARK: - Lifecycle
    
    /// Override UINavigationController method to initialize rootviewcontroller
    ///
    /// - Parameter rootViewController: Controller to be set rootviewcontroller
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
  
     /// Override method to initialize with nib
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name
    ///   - nibBundleOrNil: Bundle in which nib is present
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
   
   /// Decoder
    ///
    /// - Parameter aDecoder: Decoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
        self.isNavigationBarHidden = false
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor =  AppConstants.appColor
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20.0)]
        self.navigationItem.titleView?.backgroundColor = UIColor.red
    }
    
    /// Calls when viewcontroller release
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    
    /// Overrided the method to modify swipe gesture
    ///
    /// - Parameters:
    ///   - viewController: Viewcontroller that is pushed
    ///   - animated: Animated
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
    
    
  
}

// MARK: - UINavigationControllerDelegate
extension NavController: UINavigationControllerDelegate {
    
    /// Method is called when viewcontroller is pushed
    ///
    /// - Parameters:
    ///   - navigationController: Navigation controller instance
    ///   - viewController: ViewController instance
    ///   - animated: Animated
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        let backImage = UIImage(named: "btn_back")?.withAlignmentRectInsets(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil,
                                   action: nil)
        item.image = backImage
        item.tintColor = .white
        item.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        viewController.navigationItem.backBarButtonItem = item
        self.navigationBar.backIndicatorImage = backImage
        self.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0);
    }
    
    
    /// Viewcontroller did show
    ///
    /// - Parameters:
    ///   - navigationController: Navigation Controller instance
    ///   - viewController: Viewcontroller instance
    ///   - animated: Animated
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? NavController else { return }
        swipeNavigationController.duringPushAnimation = false
    }
   
}

// MARK: - UIGestureRecognizerDelegate
extension NavController: UIGestureRecognizerDelegate {
    /// Gesture Delegate method calls when user swipes back
    ///
    /// - Parameter gestureRecognizer: Gesture Recognizer
    /// - Returns: Returns true or false
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        return viewControllers.count > 1 && duringPushAnimation == false
        
       
    }
}

