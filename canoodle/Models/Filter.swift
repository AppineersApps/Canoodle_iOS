//
//  Filter.swift
//  MadCollab
//
//  Created by Appineers India on 29/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class Filter: NSObject {
    public var interests: String?
    public var location: String?
    public var minAge: String?
    public var maxAge: String?
    
    init(dictionary: [String: Any]) {
        self.interests = dictionary["Interests"] as? String
        self.location = dictionary["Location"] as? String
        self.minAge = dictionary["MinAge"] as? String
        self.maxAge = dictionary["MaxAge"] as? String
    }
}
