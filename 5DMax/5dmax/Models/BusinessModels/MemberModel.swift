//
//  MemberModel.swift
//  5dmax
//
//  Created by Hoang on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MemberModel: NSObject, NSCoding {

    var accessToken: String
    var refressToken: String
    var fullname: String
    var msisdn: String
    var userId: Int
    var expiredTime: Int
    var isShowSuggestTopic: Bool
    var needShowMapAccount: Bool
    var isForceUpdateAPP: Bool
    var isUpdateAPP: Bool
    var needChangePassword: Bool
    var loginType: String
    var volume: Float
    var firstTimeLoginAPP: Int
    var isShowPromotionAPP: Int

    init(_ dto: MemberDTO) {

        accessToken         = dto.accessToken
        refressToken        = dto.refressToken
        fullname            = dto.fullname
        msisdn              = dto.msisdn
        userId              = dto.userId
        expiredTime         = dto.expiredTime
        isShowSuggestTopic  = Bool(dto.isShowSuggestTopic as NSNumber)
        needShowMapAccount  = Bool(dto.needShowMapAccount as NSNumber)
        isForceUpdateAPP    = Bool(dto.isForceUpdateAPP as NSNumber)
        isUpdateAPP         = Bool(dto.isUpdateAPP as NSNumber)
        needChangePassword  = dto.needChangePassword
        loginType           = ""
        volume              = 1.0
        firstTimeLoginAPP   = dto.firstTimeLoginAPP
        isShowPromotionAPP  = dto.isShowPromotionAPP
    }

    required init(coder decoder: NSCoder) {
        accessToken         = decoder.decodeObject(forKey: "accessToken") as? String ?? ""
        refressToken        = decoder.decodeObject(forKey: "refressToken") as? String ?? ""
        fullname            = decoder.decodeObject(forKey: "fullname") as? String ?? ""
        msisdn              = decoder.decodeObject(forKey: "msisdn") as? String ?? ""
        userId              = decoder.decodeInteger(forKey: "userId")
        expiredTime         = decoder.decodeInteger(forKey: "expiredTime")
        isShowSuggestTopic  = decoder.decodeBool(forKey: "isShowSuggestTopic")
        needShowMapAccount  = decoder.decodeBool(forKey: "needShowMapAccount")
        isForceUpdateAPP    = decoder.decodeBool(forKey: "isForceUpdateAPP")
        isUpdateAPP         = decoder.decodeBool(forKey: "isUpdateAPP")
        needChangePassword  = decoder.decodeBool(forKey: "needChangePassword")
        loginType           = decoder.decodeObject(forKey: "loginType") as? String ?? ""
        volume              = decoder.decodeFloat(forKey: "volume")
        firstTimeLoginAPP   = decoder.decodeInteger(forKey: "firstTimeLoginAPP")
        isShowPromotionAPP  = decoder.decodeInteger(forKey: "isShowPromotionAPP")
    }

    func encode(with coder: NSCoder) {
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(refressToken, forKey: "refressToken")
        coder.encode(fullname, forKey: "fullname")
        coder.encode(msisdn, forKey: "msisdn")
        coder.encode(userId, forKey: "userId")
        coder.encode(expiredTime, forKey: "expiredTime")
        coder.encode(isShowSuggestTopic, forKey: "isShowSuggestTopic")
        coder.encode(needShowMapAccount, forKey: "needShowMapAccount")
        coder.encode(isForceUpdateAPP, forKey: "isForceUpdateAPP")
        coder.encode(isUpdateAPP, forKey: "isUpdateAPP")
        coder.encode(needChangePassword, forKey: "needChangePassword")
        coder.encode(loginType, forKey: "loginType")
        coder.encode(volume, forKey: "volume")
        coder.encode(firstTimeLoginAPP, forKey: "firstTimeLoginAPP")
        coder.encode(isShowPromotionAPP, forKey: "isShowPromotionAPP")
    }

    func getName() -> String {
        if msisdn.isEmpty {
            return fullname
        } else {
            return msisdn
        }
    }
}
