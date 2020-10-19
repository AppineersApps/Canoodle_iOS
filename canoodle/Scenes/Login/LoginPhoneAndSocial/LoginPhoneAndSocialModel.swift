//
//  LoginPhoneAndSocialModel.swift
//  WhiteLabelApp
//
//  Created by hb on 17/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation

enum LoginPhoneAndSocialModel {
    /// Struct for API Request
    struct Request {
        var phone: String
        var password: String
    }
    
    struct SocialRequest {
        var type: String
        var id: String
    }
}
