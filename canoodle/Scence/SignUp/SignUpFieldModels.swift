//
//  SignUpFieldModel.swift
//  WhiteLabelApp
//
//  Created by hb on 04/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

/// Config for sign up to hide or make optiona
enum SignUpConfig {
    
    struct SignUptextField: Codable {
        ///Profile picture
        let profilepictureoptional: String = "1"
        /// Skip status
        let skip: String  = "1"
        /// First name status
        var firstname: FieldStatus
        /// Last name status
        var lastname: FieldStatus
        /// Username status
        var username: FieldStatus
        /// Phone number status
        var phonenumber: FieldStatus
        /// DOB Status
        var dateofbirth: FieldStatus
        /// Street Addres Status
        var streetaddress: FieldStatus
        /// City Status
        var city: FieldStatus
        /// State Status
        var state: FieldStatus
        /// Zip Status
        var zip: FieldStatus
        
        /// Initialization / Default Status for the config
        init() {
            firstname = FieldStatus()
            lastname = FieldStatus()
            username = FieldStatus()
            phonenumber = FieldStatus()
            dateofbirth = FieldStatus()
            streetaddress = FieldStatus()
            city = FieldStatus()
            state = FieldStatus()
            zip = FieldStatus()
            
            setFirstNameProperties()
            setLastNameProperties()
            setUserNameProperties()
            setPhoneNumberProperties()
            setDateOfBirthProperties()
            setStreetAddressProperties()
            setStateProperties()
            setCityProperties()
            setZipProperties()
        }
        
        /// Set First name properties
        mutating func setFirstNameProperties() {
            firstname.visible = "1"
            firstname.optional = "0"
        }
        
        /// Set Last Name Properties
        mutating func setLastNameProperties() {
            lastname.visible = "1"
            lastname.optional = "0"
        }
        
        /// Set user name properties
        mutating func setUserNameProperties() {
            username.visible = "0"
            username.optional = "0"
        }
        
        ///Set Phone Number Properties
        mutating func setPhoneNumberProperties() {
            phonenumber.visible = "1"
            phonenumber.optional = "1"
        }
        
        /// Set DOB Properties
        mutating func setDateOfBirthProperties() {
            dateofbirth.visible = "0"
            dateofbirth.optional = "0"
        }
        
        /// Set Street Address Properties
        mutating func setStreetAddressProperties() {
            streetaddress.visible = "1"
            streetaddress.optional = "1"
        }
        /// Set state properties
        mutating func setStateProperties() {
            state.visible = "1"
            state.optional = "1"
        }
        /// Set City Properties
        mutating func setCityProperties() {
            city.visible = "1"
            city.optional = "1"
        }
        /// Set Zip Properties
        mutating func setZipProperties() {
            zip.visible = "1"
            zip.optional = "1"
        }
    }
    
    /// Field status
    struct FieldStatus : Codable {
        /// Visible Status
        var visible: String
        /// Optional Status
        var optional: String
        
        /// Default Initialization
        init() {
            visible = "1"
            optional = "0"
        }
    }
}
