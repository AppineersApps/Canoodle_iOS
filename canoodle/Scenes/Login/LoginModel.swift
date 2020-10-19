//
//  LoginModel.swift
//  WhiteLabel
//
//  Created by hb on 09/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation

struct Login {
   /// Reponse Class
    class ViewModel: WSResponseData {
        var userId: String?
        var firstName : String?
        var lastName : String?
        var gender : String?
        var mobileNo : String?
        var email : String?
        var userProfile : String?
        var authToken : String?
        var userType : String?
        var status : String?
        var socialLoginType : String?
        var socialLoginId: String?
        var address: String?
        var lat: String?
        var long: String?
        var userName: String?
        var dob: String?
        var age: String?
        var stateId: String?
        var city: String?
        var zipCode: String?
        var emailVerified: String?
        var deviceType: String?
        var deviceModel: String?
        var deviceOs: String?
        var deviceToken: String?
        var addedAt: String?
        var updatedAt: String?
        var state: String?
        var purchaseStatus: String?
        var logStatus: String?
        var pushNotification: String?
        var termsConditionsVersion: String?
        var privacyPolicyVersion: String?
        var premiumStatus: String?

        enum CodingKeys: String, CodingKey {
            case user_id
            case first_name
            case last_name
            case gender
            case mobile_no
            case email
            case profile_image
            case access_token
            case user_type
            case status
            case social_login_type
            case social_login_id
            case address
            case latitude
            case longitude
            case user_name
            case dob
            case age
            case state_id
            case city
            case zip_code
            case email_verified
            case device_type
            case device_model
            case device_os
            case device_token
            case added_at
            case updated_at
            case state_name
            case purchase_status
            case log_status_updated
            case push_notify
            case terms_conditions_version
            case privacy_policy_version
            case premium_status

        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            userId = try values.decodeIfPresent(String.self, forKey: .user_id)
            firstName = try values.decodeIfPresent(String.self, forKey: .first_name)
            lastName = try values.decodeIfPresent(String.self, forKey: .last_name)
            gender = try values.decodeIfPresent(String.self, forKey: .gender)
            mobileNo = try values.decodeIfPresent(String.self, forKey: .mobile_no)
            email = try values.decodeIfPresent(String.self, forKey: .email)
            userProfile = try values.decodeIfPresent(String.self, forKey: .profile_image)
            authToken = try values.decodeIfPresent(String.self, forKey: .access_token)
            userType = try values.decodeIfPresent(String.self, forKey: .user_type)
            status = try values.decodeIfPresent(String.self, forKey: .status)
            socialLoginType = try values.decodeIfPresent(String.self, forKey: .social_login_type)
            socialLoginId = try values.decodeIfPresent(String.self, forKey: .social_login_id)
            address = try values.decodeIfPresent(String.self, forKey: .address)
            lat = try values.decodeIfPresent(String.self, forKey: .latitude)
            long = try values.decodeIfPresent(String.self, forKey: .longitude)
            
            userName = try values.decodeIfPresent(String.self, forKey: .user_name)
            dob = try values.decodeIfPresent(String.self, forKey: .dob)
            age = try values.decodeIfPresent(String.self, forKey: .age)
            stateId = try values.decodeIfPresent(String.self, forKey: .state_id)
            city = try values.decodeIfPresent(String.self, forKey: .city)
            zipCode = try values.decodeIfPresent(String.self, forKey: .zip_code)
            emailVerified = try values.decodeIfPresent(String.self, forKey: .email_verified)
            deviceType = try values.decodeIfPresent(String.self, forKey: .device_type)
            deviceModel = try values.decodeIfPresent(String.self, forKey: .device_model)
            deviceOs = try values.decodeIfPresent(String.self, forKey: .device_os)
            deviceToken = try values.decodeIfPresent(String.self, forKey: .device_token)
            addedAt = try values.decodeIfPresent(String.self, forKey: .added_at)
            updatedAt = try values.decodeIfPresent(String.self, forKey: .updated_at)
            state = try values.decodeIfPresent(String.self, forKey: .state_name)
            purchaseStatus = try values.decodeIfPresent(String.self, forKey: .purchase_status)
            logStatus = try values.decodeIfPresent(String.self, forKey: .log_status_updated)
            pushNotification = try values.decodeIfPresent(String.self, forKey: .push_notify)
            termsConditionsVersion = try values.decodeIfPresent(String.self, forKey: .terms_conditions_version)
            privacyPolicyVersion = try values.decodeIfPresent(String.self, forKey: .privacy_policy_version)
            premiumStatus = try values.decodeIfPresent(String.self, forKey: .premium_status)

        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(userId, forKey: .user_id )
            try container.encode(firstName, forKey: .first_name)
            try container.encode(lastName, forKey: .last_name)
            try container.encode(gender, forKey: .gender)
            try container.encode(mobileNo, forKey: .mobile_no)
            try container.encode(email, forKey: .email)
            try container.encode(userProfile, forKey: .profile_image)
            try container.encode(authToken, forKey: .access_token)
            try container.encode(userType, forKey: .user_type)
            try container.encode(status, forKey: .status)
            try container.encode(socialLoginType, forKey: .social_login_type)
            try container.encode(socialLoginId, forKey: .social_login_id)
            try container.encode(address, forKey: .address)
            try container.encode(lat, forKey: .latitude)
            try container.encode(long, forKey: .longitude)
            try container.encode(socialLoginId, forKey: .social_login_id)
            try container.encode(address, forKey: .address)
            try container.encode(lat, forKey: .latitude)
            try container.encode(long, forKey: .longitude)
            try container.encode(socialLoginId, forKey: .social_login_id)
            try container.encode(address, forKey: .address)
            try container.encode(lat, forKey: .latitude)
            try container.encode(long, forKey: .longitude)
            try container.encode(socialLoginId, forKey: .social_login_id)
            try container.encode(address, forKey: .address)
            try container.encode(lat, forKey: .latitude)
            try container.encode(long, forKey: .longitude)
            try container.encode(city, forKey: .city)
            try container.encode(state, forKey: .state_name)
            try container.encode(userName, forKey: .user_name)
            try container.encode(zipCode, forKey: .zip_code)
            try container.encode(dob, forKey: .dob)
            try container.encode(age, forKey: .age)
            try container.encode(stateId, forKey: .state_id)
            try container.encode(purchaseStatus, forKey: .purchase_status)
            try container.encode(logStatus, forKey: .log_status_updated)
            try container.encode(pushNotification, forKey: .push_notify)
            try container.encode(termsConditionsVersion, forKey: .terms_conditions_version)
            try container.encode(privacyPolicyVersion, forKey: .privacy_policy_version)
            try container.encode(premiumStatus, forKey: .premium_status)
        }
    }
}
