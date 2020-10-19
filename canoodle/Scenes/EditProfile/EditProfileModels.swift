//
//  EditProfileModels.swift
//  WhiteLabelApp
//
//  Created by hb on 25/09/19.

import UIKit

enum EditProfile {
    /// Struct for API Request
    struct Request {
        /// First Name Param
        var firstName : String
        /// Last name Param
        var lastName : String
         /// Gender
        var gender : String
        /// Username pararm
        var userName: String
        /// Mobile Number Param
        var mobileNo : String
        /// User profile name
        var userProfileName : String
        /// User profile Photo
        var userProfile : Data
        /// DOB
        var dob: String
        /// Age
        var age: String
        /// Address
        var address: String
        /// City
        var city: String
        /// Lat
        var lat: String
        /// Long
        var long: String
        /// StateName
        var stateName: String
        /// Zip code
        var zipCode: String
    }
}
