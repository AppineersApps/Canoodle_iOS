//
//  String+Extension.swift
//  BaseProject
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// Get file extension
    ///
    /// - Returns: Return File Extension
    func fileExtension() -> String {
        return URL(fileURLWithPath: self).pathExtension
    }

    /// Get Trimmed string
    ///
    /// - Returns: Return Trimmed string
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    /// Get Boolean Status of string
    ///
    /// - Returns: Retun true or false
    func booleanStatus() -> Bool {
     return  ["true", "y", "t", "yes", "1", "Active"].contains { self.caseInsensitiveCompare($0) == .orderedSame }
        
    }
    
    /// Check if string contains
    ///
    /// - Parameter optional: Whether the object is optional
    /// - Throws: Throws error if any error
    func checkContains(optional: Bool) throws {
        if self == "" && optional == false {
            throw ValidationError(AlertMessage.addProfile)
        }
    }
    
    /// Set phone number format for string
    ///
    /// - Returns: Returns phone number in proper format
    public func toPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: nil)
    }
    
    /// Provides substring in range
    ///
    /// - Parameters:
    ///   - start: Start index
    ///   - end: End Index
    /// - Returns: String in the range
    func substring(start: Int, end: Int) -> String
    {

        if (start < 0 || start > self.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.count
        {
            print("end index \(end) out of bounds")
            return ""
        }

        
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: end - 1 )

        return String(self[startIndex...endIndex])
    }
    
   
    /// Convert Date in a format required to be sent to api
    ///
    /// - Returns: Return string with proper format from date
    func convertDateFormaterForAPI() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if date != nil {
            return  dateFormatter.string(from: date!)
        }else {
            return self
        }
    }
    
    /// Convert Date in a format required to be used in the app
    ///
    /// - Returns: Return string with proper format from date
    func convertDateFormaterForAPP() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM dd yyyy"
        if date != nil {
            return  dateFormatter.string(from: date!)
        }else {
            return ""
        }
    }
    
    /// Get Phone Number in proper format
    ///
    /// - Returns: Return phone number without any special character
    public func getPhoneNumber() -> String {
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "") 
    }
    
}

