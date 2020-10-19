//
//  SubscriptionModels.swift
//  Tyst
//
//  Created by hb on 27/11/19.
//  Copyright (c) 2019 hb. All rights reserved.
//

import UIKit

enum Subscription {
    // MARK: Use cases
    /// Reponse Class
    class ViewModel: WSResponseData {
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
        
        
        /// Init Method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
    }
}


/// Enum for go ad free
enum ManageSubscription {
    /// Struct for API Request
    struct Request {
        /// One time Transaction Data Receipt
        var oneTimeTransactionData: Data
        var fileName: String
    }
}


enum FetchSubscription {
    class ViewModel: WSResponseData {
        
        var isSubscribed : String?
        
        enum CodingKeys: String, CodingKey {
            case isSubscribed = "is_subscribed"
        }
        
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            isSubscribed = try values.decodeIfPresent(String.self, forKey: .isSubscribed)
        }
    }
}
