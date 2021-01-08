//
//  BaseViewController.swift
//  WhiteLabelApp
//
//  Created by hb on 19/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import Alamofire
//import TALogger
/// Base View controller for all classes
class BaseViewController: UIViewController {
    
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConstants.backgroundColor
        let bg = UIImageView.init(frame: CGRect(x: 0, y: self.view.frame.height - 400, width: self.view.frame.width, height: 250))
        bg.image = UIImage.init(named: "pawBg")
        self.view.addSubview(bg)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.logScreenEvent("\(#function)")
    }
    
    
    func logScreenEvent(_ functionName:String) {
            var aName = GlobalUtility.classNameAsString(obj: self) + " Screen"
            aName = aName.replacingOccurrences(of: "ViewController", with: "")
            let className = GlobalUtility.classNameAsString(obj: self)
            
            if let aModel = UserDefaultsManager.getLoggedUserDetails()
            {
                GlobalUtility.setUser(user: aModel.email ?? "")
            }
            else
            {
                GlobalUtility.setUser(user: "N/A")
            }
            
            GlobalUtility.logScreenEvent(file: className, name: functionName, description: aName)
        }
    
    
    /// Check if internet is available
    ///
    /// - Returns: Returns true or false
    func internetAvailable()-> Bool {
        if !(NetworkReachabilityManager()!.isReachable) {
            self.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            return false
        }else {
            return true
        }
    }
    
    /// Get Bar Button with image
    ///
    /// - Parameters:
    ///   - image: Image of the bar button
    ///   - selected_image: Selected Image of the bar button
    ///   - action: Action selector for the button
    ///   - target: Target for the button
    /// - Returns: Bar Button with image
    public func getButton(image : UIImage,selected_image: UIImage ,action : Selector, target : Any) -> UIBarButtonItem {
        let btnBar = WLButton(type: .custom)
        btnBar.setImage(image, for: .normal)
        btnBar.setImage(selected_image, for: .selected)
        btnBar.contentHorizontalAlignment = .center
        btnBar.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btnBar.addTarget(target, action: action, for: .touchUpInside)
        btnBar.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton : UIBarButtonItem = UIBarButtonItem(customView: btnBar)
        return barButton
    }
}
