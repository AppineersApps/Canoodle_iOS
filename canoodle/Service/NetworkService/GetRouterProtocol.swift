//
//  GetRouterProtocol.swift
//  ThisGuy
//
//  Created by The Appineers on 23/03/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire

/// Router Protocol default for whole app
public protocol GetRouterProtocol: URLRequestConvertible {

    /// HTTP Method
    var method: HTTPMethod { get }
    /// Base URL String to call API
    var baseUrlString: String { get }
    /// Path for api
    var path: String { get }
    /// Headers
    var headers: [String: String]? { get }
    /// Array of parameters
    var arrayParameters: [Any]? { get }
    /// Parameters for API
    var parameters: [String: Any]? { get }
    /// Device info
    var deviceInfo: [String: Any]? { get }
}

// MARK: - URL Request Extension
public extension GetRouterProtocol {
    /// get URL Request
    ///
    /// - Returns: return urls request object
    /// - Throws: throws exception if any error
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: self.baseUrlString) else {
            throw(NetworkError.requestError(errorMessage: "Unable to create url"))
        }
        var request = URLRequest(url: (path.contains("http://") || path.contains("https://")) ? URL(string: path)! : url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = self.headers
        request.timeoutInterval = 60.0 * 0.5
        return request
    }
    
    /// Array of parameters
    var arrayParameters: [Any]? {
        return nil
    }
}
