//
//  SendFeedbackModels.swift
//  WhiteLabelApp
//
//  Created by hb on 26/09/19.

import UIKit

/// Send Feedback Request and Reponse
enum SendFeedback {
    // MARK: Use cases
    /// Struct for API Request
    struct Request {
        /// Post Description
        var postdescription: String
        /// Array of images
        var imageArray: [UIImage]
        /// Count of images
        var imageCount : String
    }
    
    /// Response Class
    class Response: WSResponseData {
     
        /// Default Init Methods
        ///
        /// - Parameter decoder: Decoder
        /// - Throws: throws exception if found error
        required init(from decoder: Decoder) throws {
            try super.init(from: decoder)
        }
       
        /// Default encode method
        ///
        /// - Parameter encoder: Encoder
        /// - Throws:throws exception if found error
        public override func encode(to encoder: Encoder) throws {
            try super.encode(to: encoder)
        }
    }
    
}
