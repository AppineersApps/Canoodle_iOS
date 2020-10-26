//
//  Filter.swift
//  MadCollab
//
//  Created by Appineers India on 29/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class Filter: NSObject {
    public var gender: String?
    public var distance: String?
    public var minAge: String?
    public var maxAge: String?
    
    init(dictionary: [String: Any]) {
        self.gender = dictionary["Gender"] as? String
        self.distance = dictionary["Distance"] as? String
       // self.minAge = dictionary["MinAge"] as? String
       // self.maxAge = dictionary["MaxAge"] as? String
    }
}
