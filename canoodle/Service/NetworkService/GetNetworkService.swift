//
//  GetNetworkService.swift
//  ThisGuy
//
//  Created by The Appineers on 23/03/20.
//  Copyright © 2020 The Appineers. All rights reserved.
//

import Foundation
import Alamofire
#if canImport(TALogger)
import TALogger
#endif

public protocol GetNetworkProtocol {
    static func dataRequest<Model: WSResponseData>(with request: GetRouterProtocol, showHud:Bool, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void)
    static func tokenCreationDataRequest(with request: GetRouterProtocol, completionHandler: @escaping (Data?, Error?) -> Void)
}

final class GetNetworkService {
    private init() {}
    
    static let boundaryConstant = "aRandomBoundary1837440"
    
    private static let manager: SessionManager = { () -> SessionManager in
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        if #available(iOS 13.0, *) {
            //            configuration.allowsConstrainedNetworkAccess = true
        } else {
            // Fallback on earlier versions
        }
        configuration.timeoutIntervalForRequest = 30
        let sessionManager = SessionManager(configuration: configuration)
        return sessionManager
    }()
    
}

extension GetNetworkService: GetNetworkProtocol {
    
    static private func encryptedParamsWithCheckSum(params: [String: Any]) -> [String: Any] {
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var input_sha = ""
        var outputParams = [String: Any]()
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if key == UserDefaultsKey.ws_token {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                    outputParams[key] = strVal
                } else if strVal == "FILE" {
                    input_sha = "\(input_sha)\(key)="
                } else {
                    ////                    let encryptedVal = AESCrypt.encrypt(strVal, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
                    //                    input_sha = "\(input_sha)\(key)=\(encryptedVal!)"
                    //                    outputParams[key] = encryptedVal
                }
            } else {
                input_sha = "\(input_sha)\(key)="
                outputParams[key] = params[key]
            }
        }
        //        if let sha1_val = AESCrypt.getSHA1(input_sha) {
        //            outputParams[AppConstants.ws_checksum] = sha1_val
        //        }
        return outputParams
    }
    
    static private func encryptedParams(params: [String: Any]) -> [String: Any] {
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var outputParams = [String: Any]()
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if key == UserDefaultsKey.ws_token {
                    outputParams[key] = strVal
                } else if strVal == "FILE" {
                }
                //                } else {
                //                    let encryptedVal = AESCrypt.encrypt(strVal, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
                //                    outputParams[key] = encryptedVal
                //                }
            } else {
                outputParams[key] = params[key]
            }
        }
        return outputParams
    }
    
    static private func checkSum(of params: [String: Any]) -> [String: Any] {
        let sortedKeys = params.keys.sorted(by: {$0 < $1})
        var input_sha = ""
        let outputParams = params
        for key in sortedKeys {
            if let strVal = params[key] as? String {
                if key == UserDefaultsKey.ws_token {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                } else if strVal == "FILE" {
                    input_sha = "\(input_sha)\(key)="
                } else {
                    input_sha = "\(input_sha)\(key)=\(strVal)"
                }
            } else {
                input_sha = "\(input_sha)\(key)="
            }
        }
        //        if let sha1_val = AESCrypt.getSHA1(input_sha) {
        //            outputParams[AppConstants.ws_checksum] = sha1_val
        //        }
        return outputParams
    }
    
    static func dataRequest<Model: WSResponseData>(with inputRequest: GetRouterProtocol, showHud:Bool = true, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        let aRequestDate = Date()
        let finalParams = [String:Any]()
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        print("ROUTER VERB", inputRequest.parameters as Any)
        print("ROUTER HEADER", inputRequest.headers as Any)
        
        
        //Test123@123
        
        //print(parameters)
        // Serialize to JSON
        
        if inputRequest.method == .put {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: inputRequest.parameters)
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                }
            } catch {
                
            }
        }
        
        if !(NetworkReachabilityManager()!.isReachable) {
            let aVC = AppConstants.appDelegate.window?.rootViewController
            aVC?.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            return
        }
        
        if showHud {
            GlobalUtility.showHud()
        }
        
         do {
             _ = try inputRequest.asURLRequest()
         } catch {
             //ProgressHUD.sharedInstance.stopAnimating(randomString)
             completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
             return
         }
        
        manager.request(inputRequest.path, method: inputRequest.method,headers: inputRequest.headers).responseJSON {
        
        //manager.request(inputRequest.path, method: inputRequest.method,headers: inputRequest.headers).validate().responseJSON {
            response in
            
            print(response)
            switch (response.result) {
            case .success :
                        
                let request = response.request
                let resp = response.response
                //print(response.response)
                let result = response.result
                let responseString = String(data: response.data!, encoding: .utf8)
                let error = result.error as NSError?
                Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                GlobalUtility.hideHud()
                let finalResponseData: Data? = response.data
            
                if let data = finalResponseData {
                    // let aCode  : String = "\(resp?.statusCode ?? 200)"
                    let pathString = inputRequest.path.replacingOccurrences(of: AppConstants.baseUrl, with: "")

                    #if canImport(TALogger)
                    if responseString?.count ?? 0 > 0 {
                        if resp?.statusCode ?? 0 >= 200 && resp?.statusCode ?? 0 <= 299 {
                            TALogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: responseString, requestDate: aRequestDate, responseDate: Date())
                        } else {
                            let aDict = ["Error":NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)]
                            let aJson = GlobalUtility.shared.json(from: aDict)
                            TALogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: aJson, requestDate: aRequestDate, responseDate: Date())
                        }
                    } else {
                        let aDict = ["Error":NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)]
                        let aJson = GlobalUtility.shared.json(from: aDict)
                        TALogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: aJson, requestDate: aRequestDate, responseDate: Date())
                    }
                    #endif
                    
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                        let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                        
                        // Logout user automatically if He/She has activated session on another device
                        
                        if decodedValue.setting?.success == "-3" {
                            GlobalUtility.hideHud()
                        }
                        
                        if decodedValue.setting?.success == "401" {
                            GlobalUtility.hideHud()
                            UserDefaultsManager.logoutUser()
                            GlobalUtility.redirectToLogin()
                        }
                        
                        if decodedValue.setting?.success == "0" {
                            //GlobalUtility.hideHud()
                            //UserDefaultsManager.logoutUser()
                            //GlobalUtility.redirectToLogin()
                        }

                        
                        completionHandler(decodedValue, nil)
                    } catch _ {
                        completionHandler(nil, .requestError(errorMessage: NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)))
                    }
                } else {
                    completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                }
                
                case .failure(let error):
                    GlobalUtility.hideHud()
                    if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
                        print("Time Out/Connection Lost Error")
                        //self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                        completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                    } else {
                        completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
                    }
                    let pathString = inputRequest.path.replacingOccurrences(of: AppConstants.baseUrl, with: "")
                }
        }
    
    }
    
    static func updateDataRequest<Model: WSResponseData>(with inputRequest: GetRouterProtocol, showHud:Bool = true, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        let aRequestDate = Date()
        let finalParams = [String:Any]()
        print("ROUTER BASE", inputRequest.baseUrlString)
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        print("ROUTER PARAMS", inputRequest.parameters as Any)
        print("ROUTER HEADER", inputRequest.headers as Any)
        
        
        //print(parameters)
        // Serialize to JSON
        if(inputRequest.parameters != nil) {
        if inputRequest.method == .put || inputRequest.method == .delete {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: inputRequest.parameters as Any)
                if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(JSONString)
                }
            } catch {
            }
        }
        }
        
        if !(NetworkReachabilityManager()!.isReachable) {
            let aVC = AppConstants.appDelegate.window?.rootViewController
            aVC?.showTopMessage(message: AlertMessage.InternetError, type: .Error)
            return
        }
        
        if showHud {
            GlobalUtility.showHud()
        }
        
         do {
             _ = try inputRequest.asURLRequest()
         } catch {
             //ProgressHUD.sharedInstance.stopAnimating(randomString)
             completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
             return
         }
        
        manager.request(inputRequest.path, method: inputRequest.method, parameters: inputRequest.parameters, encoding: JSONEncoding.default, headers: inputRequest.headers).responseJSON {
        
          // manager.request(inputRequest.path, method: inputRequest.method,headers: inputRequest.headers).validate().responseJSON {
            response in
            switch (response.result) {
            case .success :
                        
                let request = response.request
                let resp = response.response
                //print(response.response)
                let result = response.result
                let responseString = String(data: response.data!, encoding: .utf8)
                let error = result.error as NSError?
                Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                GlobalUtility.hideHud()
                let finalResponseData: Data? = response.data
            
                if let data = finalResponseData {
                    // let aCode  : String = "\(resp?.statusCode ?? 200)"
                    #if canImport(TALogger)
                    if responseString?.count ?? 0 > 0 {
                        if resp?.statusCode ?? 0 >= 200 && resp?.statusCode ?? 0 <= 299 {
                            TALogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: responseString, requestDate: aRequestDate, responseDate: Date())
                        } else {
                            let aDict = ["Error":NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)]
                            let aJson = GlobalUtility.shared.json(from: aDict)
                            TALogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: aJson, requestDate: aRequestDate, responseDate: Date())
                        }
                    } else {
                        let aDict = ["Error":NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)]
                        let aJson = GlobalUtility.shared.json(from: aDict)
                        TALogger.shared.LogNetwork(url: request?.url?.absoluteString, method: inputRequest.method.rawValue, headers: inputRequest.headers, parameters: finalParams, status:resp?.statusCode ?? error?.code ?? 0, responseBody: aJson, requestDate: aRequestDate, responseDate: Date())
                    }
                    #endif
                    
                    do {
                        let decoder = JSONDecoder()
                        //decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                        let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                        
                        // Logout user automatically if He/She has activated session on another device
                        
                        if decodedValue.setting?.success == "-3" {
                            GlobalUtility.hideHud()
                        }
                        
                        if decodedValue.setting?.success == "401" {
                            GlobalUtility.hideHud()
                            UserDefaultsManager.logoutUser()
                            GlobalUtility.redirectToLogin()
                        }
                        
                        if decodedValue.setting?.success == "0" {
                            //GlobalUtility.hideHud()
                            //UserDefaultsManager.logoutUser()
                            //GlobalUtility.redirectToLogin()
                        }

                        
                        completionHandler(decodedValue, nil)
                    } catch _ {
                        completionHandler(nil, .requestError(errorMessage: NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)))
                    }
                } else {
                    completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                }
                
                case .failure(let error):
                    
                    if error._code == NSURLErrorTimedOut || error._code == NSURLErrorNetworkConnectionLost {
                        print("Time Out/Connection Lost Error")
                        //self.dataRequest(with: inputRequest, completionHandler: completionHandler)
                        completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                    } else {
                        completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
                    }
                    let pathString = inputRequest.path.replacingOccurrences(of: AppConstants.baseUrl, with: "")
                }
        }
    
    }
    
    
    static func generalSettingRequest<Model: WSResponseData>(with inputRequest: GetRouterProtocol, completionHandler: @escaping (WSResponse<Model>?, NetworkError?) -> Void) {
        
        print("ROUTER BASE", inputRequest.baseUrlString)
        //print("ROUTER PARAMETERS", inputRequest.parameters ?? [:])
        print("ROUTER PATH", inputRequest.path)
        print("ROUTER VERB", inputRequest.method)
        
        //ProgressHUD.sharedInstance.startAnimating(randomString)
        do {
            _ = try inputRequest.asURLRequest()
        } catch {
            //ProgressHUD.sharedInstance.stopAnimating(randomString)
            completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
            return
        }
        
        
        manager.request(inputRequest.path, method: inputRequest.method).validate().responseJSON {
           response in
           switch (response.result) {
           case .success :
                       let request = response.request
                       let resp = response.response
                       print(response.response)
                       let result = response.result
                       let responseString = String(data: response.data!, encoding: .utf8)
                       let error = result.error as NSError?
                       Debug.printRequest(request, response: resp, responseString: responseString, error: error)
                       GlobalUtility.hideHud()
                        let finalResponseData: Data? = response.data
                       
                       
                       
                       if let data = finalResponseData {
                           // print("Description")
                           //  print(inputRequest.parameters?.description)
                           
                           do {
                               let decoder = JSONDecoder()
                               //                            decoder.dateDecodingStrategy = .formatted(DateFormatter.customFormat)
                               let decodedValue = try decoder.decode(WSResponse<Model>.self, from: data)
                               
                               // Logout user automatically if He/She has activated session on another device
                               if decodedValue.setting?.success == "-3" {
                                   GlobalUtility.hideHud()
                               }
                               if decodedValue.setting?.success == "401" {
                                   
                                   GlobalUtility.hideHud()
                                   UserDefaultsManager.logoutUser()
                                   GlobalUtility.redirectToLogin()
                                 
                               }
                               completionHandler(decodedValue, nil)
                           } catch _ {
                               completionHandler(nil, .requestError(errorMessage: NetworkService.errorMessageBasedOnStatusCode(resp?.statusCode ?? error?.code ?? 0)))
                           }
                       } else {
                           completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkTimeOutError))
                       }
                       
               case .failure:
                   completionHandler(nil, .requestError(errorMessage: AlertMessage.NetworkError))
               }
        
       }

    }
    
    static func tokenCreationDataRequest(with request: GetRouterProtocol, completionHandler: @escaping (Data?, Error?) -> Void) {
        print("ROUTER BASE", request.baseUrlString)
        //print("ROUTER PARAMETERS", request.parameters ?? [:])
        print("ROUTER PATH", request.path)
        print("ROUTER VERB", request.method)
        //let randomString = ""//ProgressHUD.randomString(length: 10)
        //ProgressHUD.sharedInstance.startAnimating(randomString)
        do {
            _ = try request.asURLRequest()
        } catch let requestError {
            //ProgressHUD.sharedInstance.stopAnimating(randomString)
            completionHandler(nil, requestError)
            return
        }
    
        Alamofire.request(request).responseData(completionHandler: { (response) in
            let request = response.request
            let resp = response.response
            let result = response.result
            let responseString = String(data: response.data!, encoding: .utf8)
            let error = result.error as NSError?
            Debug.printRequest(request, response: resp, responseString: responseString, error: error)
            //ProgressHUD.sharedInstance.stopAnimating(randomString)
            if let data = response.data, AppConstants.enableEncryption {
                //  let strResult = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
                //                let decryptedJson = AESCrypt.decrypt(strResult, password: AppConstants.aesEncryptionKey, isPreviewApp: false)
                //                print(decryptedJson ?? "ERROR")
                //                if let decryptedData = decryptedJson?.data(using: String.Encoding.utf8) {
                //                    completionHandler(decryptedData, response.result.error)
                //                } else {
                completionHandler(data, response.result.error)
                //                }
            } else {
                completionHandler(response.data, response.result.error)
            }
        })
    }
    
    class func errorMessageBasedOnStatusCode(_ code : Int) -> String {
        let afilepath = Bundle.main.path(forResource: "ErrorCode", ofType: "plist")
        var propertyListFormat = PropertyListSerialization.PropertyListFormat.xml //Format of the Property List.
        let plistXML = FileManager.default.contents(atPath: afilepath!)!
        var plistData: [String: Any] = [:] //Our data

        do {//convert the data to a dictionary and handle errors.
            plistData = try PropertyListSerialization.propertyList(from: plistXML, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:Any]
            
            var message = ""
            let aRoot = (plistData["ErrorCode"] as!  [[String : Any]])
            for aObj in aRoot {
                if aObj["Code"] as! Int == code {
                    message = aObj["Message"] as! String
                    break
                }
            }
            return message
        } catch {
            print("error")
        }
        return AlertMessage.defaultError
    }
}
