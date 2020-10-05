//
//  StaticPageModels.swift
//  Pups
//
//  Created by hb on 07/05/19.

import UIKit

/// Static Page Request and Reponse
enum StaticPage {
    /// Struct for API Request
    struct Request {
        /// Page Code
        var pageCode: String
    }
    
   /// Reponse Class
    class ViewModel: WSResponseData {
        
        /// Page Title
        var pageTitle : String?
        /// Content
        var content : String?
        
        /// Params from API
        ///
        /// - page_title: Page Title
        /// - page_content: Page content
        enum CodingKeys: String, CodingKey {
            case page_title
            case page_content
        }
        
        /// Default Init Method
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required public init(from decoder: Decoder) throws {
            try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            pageTitle = try values.decodeIfPresent(String.self, forKey: .page_title)
            content = try values.decodeIfPresent(String.self, forKey: .page_content)
        }
        
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(pageTitle, forKey: .page_title)
            try container.encode(content, forKey: .page_content)
        }
        
    }
}
