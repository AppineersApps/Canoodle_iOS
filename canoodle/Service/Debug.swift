//
//  Debug.swift
//  HealthyWage
//
//  Created by Allen Jørgen Tobias O'Leary on 4/13/15.
//  Copyright (c) 2015 HealthyWage. All rights reserved.
//

import Foundation

func printDebug(_ message: String) {
    #if DEBUG
    print("D> \(message)")
    #endif
}

func printDebug(_ object: CustomStringConvertible) {
    #if DEBUG
    print("D> \(object)")
    #endif
}

func printDebug() {
    #if DEBUG
    print("D>")
    #endif
}

struct Debug {
    
    static func printRequest(_ request: URLRequest?, response: HTTPURLResponse?, responseString: String?, error: NSError?, cookies: [HTTPCookie]? = nil) {
        var cookies = cookies
        if let request = request {
            
            printDebug("REQUEST:\n")
            printDebug("URL: \(request.url?.absoluteString ?? "")")
            printDebug("HTTPMethod: \(request.httpMethod!)")
            printDebug("HTTPHeaders: \(request.allHTTPHeaderFields!)")
            
            if let cookies = cookies {
                let cookiesDescription = cookies.reduce("Cookies: ") { (value: String, cookie: HTTPCookie) in
                    return "\(value) \(cookie.name) : \(cookie.value),"
                }
                printDebug(cookiesDescription)
            }
            
            if let body = request.httpBody, let bodyStr = NSString(data: body, encoding: String.Encoding.utf8.rawValue) {
                printDebug("HTTPBody: \(bodyStr)")
            }
            
            if cookies == nil && request.url != nil {
                cookies = HTTPCookieStorage.shared.cookies(for: request.url!)
            }
            
            if let cookies = cookies {
                let cookiesDescription = cookies.reduce("Cookies: ") { (value: String, cookie: HTTPCookie) in
                    return "\(value) \(cookie.name) : \(cookie.value),"
                }
                printDebug(cookiesDescription)
            }

        }

        if let response = response {
            printDebug("\nRESPONSE:")
            printDebug(response)
        }

        printDebug("\nRESPONSE STRING:")
        if let responseString = responseString {
            printDebug(responseString)
        }

        if let error = error {
            printDebug("\nERROR:")
            printDebug(error)
        }
        printDebug()
    }
    
    static func printRequest(_ request: URLRequest?, response: HTTPURLResponse?, JSON: AnyObject?, error: NSError?, cookies: [HTTPCookie]? = nil) {
        var cookies = cookies
        if let request = request {
            printDebug("REQUEST:\n")
            printDebug("URL: \(request.url?.absoluteString ?? "")")
            printDebug("HTTPMethod: \(request.httpMethod!)")
            
            if let headerFields = request.allHTTPHeaderFields {
                printDebug("HTTPHeaders: \(headerFields)")
            }
            
            if cookies == nil && request.url != nil {
                cookies = HTTPCookieStorage.shared.cookies(for: request.url!)
            }
            
            if let cookies = cookies {
                let cookiesDescription = cookies.reduce("Cookies: ") { (value: String, cookie: HTTPCookie) in
                    return "\(value) \(cookie.name) : \(cookie.value),"
                }
                printDebug(cookiesDescription)
            }
            if let body = request.httpBody, let bodyStr = NSString(data: body, encoding: String.Encoding.utf8.rawValue) {
                printDebug("HTTPBody: \(bodyStr)")
            }
        }
        
        printDebug("\nRESPONSE:")
        if let response = response {
            printDebug(response)
        }
        printDebug("\nJSON:")
        if let JSON = JSON as? [String: AnyObject] {
            printDebug(JSON)
        }        
        printDebug("\nERROR:")
        if let error = error {
            printDebug(error)
            printDebug()
        }
        printDebug()
    }
}
