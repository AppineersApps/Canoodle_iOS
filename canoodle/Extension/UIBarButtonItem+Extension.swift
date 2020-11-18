//
//  UIBarButtonItem+Extension.swift
//  canoodle
//
//  Created by Appineers India on 11/11/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import UIKit
#if canImport(TALogger)
import TALogger
#endif

extension UIBarButtonItem {

    
    override open func awakeFromNib() {
        super.awakeFromNib()
      //  self.action = #selector(logMenuEvent)
    }
    
    
    /// Log the Button events in library
   /* @objc func logMenuEvent(sender: UIBarButtonItem) {
        #if canImport(TALogger)
      //  TALogger.shared.LogEvent(type: "Menu", name: "Menu", description: "Menu Event")
        #endif
    }*/
}
