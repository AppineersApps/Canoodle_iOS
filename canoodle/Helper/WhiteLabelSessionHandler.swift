//
//  WhiteLabelSessionHandler.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

/// Session handler for app
open class WhiteLabelSessionHandler: NSObject {
    
    /// Shared instance
    static let shared = WhiteLabelSessionHandler()
    
    /// State list data
    var stateListDate = [StateList.ViewModel]()
    
    
    /// Set State list data
    ///
    /// - Parameter data: array for state list
    func setStateList(data:  [StateList.ViewModel]) {
        self.stateListDate = data
    }
    
    /// Count for interstitial ad
    var addCount = 0 {
        didSet {
            if addCount % 4 == 0 && addCount != 0 {
                print("Show")
                if let aVC = UIViewController.topViewController(withRootViewController: AppConstants.appDelegate.window?.rootViewController ?? UIViewController()) as? BaseViewControllerWithAd {
                    aVC.showFullAdd()
                }
            }
        }
    }
    
    
}
