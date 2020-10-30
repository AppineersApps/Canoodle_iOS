//
//  SplashModels.swift
//  Test
//
//  Created by The Appineers on 11/10/19.
//  Copyright (c) 2019 The Appineers. All rights reserved.
//

import UIKit

struct Splash {
    
    /// Reponse Class
    class ViewModel: WSResponseData {
        
        var versionUpdateCheck: String?
        var androidVersion : String?
        var iosVersion : String?
        var versionUpdateOptional : String?
        var alertMessage : String?
        var termsConditionsUpdated : String?
        var privacyPolicyUpdated : String?
        var logStatusUpdated : String?
        var bannerAdUnitId: String?
        var interstitialAdUnitId: String?
        var projectDebugLevel: String?
        
        /// Enum for response
        ///
        /// - version_update_check: Version check param
        /// - android_version_number: android version number
        /// - iphone_version_number: iphone version number
        /// - version_update_optional: version update option check
        /// - version_check_message: version check message
        enum CodingKeys: String, CodingKey {
            /// - version_update_check: Version check param
            case version_update_check
            /// - android_version_number: android version number
            case android_version_number
            /// - iphone_version_number: iphone version number
            case iphone_version_number
            /// - version_update_optional: version update option check
            case version_update_optional
            /// - version_check_message: version check message
            case version_check_message
            /// - privacy_policy_updated: Privacy Policy Version Updated
            case privacy_policy_updated
            /// - terms_conditions_updated: Terms Conditions Version Updated
            case terms_conditions_updated
            /// - log_status_updated: Log Status Updated
            case log_status_updated
            /// - ios_banner_id
            case ios_banner_id
            /// - ios_interstitial_id
            case ios_interstitial_id
            /// - project_debug_level
            case project_debug_level
        }
        
        /// Init default method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            versionUpdateCheck = try values.decodeIfPresent(String.self, forKey: .version_update_check)
            androidVersion = try values.decodeIfPresent(String.self, forKey: .android_version_number)
            iosVersion = try values.decodeIfPresent(String.self, forKey: .iphone_version_number)
            versionUpdateOptional = try values.decodeIfPresent(String.self, forKey: .version_update_optional)
            alertMessage = try values.decodeIfPresent(String.self, forKey: .version_check_message)
            termsConditionsUpdated = try values.decodeIfPresent(String.self, forKey: .terms_conditions_updated)
            privacyPolicyUpdated = try values.decodeIfPresent(String.self, forKey: .privacy_policy_updated)
            logStatusUpdated = try values.decodeIfPresent(String.self, forKey: .log_status_updated)
            bannerAdUnitId = try values.decodeIfPresent(String.self, forKey: .ios_banner_id)
            interstitialAdUnitId = try values.decodeIfPresent(String.self, forKey: .ios_interstitial_id)
            projectDebugLevel = try values.decodeIfPresent(String.self, forKey: .project_debug_level)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(versionUpdateCheck, forKey: .version_update_check )
            try container.encode(androidVersion, forKey: .android_version_number)
            try container.encode(iosVersion, forKey: .iphone_version_number)
            try container.encode(versionUpdateOptional, forKey: .version_update_optional)
            try container.encode(alertMessage, forKey: .version_check_message)
            try container.encode(termsConditionsUpdated, forKey: .terms_conditions_updated)
            try container.encode(privacyPolicyUpdated, forKey: .privacy_policy_updated)
            try container.encode(logStatusUpdated, forKey: .log_status_updated)
            try container.encode(bannerAdUnitId, forKey: .ios_banner_id)
            try container.encode(interstitialAdUnitId, forKey: .ios_interstitial_id)
            try container.encode(projectDebugLevel, forKey: .project_debug_level)
        }
    }
}
