//
//  UserService.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserService: APIServiceObject {

    func signUp(phone: String, otp: String, pass: String,
                captcha: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.registerMember(msisdn: phone, password: pass,
                                                                      otpCode: otp, captcha: captcha)
        self.serviceAgent.startRequest(request) { (_, error) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func signInOTP(phone: String, otp: String, completion: @escaping((_ refreshToken: String) -> Void), failse: @escaping((_ err: NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.registerSMSOTP(msisdn: phone, otpCode: otp)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(json["refresh_token"].stringValue)
            } else {
                failse(error)
            }
        }
        addToQueue(request)
    }
    
    func getOTP(_ phoneNumber: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getOTPCode(msisdn: phoneNumber)
        self.serviceAgent.startRequest(request) { (_, error) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func getLoginSMSOTP(_ phoneNumber: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getLoginSMSOTPCode(msisdn: phoneNumber)
        self.serviceAgent.startRequestPromotion(request) { (json, error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func receivedLoginSMSOTP() {
        
    }

    func watchTime(id: String, time: Float64, type: ContentType, completion: @escaping((NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.markWatchTime(id: id, time: time, type: type)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
        addToQueue(request)
    }

    func getCaptcha(imeiString: String, completion: @escaping((NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getCaptcha()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(nil)
            } else {
                completion(error)
            }
        }
        addToQueue(request)
    }

    func registerClientId(clientId: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.registerClientId(id: clientId)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }

    func logout(token: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.logoutRequest(token: token)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }

    func changePassword(password: String, newPassword: String,
                        reNewPassword: String, captcha: String, isFromOTP: Bool = false, completion: @escaping((Result<Any>) -> Void) ) {
        let request = APIRequestProvider.shareInstance.changePassword(password: password,
                                                                      newPassword: newPassword,
                                                                      reNewPassword: reNewPassword, captcha: captcha, isFromOTP: isFromOTP)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func checkUserNew(phoneNumber: String, completion: @escaping((Result<Any>) -> Void) ) {
        let request = APIRequestProvider.shareInstance.checkUserNew(phoneNumber: phoneNumber)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let isNewUser = json["isNewUser"].boolValue
                if isNewUser {
                    completion(Result.success(true))
                } else {
                    completion(Result.success(false))
                }
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }

    func mapAccount(msidn: String, otp: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.mapAccount(msidn: msidn, otp: otp)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }

    func performGetProfile(success:((_ detail: MemberDetailModel) -> (Void))?,
                           failse:((_ errMessage: String?) -> (Void))?) {

        let request = APIRequestProvider.shareInstance.getUserProfile()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error != nil {
                if let block = failse {
                    block(error?.localizedDescription)
                }
            } else {
                if let block = success {
                    let dto = MemberDetailDTO(json["user_detail"])
                    let model = MemberDetailModel(dto)
                    block(model)
                }
            }
        }
        addToQueue(request)
    }
    
    func registerPromotionApp(_ completion: @escaping (Result<Any>) -> ()) {
        let request = APIRequestProvider.shareInstance.registerPromotionApp()
        serviceAgent.startRequestPromotion(request, completion: { (json,error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        })
        addToQueue(request)
    }

}
