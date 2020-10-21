//
//  GlobalUtility.swift
//
//  Created by HiddenBrains on 14/07/16.
//
//

import UIKit
import Lottie
#if canImport(TALogger)
import TALogger
#endif
/// Utility class commonly used in the app
@objc class GlobalUtility: NSObject {
    
   
    
    /// Shared instance of the globalutility class
    static let shared: GlobalUtility = {
        let instance = GlobalUtility()
        // setup code
        return instance
    }()
    
    
    /// Show Progress view in the app
    static func showHud() {
        
        let aStoryboard = UIStoryboard(name: "Loader", bundle: nil)
        let aVCObj = aStoryboard.instantiateViewController(withIdentifier: "LoaderVC") as! LoaderVC
        let aParent = AppConstants.appDelegate.window
        aVCObj.view.frame = UIScreen.main.bounds
        aVCObj.view.tag  = 10000
        aParent?.addSubview(aVCObj.view)
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(hideHud), userInfo: nil, repeats: false)
    }
    
    /// Hide Progress view in the app
    @objc static func hideHud() {

        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        let aParent = AppConstants.appDelegate.window
        for view in (aParent?.subviews)!
        {
            if view.tag == 10000
            {
                view.removeFromSuperview()
            }
        }
    }
    
    /// Get Navigation bar Button
    ///
    /// - Parameters:
    ///   - target: Target for the button
    ///   - selector: Selector Method
    ///   - imageName: Image to be displayed
    ///   - renderMode: Render Mode
    ///   - tintColor: Tint Color for the button
    ///   - direction: Direction for the button
    /// - Returns: Returns the button instance
    class func getNavigationButtonItems(target: AnyObject, selector: Selector, imageName: String, renderMode:UIImage.RenderingMode? = .alwaysOriginal, tintColor:UIColor? = .black, direction:UIControl.ContentHorizontalAlignment? = .left) -> [UIBarButtonItem]? {
        if let image = UIImage(named: imageName) {
            let itemWidth = 30
            let viewMain: UIView = UIView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth))
            let btnLeft: WLButton = WLButton(type: .custom)
            btnLeft.contentHorizontalAlignment = direction!
            if let tint = tintColor {
                btnLeft.tintColor = tint
            }
            btnLeft.frame = CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth)
            btnLeft.setImage(image.withRenderingMode(renderMode!), for: .normal)
            if let highlightedImage = UIImage(named: imageName + "_h") {
                btnLeft.setImage(highlightedImage, for: .highlighted)
            }
            btnLeft.addTarget(target, action: selector, for: .touchUpInside)
            viewMain.addSubview(btnLeft)
            let barBtnItem: UIBarButtonItem = UIBarButtonItem(customView: viewMain)
            let frontSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            frontSpacer.width = -2
            let arrBarButton = [frontSpacer, barBtnItem]
            return arrBarButton
        }
        return nil
    }
    
    /// Get current TopView controller
    ///
    /// - Returns: UIViewController
    func currentTopViewController() -> UIViewController {
        var topVC: UIViewController? = AppConstants.appDelegate.window?.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
    
    /// Get Json String from any Object
    ///
    /// - Parameter object: Object to be converted in to json string
    /// - Returns: Returns json string
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    /// Redirect to login
    class func redirectToLogin()
    {
        if AppConstants.appType == LoginWith.phone {
            // MARK: - Login With PhoneNumber Setup
            if let loginVC = LoginPhoneViewController.instance() {
                let vc = NavController.init(rootViewController: loginVC)
                AppConstants.appDelegate.window?.rootViewController = vc
            }
        } else if AppConstants.appType == LoginWith.email {
            // MARK: - Login With Email Setup
            if let loginVC = LoginEmailViewController.instance() {
                let vc = NavController.init(rootViewController: loginVC)
                AppConstants.appDelegate.window?.rootViewController = vc
            }
        } else if AppConstants.appType == LoginWith.socialPhone {
            // MARK: - Social login With PhoneNumber Setup
            if let loginVC = LoginPhoneAndSocialViewController.instance() {
                let vc = NavController.init(rootViewController: loginVC)
                AppConstants.appDelegate.window?.rootViewController = vc
            }
        } else if AppConstants.appType == LoginWith.socialEmail {
            // MARK: - Social login With Email Setup
            if #available(iOS 12.0, *) {
                if let loginVC = LoginEmailAndSocialViewController.instance() {
                    let vc = NavController.init(rootViewController: loginVC)
                    AppConstants.appDelegate.window?.rootViewController = vc
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    
  
    /// Get The Class name
    ///
    /// - Parameter obj: Pass the object
    /// - Returns: Returns the class name in string
    class func classNameAsString(obj: Any) -> String {
        //prints more readable results for dictionaries, arrays, Int, etc
        return String(describing: type(of: obj))
    }
    
    /// Log button event
    /// - Parameter functionName: Button click function name
    /// - Parameter file: File name where button is located
    /// - Parameter name: Name of event
    class func logButtonEvent(functionName : String,file:String,name:String)
    {
        #if canImport(TALogger)
        TALogger.shared.LogEvent(function:functionName,file:file , name: name, description: "Button Event")
        #endif
    }
    
    /// Log screen event
    /// - Parameter file: File Name
    /// - Parameter name:Name of event
    /// - Parameter description: Description of event
    class func logScreenEvent(file:String,name:String,description:String)
    {
        #if canImport(TALogger)
        TALogger.shared.LogEvent(function:name ,file:file, name: name, description: description)
        #endif
    }
    
    /// Set User in logger library
    /// - Parameter user: User name
    class func setUser(user:String)
    {
        #if canImport(TALogger)
        TALogger.shared.setUser(user)
        #endif
    }
}
