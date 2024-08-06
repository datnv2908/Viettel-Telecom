//
//  APIServiceAgent.swift
//  MyClip
//
//  Created by Huy Nguyen on 1/4/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CFNetwork

/*
 *  APIServiceAgent takes responsible for 
 *  - Convert DataResponse<Any> to JSON object
 *  - Detect and handle application errors such as: token expired, version not support...
 */
class APIServiceAgent: NSObject {
    /*
     *  perform request
     *  param:
     *  - request: DataRequest
     *  - completion block (JSON, NSError?)
     */
    var retryTimes = 3
    func startRequest(_ request: DataRequest, completion: @escaping(JSON, NSError?) -> Void) {
        let startCallAPI = Date()
        request
            .validate()
            .responseJSON { (_ response: DataResponse<Any>) in
                print(request.debugDescription)
                let finishCallAPI = Date()
                Singleton.sharedInstance.totalAPICallDuration = Singleton.sharedInstance.totalAPICallDuration + finishCallAPI.timeIntervalSince(startCallAPI)
                Singleton.sharedInstance.totalAPICallTimes = Singleton.sharedInstance.totalAPICallTimes + 1
                switch response.result {
                case .success:
                    Singleton.sharedInstance.totalAPISuccess = Singleton.sharedInstance.totalAPISuccess + 1
                    
                    let json            = JSON(response.result.value!)
                    let message         = json["message"].stringValue
                    let responseCode    = json["responseCode"].intValue
                    print(json)
                    if responseCode == APIErrorCode.success.rawValue {
                        completion(json as JSON, nil)
                    } else if responseCode == APIErrorCode.requireLogin.rawValue {
                        let error = NSError.errorWith(code: responseCode, message: message)
                        // clear login session & ask user to login again
                        DataManager.clearLoginSession()
                        completion(json, error)
                    }
                    else if responseCode == APIErrorCode.refreshToken.rawValue {
                        if DataManager.isLoggedIn() {
                            self.retryTimes = self.retryTimes - 1
                            if self.retryTimes <= 0 {
                                let error = NSError.errorWith(code: responseCode, message: message)
                                completion(json, error)
                            } else {
                                let userService = UserService()
                                userService.authorize(type: .refreshToken,
                                                      username: nil,
                                                      password: nil,
                                                      captcha: nil,
                                                      accessToken: nil,
                                                      completion: { (result) -> (Void) in
                                                        switch result {
                                                        case .success(_):
                                                            // refresh token success => retry the previous request
                                                            var originalRequest = request.request
                                                            originalRequest?.allHTTPHeaderFields = APIRequestProvider.shareInstance.headers
                                                            let newRequest = Alamofire.request(originalRequest!)
                                                            self.startRequest(newRequest, completion: completion)
                                                        case .failure(let error):
                                                            DataManager.clearLoginSession()
                                                            completion(json, error as NSError)
                                                        }
                                })
                            }
                        } else {
                            let error = NSError.errorWith(code: responseCode, message: message)
                            completion(json, error)
                        }
                    }
                    else {
                        let error = NSError.errorWith(code: responseCode, message: message)
                        completion(json, error)
                    }
                    break
                case .failure(let error as NSError):
                    if error.code == NSURLErrorNotConnectedToInternet ||
                        error.code == NSURLErrorNetworkConnectionLost {
                        let error = NSError.errorWith(code: error.code,
                                                      message: String.internetConnectionLost)
                        completion(JSON.null, error)
                    } else if error.code == NSURLErrorCancelled {
                        Singleton.sharedInstance.totalAPIError = Singleton.sharedInstance.totalAPIError + 1
                        completion(JSON.null, NSError.errorWith(code: error.code, message: ""))
                    } else {
                        Singleton.sharedInstance.totalAPIError = Singleton.sharedInstance.totalAPIError + 1
                        completion(JSON.null, error)
                    }
                    break
                default:
                    break
                }
        }
    }
}
