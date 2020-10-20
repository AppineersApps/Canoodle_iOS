//
//  Date+Extension.swift
//  MadCollab
//
//  Created by Appineers India on 28/06/20.
//  Copyright © 2020 hb. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
