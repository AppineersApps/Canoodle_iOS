//
//  RouterProtocol.swift
//  Note
//
//  Created by HB1 on 28/09/18.
//  Copyright © 2018 HB. All rights reserved.
//

import Foundation
import Alamofire

/// Router Protocol default for whole app
public protocol RouterProtocol: URLRequestConvertible {

    /// HTTP Method
    var method: HTTPMethod { get }
    /// Base URL String to call API
    var baseUrlString: String { get }
    
    /// Path for api
    var path: String { get }
    /// Parameters for API
    var parameters: [String: Any]? { get }
    /// Parameters encoding
    var parameterEncoding: ParameterEncoding { get }
    /// Headers
    var headers: [String: String]? { get }
    /// Array of parameters
    var arrayParameters: [Any]? { get }

    /// Files multipart
    var files: [MultiPartData]? { get }
    
    /// Device info
    var deviceInfo: [String: Any]? { get }
}

// MARK: - URL Request Extension
public extension RouterProtocol {
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
        request.timeoutInterval = 60.0
//        let contentType = "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW"
//        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        do {
            let req = try URLEncoding.default.encode(request as URLRequestConvertible, with: parameters)
            return req
        } catch let error {
            print("error occured \(error)")
        }
        return request
    }
//
//
//
//        guard let url = URL(string: self.baseUrlString) else {
//            throw(NetworkError.requestError(errorMessage: "Unable to create url"))
//        }
//
//        var request = URLRequest(url: url.appendingPathComponent(path))
//        request.httpMethod = self.method.rawValue
//        request.allHTTPHeaderFields = self.headers
//
//        if let file = self.files, file.count > 0 {
//            let contentType = "multipart/form-data; boundary=\(NetworkService.boundaryConstant)"
//            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        }
//
//        if let parameters = parameters {
//            do {
//                request = try parameterEncoding.encode(request, with: parameters)
//            } catch let encodingError {
//                throw(NetworkError.requestError(errorMessage: "Unable to encode with error: \(encodingError), parameters: \(parameters)"))
//            }
//        } else if let arrayParameters = arrayParameters {
//            do {
//                request = try JSONEncoding.default.encode(request, withJSONObject: arrayParameters)
//            } catch let encodingError {
//                throw(NetworkError.requestError(errorMessage: "Unable to encode with error: \(encodingError), parameters: \(parameters ?? [:])"))
//            }
//        }
//        return request
//    }
    
    /// get URL Request
    ///
    /// - Returns: return urls request object
    /// - Throws: throws exception if any error
    func asGetURLRequest() throws -> URLRequest {
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
