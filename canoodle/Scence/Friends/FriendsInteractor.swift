//
//  FriendsInteractor.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

/// Protocol for friends API
protocol FriendsBusinessLogic {
    
}

/// Protocol for Friends Data Store
protocol FriendsDataStore {
    
}

/// Class for Friends Interactor
class FriendsInteractor: FriendsBusinessLogic, FriendsDataStore {
    /// Presentor instance
   var presenter: FriendsPresentationLogic?
    /// Worker instance
   var worker: FriendsWorker?
    
}
