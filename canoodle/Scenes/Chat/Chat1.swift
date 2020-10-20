//
//  Chat1.swift
//  MadCollab
//
//  Created by Appineers India on 25/06/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

struct Chat1 {
    var users: [String]
    
    var dictionary: [String: Any] {
        return [
            "users": users
        ]
    }
}

extension Chat1 {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}
