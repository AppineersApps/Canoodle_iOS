//
//  SignUpModels.swift
//  WhiteLabel
//
//  Created by hb on 13/09/19.

import UIKit

/// Enum for sign up
enum SignUp {
    // MARK: Use cases
    
    /// Sign up response model
    enum SignUpEmailModel {
        /// Struct for API Request
        struct Request {
            /// First Name
            var firstName : String
             /// Last Name
            var lastName : String
             /// Gender
            var gender : String
            /// User Name
            var userName: String
            /// Email
            var email : String
             /// Mobile Number
            var mobileNo : String
            /// User Profile Image
            var userProfileName : String
            /// User Profile
            var userProfile : Data
            /// Date of birth
            var dob: String
            /// Age
            var age: String
            /// Password
            var password: String
            /// Address
            var address: String
            /// City
            var city: String
            /// Latitude
            var lat: String
            /// Longitude
            var long: String
           /// State
            var state: String
            /// Zipcode
            var zipCode: String
            
        }
    }
    
    enum SignUpPhoneModel {
        struct Request {
            /// First Name
            var firstName : String
             /// Last Name
            var lastName : String
            /// User Name
            var userName: String
            /// Email
            var email : String
             /// Mobile Number
            var mobileNo : String
            /// User Profile Image
            var userProfileName : String
            /// User Profile
            var userProfile : Data
            /// Date of birth
            var dob: String
            /// Password
            var password: String
            /// Address
            var address: String
            /// City
            var city: String
            /// Latitude
            var lat: String
            /// Longitude
            var long: String
           /// State
            var state: String
            /// Zipcode
            var zipCode: String
            
        }
    }
    
    /// Enum for sign up social model
    enum SignUpSocialModel {
        /// Struct for request
        struct Request {
            /// First Name
            var firstName : String
             /// Last Name
            var lastName : String
             /// Gender
            var gender : String
            /// User Name
            var userName: String
            /// Email
            var email : String
             /// Mobile Number
            var mobileNo : String
            /// User Profile Image
            var userProfileName : String
            /// User Profile
            var userProfile : Data
            /// Date of birth
            var dob: String
            /// Age
            var age: String
            /// Address
            var address: String
            /// City
            var city: String
            /// Latitude
            var lat: String
            /// Longitude
            var long: String
           /// State
            var state: String
            /// Zipcode
            var zipCode: String
            /// SocialLogin Type
            var socialLoginType: String
            /// Social Id
            var socialId: String
        }
    }
}

/// Enum for check unique user model
enum CheckUniqueUser {
    /// Struct for request
    struct Request {
        /// Phone
        var phone: String
        /// Email
        var email: String
        /// User Name
        var userName: String
        
    }
    
    /// Class for reponse
    class ViewModel: WSResponseData {
        /// OTP Response param
        var otp : String?
        
        /// Enum for Reponse
        enum CodingKeys: String, CodingKey {
            /// - otp: OTP Key
            case otp
        }
        
        /// Default Init Methods
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            otp = try values.decodeIfPresent(String.self, forKey: .otp)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(otp, forKey: .otp)
        }
    }
}

enum StateList {
    
    class ViewModel: WSResponseData {
        var state : String?
        var stateId : String?
        var stateCode : String?
        var status : String?
        var countryCode : String?
        
        /// Enum for Reponse
        enum CodingKeys: String, CodingKey {
            /// State Key
            case state
            /// State ID
            case state_id
            /// State Code
            case state_code
            /// Status
            case status
            /// Country Code Key
            case country_code
        }
        
        /// Default Init Methods
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            state = try values.decodeIfPresent(String.self, forKey: .state)
            stateId = try values.decodeIfPresent(String.self, forKey: .state_id)
            stateCode = try values.decodeIfPresent(String.self, forKey: .state_code)
            status = try values.decodeIfPresent(String.self, forKey: .status)
            countryCode = try values.decodeIfPresent(String.self, forKey: .country_code)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(state, forKey: .state)
            try container.encode(stateId, forKey: .state_id)
            try container.encode(stateCode, forKey: .state_code)
            try container.encode(status, forKey: .status)
            try container.encode(countryCode, forKey: .country_code)
        }
    }
}
