//
//  AppDelegate.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import SwiftyStoreKit
#if canImport(TALogger)
import TALogger
#endif
import Alamofire
import AppRating

@UIApplicationMain

/// AppDelegate class
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /// Main Window object
    var window: UIWindow?
    
    /// Method is called when app launches
    ///
    /// - Parameters:
    ///   - application: Application object
    ///   - launchOptions: Launch options
    /// - Returns: Returns whether app should be launched or not
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initialSetup()
        // If app luanch using tapping notification
        if let userInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable : Any] {
            print("Notification Info :: ", userInfo)
        }
        
        FirebaseApp.configure()
        
        #if canImport(TALogger)
        TALogger.shared.enable()
        TALogger.shared.disableAutoNetworkLog()
        #endif
        setupIAP()
        setupAppRating()
        self.registerRemoteNotification()

        return true
    }
    
    /// Method is called when app resigns active
    ///
    /// - Parameter application: Application object
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    /// Method is called when app enters background
    ///
    /// - Parameter application: Application object
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    /// Method is called when app enters foreground
    ///
    /// - Parameter application:  Application object
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
    }
    
    /// Method is called when app did become active
    ///
    /// - Parameter application:  Application object
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    /// Method is called when app terminates
    ///
    /// - Parameter application:  Application object
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /// Method is called when app opens from URL Schema
    ///
    /// - Parameters:
    ///   - app: Application object
    ///   - url: URL
    ///   - options: Options
    /// - Returns: Allow app to open
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let aStrURL = url.absoluteString
        if aStrURL.contains("3173960712646425") {
            let aHandled = ApplicationDelegate.shared.application(app, open: url, options: options)
            return aHandled
        } else {
              return GIDSignIn.sharedInstance()?.handle(url as URL?) ?? true
        }
    }
    
    /// Initial Setup
    private func initialSetup() {
        IQKeyboardManager.shared.enable = true
    }
    
    
    /// Set up in app purchase
    func setupIAP() {
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    let downloads = purchase.transaction.downloads
                    if !downloads.isEmpty {
                        SwiftyStoreKit.start(downloads)
                    } else if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("\(purchase.transaction.transactionState.debugDescription): \(purchase.productId)")
                case .failed, .purchasing, .deferred:
                    break // do nothing
                @unknown default:
                    break
                }
            }
        }
        
        SwiftyStoreKit.updatedDownloadsHandler = { downloads in
            
            // contentURL is not nil if downloadState == .finished
            let contentURLs = downloads.compactMap { $0.contentURL }
            if contentURLs.count == downloads.count {
                print("Saving: \(contentURLs)")
                SwiftyStoreKit.finishTransaction(downloads[0].transaction)
            }
        }
    }
    
    // setup InApp Rating
    private func setupAppRating() {
        AppRating.appID(AppInfo.kAppstoreID)

        // enable debug mode (disable this in production mode)
        //AppRating.debugEnabled(true);
        
        // reset the counters (for testing only);
         //AppRating.resetAllCounters();
        
        // set some of the settings (see the github readme for more information about that)
        AppRating.daysUntilPrompt(0);
        AppRating.usesUntilPrompt(2);
        AppRating.secondsBeforePromptIsShown(3);
        AppRating.significantEventsUntilPrompt(0); // set this to zero if you dont't want to use this feature

    }
}
