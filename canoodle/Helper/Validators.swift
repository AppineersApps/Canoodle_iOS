//
//  Validators.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation
import UIKit

/// Validator Error class
class ValidationError: Error {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}

/// Protocol for validator
protocol ValidatorConvertible {
    func validated(_ value: String) throws -> String
}

/// Enum for Validator type
///
enum ValidatorType {
    /// - email: Email
    case email
    /// - phone: Phone
    case phone
    /// - password: Password
    case password(message: String)
    /// - username: Username
    case username
    /// - requiredField: required field
    case requiredField(message: String)
    /// - firstname: Firstname
    case firstname
    /// - lastname: Lastname
    case lastname
    /// - confirmpassword: Confirma password
    case confirmpassword(password: String,reqMessage: String, equalMessage: String )
    /// - zipcode: Zipcode
    case zipcode
}

///Enum for Validator methods
enum VaildatorFactory {
    /// Method to define validator type to return appropriate exception
    ///
    /// - Parameter type: Validator type
    /// - Returns: Returns exception value
    static func validatorFor(type: ValidatorType) -> ValidatorConvertible {
        switch type {
        case .email: return EmailValidator()
        case .phone: return PhoneValidator()
        case .password (let message): return PasswordValidator(message)
        case .username: return UserNameValidator()
        //        case .projectIdentifier: return ProjectIdentifierValidator()
        case .requiredField(let message): return RequiredFieldValidator(message)
        case .firstname: return FirstNameValidator()
        case .lastname: return LastNameValidator()
        case .zipcode: return ZipValidator()
        case .confirmpassword(let password,let message, let equalMessage): return ConfirmPasswordCheck(password,message, equalMessage)
        }
    }
}


/// Class for Phone Validator
class PhoneValidator: ValidatorConvertible {
    /// Validation for phone number
    ///
    /// - Parameter value: Value of textfield
    /// - Returns: returns message
    /// - Throws: throws exception if any error
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.requireMobile)}
        //guard value.count < 15 else {throw ValidationError(AlertMessage.invalidMobile)}
        guard (value.count > 0 && value.count == 14)  else {throw ValidationError(AlertMessage.invalidMobile)}
        return value
    }
}

/// Class for required fields
struct RequiredFieldValidator: ValidatorConvertible {
    /// Message for fields
    private let message: String
    
    /// Init method
    ///
    /// - Parameter field: String field
    init(_ field: String) {
        message = field
    }
    
    /// Validate the string value
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard !value.isEmpty else {
            throw ValidationError(message)
        }
        return value
    }
}

/// Struct for username validator
struct UserNameValidator: ValidatorConvertible {
    /// Validate username
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        
        guard value.count != 0 else {
            throw ValidationError(AlertMessage.enterUserName)
        }
        
        guard ((value.count >= 5) && !(value.count == 0)) else {
            throw ValidationError(AlertMessage.minValueUserName)
        }
        guard value.count < 20 else {
            throw ValidationError(AlertMessage.maxValueUserName)
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-zA-Z0-9]{5,20}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(AlertMessage.invalidUserName)
            }
        } catch {
            throw ValidationError(AlertMessage.invalidUserName)
        }
        return value
    }
}


/// Zip Validator
struct ZipValidator: ValidatorConvertible {
    /// Validate zipcode
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count >= 4 else {
            throw ValidationError(AlertMessage.minValueZip)
        }
        guard value.count <= 10 else {
            throw ValidationError(AlertMessage.maxValueZip)
        }
        
        do {
            if try NSRegularExpression(pattern: "^[a-zA-Z0-9 ]{5,20}$",  options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(AlertMessage.invalidZip)
            }
        } catch {
            throw ValidationError(AlertMessage.invalidZip)
        }
        return value
    }
}



/// Password Validator
struct PasswordValidator: ValidatorConvertible {
    
    /// Message to be returned
    private let message: String
    
    /// Init Method
    ///
    /// - Parameter field: Field String
    init(_ field: String) {
        message = field
    }
    
    /// Validate Password
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError(AlertMessage.requirePassword)}
        guard value.count >= 6 && value.count < 16 else { throw ValidationError(message) }
        
        do {
            if !isPasswordValidated(value){
                throw ValidationError(message)
            }
            
        } catch {
            throw ValidationError(message)
        }
        return value
    }
    
    /// Is Password valid
    ///
    /// - Parameter password: password string
    /// - Returns: returns true or false
    func isPasswordValidated(_ password: String) -> Bool {
        /// Lowercase letter
        var lowerCaseLetter: Bool = false
        /// Upper Case Letter
        var upperCaseLetter: Bool = false
        /// Is Digit
        var digit: Bool = false
        
        for char in password.unicodeScalars {
            if !lowerCaseLetter {
                lowerCaseLetter = CharacterSet.lowercaseLetters.contains(char)
            }
            if !upperCaseLetter {
                upperCaseLetter = CharacterSet.uppercaseLetters.contains(char)
            }
            if !digit {
                digit = CharacterSet.decimalDigits.contains(char)
            }
            
        }
        if  (digit && lowerCaseLetter && upperCaseLetter) {
            //do what u want
            return true
        }
        else {
            return false
        }
        
    }
    
}

/// Email Validator
struct EmailValidator: ValidatorConvertible {
    /// Validate Email
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.requireEmail)}
        //old   ^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$
        
        
        do {
            if try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError(AlertMessage.invalidEmail)
            }
        } catch {
            throw ValidationError(AlertMessage.invalidEmail)
        }
        return value
    }
}

/// First name Validator
struct FirstNameValidator: ValidatorConvertible {
    /// Validate firstname
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.requirefirstName)}
        
        guard value.count >= 1 else {
            throw ValidationError(AlertMessage.minValueFirstName)
        }
        guard value.count < 80 else {
            throw ValidationError(AlertMessage.maxValueFirstName)
        }
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: value, options: [], range: NSMakeRange(0, value.count)) != nil {
                throw ValidationError(AlertMessage.invalidFirstName)
            }
        } catch {
            throw ValidationError(AlertMessage.invalidFirstName)
        }
        return value
    }
}

/// Last name Validator
struct LastNameValidator: ValidatorConvertible {
    /// Validate Last name
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value.count > 0 else {throw ValidationError(AlertMessage.requirelastName)}
        
        guard value.count >= 1 else {
            throw ValidationError(AlertMessage.minValueLastName)
        }
        guard value.count < 80 else {
            throw ValidationError(AlertMessage.maxValueLastName)
        }
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: value, options: [], range: NSMakeRange(0, value.count)) != nil {
                throw ValidationError(AlertMessage.invalidLastName)
            }
        } catch {
            throw ValidationError(AlertMessage.invalidLastName)
        }
        return value
    }
}

/// Confirm password Validator
struct ConfirmPasswordCheck: ValidatorConvertible {
    private let passwordText: String
    private let reqMessage: String
    private let eqMessage: String
    init(_ field: String, _ requiredMessage: String, _ equalMessage: String) {
        passwordText = field
        reqMessage = requiredMessage
        eqMessage = equalMessage
    }
    
    /// Validate confirm password check
    ///
    /// - Parameter value: String Value
    /// - Returns: Returns message
    /// - Throws: Throws exception
    func validated(_ value: String) throws -> String {
        guard value != "" else {throw ValidationError(reqMessage)}
        
        guard value == passwordText else {
            throw ValidationError(eqMessage)
        }
        return value
    }
}
