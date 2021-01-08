//
//  AppDelegate+Notification.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import Foundation
import UserNotifications
import Firebase
import FirebaseMessaging

// MARK: - UserNotification Delegate methods
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    /// Register app for remote notificationd
    ///
    /// - Parameter onCompletion: completion closure will be called when app is registered for notifications
    func registerRemoteNotification(onCompletion: ((Bool) -> Void)? = nil) {
        let application = UIApplication.shared
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            guard error == nil else {
                //Display Error.. Handle Error.. etc..
                onCompletion?(false)
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
                UNUserNotificationCenter.current().delegate = self
                UserDefaultsManager.notificationEnable = "Yes"
                onCompletion?(true)
            } else {
                //Handle user denying permissions..
                UserDefaultsManager.notificationEnable = "No"
                onCompletion?(false)
            }
        }
        
    }
    
    /// App did register for remote notifications
    ///
    /// - Parameters:
    ///   - application: Application instance
    ///   - deviceToken: Device token that is generated
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        //UserDefaultsManager.deviceToken = deviceTokenString
        Messaging.messaging().apnsToken = deviceToken as Data

        print("devicetoken = \(deviceTokenString)")
    }
    
    /// Method is called when push notification is received
    ///
    /// - Parameters:
    ///   - center: Notification center
    ///   - notification: Notification info
    ///   - completionHandler: Completion Handler
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //self.handlePushNotification(userInfo : notification.request.content.userInfo)
        completionHandler([.alert, .badge, .sound])
    }
    
    /// Method is called when user taps on push notification
    ///
    /// - Parameters:
    ///   - center: Notification center
    ///   - response: Notification info
    ///   - completionHandler: Completion Handler
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle the notification
        self.handlePushNotification(userInfo : response.notification.request.content.userInfo)
    }
    
    /// Method is called when app is in background and user taps on push notification
    ///
    /// - Parameters:
    ///   - application: Application instance
    ///   - userInfo: Notification info
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        self.handlePushNotification(userInfo: userInfo)
    }
    
    /// Method is called when app fails to register push notification
    ///
    /// - Parameters:
    ///   - application: Application object
    ///   - error:Error info
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaultsManager.deviceToken = "Error:\(AppConstants.deviceId ?? "")"
        print("i am not available in simulator \(error)")
    }
    
    /// Method is called to manage push notification data
    ///
    /// - Parameter userInfo: User info received from notification
    func handlePushNotification(userInfo: [AnyHashable : Any]) {
        print(userInfo)

        let notificationInfo: [String : Any] = convertToDictionary(text: userInfo["others"] as! String)!
        if  let type = notificationInfo["type"] as? String {
        
            switch type.lowercased() {
            case "message":
                let user_id = notificationInfo["user_id"] as!  String
                let user_name = notificationInfo["user_name"] as! String
                let user_image = notificationInfo["user_image"] as! String
                if (UserDefaultsManager.getLoggedUserDetails() != nil) {
                    self.navigateToChat(userID: user_id, userName: user_name, userImage:user_image)
                }
                return
            case "like":
                let user_id = notificationInfo["user_id"] as!  String
                if (UserDefaultsManager.getLoggedUserDetails() != nil) {
                    self.navigateToProfileVC(userID: user_id)
                }
                return
            case "match":
                let user_id = notificationInfo["user_id"] as!  String
                if (UserDefaultsManager.getLoggedUserDetails() != nil) {
                    self.navigateToProfileVC(userID: user_id)
                }
                return
            default:
                print("Not handled case:\(type)")
//                let response = try? JSONDecoder().decode(PushNotificationResponse.self,from:others.data(using:.utf8)!)
//                print(response?.receiver_id)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func navigateToChat(userID:String, userName:String, userImage:String) {
        if let chatVC = ChatViewController.instance() {
            let connection = Connection.ViewModel.init(dictionary: ["user_id": userID, "user_name": userName, "user_image": userImage])
            chatVC.setConnection(connection: connection!)
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
                AppConstants.appDelegate.window?.rootViewController = tab
            }
            
            if let tabBarController = self.window?.rootViewController as? UITabBarController, let navController = tabBarController.selectedViewController as? UINavigationController {
                navController.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    func navigateToProfileVC(userID: String) {
        if let userProfileVC = UserProfileViewController.instance() {
            userProfileVC.userId = userID
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            if let tab = storyboard.instantiateInitialViewController(), tab is TabbarController {
                AppConstants.appDelegate.window?.rootViewController = tab
            }
            
            if let tabBarController = self.window?.rootViewController as? UITabBarController, let navController = tabBarController.selectedViewController as? UINavigationController {
                navController.pushViewController(userProfileVC, animated: true)
            }
        }
    }
}
