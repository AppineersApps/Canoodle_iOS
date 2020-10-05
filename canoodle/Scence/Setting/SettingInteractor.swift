//
//  SettingInteractor.swift
//  WhiteLabelApp
//
//  Created by hb on 23/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for Settings API
protocol SettingBusinessLogic {
    /// Call logout API
    func logout()
    /// Call Delete Account API
    func deleteAccount()
    /// Call Update Push Notification API
    ///
    /// - Parameter request: Update Notification request
    func updatePushNotification(request: UpdatePushNotificationSetting.Request)
    /// Call Go Ad Free API
    ///
    /// - Parameter request: Go Ad Free Request
    func goAddFree(request: GoAddFree.Request)
}

/// Protocol for sttings data store
protocol SettingDataStore {
    
}

/// Class for settings interactor
class SettingInteractor: SettingBusinessLogic, SettingDataStore {
    /// Presentor instance
    var presenter: SettingPresentationLogic?
    /// Worker instance
    var worker: SettingWorker?
    
    /// Call logout API
    func logout() {
        worker = SettingWorker()
        worker?.logout(completionHandler: { (message, success) in
            self.presenter?.presentLogout(message: message ?? "", Success: success ?? "")
        })
    }
    
    /// Call Delete Account API
    func deleteAccount() {
        worker = SettingWorker()
        worker?.deleteAccount(completionHandler: { (message, success) in
            self.presenter?.presentDeleteAccount(message: message ?? "", Success: success ?? "")
        })
    }
    
    /// Call Update Push Notification API
    ///
    /// - Parameter request: Update Notification request
    func updatePushNotification(request: UpdatePushNotificationSetting.Request) {
        worker = SettingWorker()
        worker?.updatePushNotification(request: request, completionHandler: { (message, success) in
            self.presenter?.presentUpdatePushNotification(message: message ?? "", Success: success ?? "")
        })
    }
    
    /// Call Go Ad Free API
    ///
    /// - Parameter request: Go Ad Free Request
    func goAddFree(request: GoAddFree.Request) {
        worker = SettingWorker()
        worker?.goAddFree(request: request, completionHandler: { (message, success) in
            self.presenter?.presentGoAddFree(message: message ?? "", success: success ?? "0")
        })
    }
}
