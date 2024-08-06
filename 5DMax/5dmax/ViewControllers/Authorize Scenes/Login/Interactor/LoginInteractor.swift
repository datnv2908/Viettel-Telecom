//
//  LoginInteractor.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginInteractor: APIServiceObject {
    let timeLogin = NSDate()
    func performLoginFacebookWithToken(fbToken: String!,
                                       captcha: String!,
                                       refreshToken: String!,
                                       done: (() -> (Void))?,
                                       failse: ((_ err: String?) -> (Void))?) {

        let request = APIRequestProvider.shareInstance.loginRequest(username: "",
                                                                    password: "",
                                                                    grantType: .loginSocial,
                                                                    captcha: captcha,
                                                                    refreshToken: refreshToken,
                                                                    socialToken: fbToken,
                                                                    loginType: LoginType.facebook)
        
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in

            if error != nil {

                if let block = failse {
                    block(error?.localizedDescription)
                }

            } else {

                DLog(json)
                let dto = MemberDTO.init(json)
                let user = MemberModel.init(dto)
                user.loginType = GrantType.loginSocial.stringValue()
                DataManager.saveMemberModel(user)
                DataManager.save(boolValue: true, forKey: Constants.kLoginFacebook)
                if let block = done {
                    block()
                }
            }
        }
    }

    func performLoginWithPhone(phoneNumber: String!,
                               pass: String!,
                               captcha: String!,
                               refreshToken: String!,
                               done: (() -> (Void))?,
                               failse: ((_ err: NSError?) -> (Void))?) {

        let request = APIRequestProvider.shareInstance.loginRequest(username: phoneNumber,
                                                                    password: pass,
                                                                    grantType: .login,
                                                                    captcha: captcha,
                                                                    refreshToken: refreshToken,
                                                                    socialToken: "",
                                                                    loginType: LoginType.email)

        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in

            if error != nil {

                if let block = failse {
                    block(error)
                }

            } else {

                DLog(json)
                let dto = MemberDTO.init(json)
                let user = MemberModel.init(dto)
                user.loginType = GrantType.login.stringValue()
                DataManager.saveMemberModel(user)
                DataManager.saveCurrentTimeLogin(time: self.timeLogin.getCurrentMillis(), key: Constants.time_Expire)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
                
                if let block = done {
                    block()
                }
            }
        }
    }

    func performLogin3G(done: (() -> (Void))?, failse: ((_ err: NSError?) -> (Void))?) {

        let request = APIRequestProvider.shareInstance.loginRequest(username: "",
                                                                    password: "",
                                                                    grantType: .autoLogin,
                                                                    captcha: "",
                                                                    refreshToken: "",
                                                                    socialToken: "",
                                                                    loginType: LoginType.mobile3G)

        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in

            if error != nil {

                if let block = failse {
                    block(error)
                }

            } else {

                DLog(json)
                let dto = MemberDTO.init(json)
                let user = MemberModel.init(dto)
                user.loginType = GrantType.autoLogin.stringValue()
                DataManager.saveMemberModel(user)
                DataManager.saveCurrentTimeLogin(time: self.timeLogin.getCurrentMillis(), key: Constants.time_Expire)
                if let block = done {
                    block()
                }
            }
        }
    }

    func performRefreshAccessToken(done: (() -> (Void))?, failse: ((_ err: NSError?) -> (Void))?) {
        let refreshToken = DataManager.getCurrentMemberModel()?.refressToken
        let request = APIRequestProvider.shareInstance.loginRequest(username: "",
                                                                    password: "",
                                                                    grantType: .refreshToken,
                                                                    captcha: "",
                                                                    refreshToken: refreshToken!,
                                                                    socialToken: "",
                                                                    loginType: LoginType.email)

        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in

            if error != nil {

                if let block = failse {
                    block(error)
                }

            } else {

                DLog(json)
                let dto = MemberDTO.init(json)
                let user = MemberModel.init(dto)
                DataManager.saveMemberModel(user)
//               DataManager.saveCurrentTimeLogin(time: self.timeLogin.getCurrentMillis(), key: Constants.time_Expire)
                if let block = done {
                    block()
                }
            }
        }
    }
    
    func performLoginWithRefreshTokenOTP(refreshToken: String, done: (() -> (Void))?, failse: ((_ err: NSError?) -> (Void))?) {
        let request = APIRequestProvider.shareInstance.loginRequest(username: "",
                                                                    password: "",
                                                                    grantType: .refreshToken,
                                                                    captcha: "",
                                                                    refreshToken: refreshToken,
                                                                    socialToken: "",
                                                                    loginType: LoginType.OTP)
        
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error != nil {
                if let block = failse {
                    block(error)
                }
            } else {
                
                DLog(json)
                let dto = MemberDTO.init(json)
                let user = MemberModel.init(dto)
                DataManager.saveMemberModel(user)
//                DataManager.saveCurrentTimeLogin(time: self.timeLogin.getCurrentMillis(), key: Constants.time_Expire)
                if let block = done {
                    block()
                }
            }
        }
    }
}
extension NSDate {
    func getCurrentMillis()->Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
}
