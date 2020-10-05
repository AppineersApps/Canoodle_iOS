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
                onCompletion?(true)
            } else {
                //Handle user denying permissions..
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
        UserDefaultsManager.deviceToken = deviceTokenString
        
        print(deviceTokenString)
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
        if UIApplication.shared.applicationState == .active {
            // Refresh screens if opened.
        } else {
            
        }
    }
}
