//
//  MemberModel.swift
//  MyClip
//
//  Created by Hoang on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class MemberModel: NSObject, NSCoding {
    var avatarImage: String
    var accessToken: String
    var expiredTime: Int
    var isUpdateApp: Bool
    var msisdn: String
    var isForceUpdateApp: Bool
    var refreshToken: String
    var fullName: String
    var needShowMapAccount: Bool
    var isShowSuggestTopic: Bool
    var needChangePassword: Bool
    var desc: String
    var coverImage: String
    var userId: String
    var notify_comment: String
    var firstTimeLoginAPP: Int
    var isShowPromotionAPP: Int
    var status: Int?
    var isUpLoad : Int?
    var reason :String
   var themeUser : Int?
    init(_ dto: MemberDTO) {
        avatarImage = dto.avatarImage
        accessToken = dto.accessToken
        expiredTime = dto.expiredTime
        isUpdateApp = dto.isUpdateApp
        msisdn = dto.msisdn
        isForceUpdateApp = dto.isForceUpdateApp
        refreshToken = dto.refreshToken
        fullName = dto.fullName
        needShowMapAccount = dto.needShowMapAccount
        isShowSuggestTopic = dto.isShowSuggestTopic
        needChangePassword = dto.needChangePassword
        desc = dto.desc
        coverImage = dto.coverImage
        userId = dto.userId
        notify_comment = dto.notify_comment
        firstTimeLoginAPP = dto.firstTimeLoginAPP
        isShowPromotionAPP = dto.isShowPromotionAPP
        status = dto.status
        isUpLoad = dto.isUpLoad
        reason = dto.reason
      themeUser = dto.themeUser
    }

    required init(coder decoder: NSCoder) {
        avatarImage = decoder.decodeObject(forKey: "avatarImage") as? String ?? ""
        accessToken = decoder.decodeObject(forKey: "accessToken") as? String ?? ""
        expiredTime = decoder.decodeObject(forKey: "expiredTime") as? Int ?? 0
        isUpdateApp = decoder.decodeBool(forKey: "isUpdateApp")
        msisdn = decoder.decodeObject(forKey: "msisdn") as? String ?? ""
        isForceUpdateApp = decoder.decodeBool(forKey: "isForceUpdateApp")
        refreshToken = decoder.decodeObject(forKey: "refreshToken") as? String ?? ""
        fullName = decoder.decodeObject(forKey: "fullName") as? String ?? ""
        needShowMapAccount = decoder.decodeBool(forKey: "needShowMapAccount")
        isShowSuggestTopic = decoder.decodeBool(forKey: "isShowSuggestTopic")
        needChangePassword = decoder.decodeBool(forKey: "needChangePassword")
        desc = (decoder.decodeObject(forKey: "desc") ?? decoder.decodeObject(forKey: "descriptionChannel")) as? String ?? ""
        coverImage = decoder.decodeObject(forKey: "coverImage") as? String ?? ""
        userId = decoder.decodeObject(forKey: "userId") as? String ?? ""
        notify_comment = decoder.decodeObject(forKey: "notify_comment") as? String ?? ""
        firstTimeLoginAPP = decoder.decodeInteger(forKey: "firstTimeLoginAPP")
        isShowPromotionAPP = decoder.decodeInteger(forKey: "isShowPromotionAPP")
        status = decoder.decodeObject(forKey: "status") as? Int
        isUpLoad = decoder.decodeObject(forKey: "isUpLoad") as? Int
        reason = decoder.decodeObject(forKey: "reason") as? String ?? ""
        themeUser = decoder.decodeObject(forKey: "theme") as? Int
    }

    func encode(with coder: NSCoder) {
        coder.encode(avatarImage, forKey: "avatarImage")
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(expiredTime, forKey: "expiredTime")
        coder.encode(isUpdateApp, forKey: "isUpdateApp")
        coder.encode(msisdn, forKey: "msisdn")
        coder.encode(isForceUpdateApp, forKey: "isForceUpdateApp")
        coder.encode(refreshToken, forKey: "refreshToken")
        coder.encode(fullName, forKey: "fullName")
        coder.encode(needShowMapAccount, forKey: "needShowMapAccount")
        coder.encode(isShowSuggestTopic, forKey: "isShowSuggestTopic")
        coder.encode(needChangePassword, forKey: "needChangePassword")
        coder.encode(desc, forKey: "desc")
        coder.encode(coverImage, forKey: "coverImage")
        coder.encode(userId, forKey: "userId")
        coder.encode(notify_comment, forKey: "notify_comment")
        coder.encode(firstTimeLoginAPP, forKey: "firstTimeLoginAPP")
        coder.encode(isShowPromotionAPP, forKey: "isShowPromotionAPP")
        coder.encode(status, forKey: "status")
        coder.encode(isUpLoad, forKey: "isUpLoad")
        coder.encode(reason, forKey: "reason")
        coder.encode(themeUser, forKey: "theme")
    }

    func getName() -> String {
        if fullName.isEmpty {
            return msisdn
        }
        return fullName
    }
}
