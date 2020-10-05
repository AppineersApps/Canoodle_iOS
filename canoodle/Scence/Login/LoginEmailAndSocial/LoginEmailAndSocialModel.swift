//
//  LoginEmailAndSocialModel.swift
//  WhiteLabelApp
//
//  Created by hb on 17/09/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation

enum LoginEmailAndSocialModel {
    /// Struct for API Request
    struct Request {
        var email: String
        var password: String
    }
    
    struct SocialRequest {
        var type: String
        var id: String
    }
}
