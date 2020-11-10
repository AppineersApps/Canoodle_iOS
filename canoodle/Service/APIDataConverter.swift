//
//  APIDataConverter.swift
//  Note
//
//  Created by HB1 on 16/04/18.
//  Copyright © 2018 hb. All rights reserved.
//

import Foundation

/// this class is for Webservice response setting management
public class WSResponseSetting: Codable {
    
    var success: String?
    var message: String?
    var count: String?
    var likeCount: String?
    var likeMeCount: String?
    var nextPage: String?
    var accessToken: String?
   
    var isNextPage: Bool {
        return (nextPage != nil && nextPage! == "1")
    }
    
    var isSuccess: Bool {
        return (success != nil && success! != "0")
    }
    
    var isValidToken: Bool {
        guard let success = success else { return false }
        let tokenFailArray = ["-200", "-300", "-500", "-2", "-3", "-5"]
        return !tokenFailArray.contains(success)
    }
    
    private enum CodingKeys: String, CodingKey {
        case success = "success"
        case message = "message"
        case count = "count"
        case likeCount = "Like_count"
        case likeMeCount = "Likeme_count"
        case nextPage = "next_page"
        case accessToken = "access_token"
    }
    
    /// Default encode method
    ///
    /// - Parameter encoder: Encoder
    /// - Throws:throws exception if found error
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(success, forKey: .success)
        try container.encode(message, forKey: .message)
        try container.encode(count, forKey: .count)
        try container.encode(likeCount, forKey: .likeCount)
        try container.encode(likeMeCount, forKey: .likeMeCount)
        try container.encode(nextPage, forKey: .nextPage)
        try container.encode(accessToken, forKey: .accessToken)
    }
    
    /// Init Method
    ///
    /// - Parameter decoder: Decoder
    /// - Throws: throws exception if found error
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try? values.decode(String.self, forKey: .success)
        message = try? values.decode(String.self, forKey: .message)
        count = try? values.decode(String.self, forKey: .count)
        likeCount = try? values.decode(String.self, forKey: .likeCount)
        likeMeCount = try? values.decode(String.self, forKey: .likeMeCount)
        nextPage = try? values.decode(String.self, forKey: .nextPage)
        accessToken = try? values.decode(String.self, forKey: .accessToken)
    }
}

/// This class is for commonly managing webservice repsonse
public class WSResponse<T: WSResponseData> : Codable {
    
    var setting: WSResponseSetting?
    var arrayData: [T]?
    var dictData: T?

    private enum CodingKeys: String, CodingKey {
        case setting = "settings"
        case data = "data"
    }
    
    /// Default encode method
    ///
    /// - Parameter encoder: Encoder
    /// - Throws:throws exception if found error
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(setting, forKey: .setting)
        try container.encode(arrayData, forKey: .data)
        try container.encode(dictData, forKey: .data)
    }
    
    /// Init Method
    ///
    /// - Parameter decoder: Decoder
    /// - Throws: throws exception if found error
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        setting = try? values.decode(WSResponseSetting.self, forKey: .setting)
        arrayData = try? values.decode([T].self, forKey: .data)
        dictData = try? values.decode(T.self, forKey: .data)
    }
}

////// This class is for commonly managing webservice data
public class WSResponseData: Codable {
    
    init() {
        
    }
    
    /// Default encode method
    ///
    /// - Parameter encoder: Encoder
    /// - Throws:throws exception if found error
    public func encode(to encoder: Encoder) throws {
        
    }
    
    /// Init Method
    ///
    /// - Parameter decoder: Decoder
    /// - Throws: throws exception if found error
    required public init(from decoder: Decoder) throws {
        
    }
}
