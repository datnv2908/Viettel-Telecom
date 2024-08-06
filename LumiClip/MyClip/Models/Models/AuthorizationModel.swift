
//
//  AuthorizationModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AuthorizationModel: NSObject, NSCoding {
    var accessToken: String
    var refressToken: String
    var msisdn: String
    var expiredTime: String
    var needChangePassword: Bool

    init(_ dto: AuthorizationDTO) {
        accessToken = dto.accessToken
        refressToken = dto.refressToken
        msisdn = dto.msisdn
        expiredTime = dto.expiredTime
        needChangePassword = dto.needChangePassword
    }
    
    required init(coder decoder: NSCoder) {
        accessToken = decoder.decodeObject(forKey: "accessToken") as? String ?? ""
        refressToken = decoder.decodeObject(forKey: "refressToken") as? String ?? ""
        msisdn = decoder.decodeObject(forKey: "msisdn") as? String ?? ""
        expiredTime = decoder.decodeObject(forKey: "expiredTime") as? String ?? ""
        needChangePassword = decoder.decodeBool(forKey: "needChangePassword")
        
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(accessToken, forKey: "accessToken")
        coder.encode(refressToken, forKey: "refressToken")
        coder.encode(msisdn, forKey: "msisdn")
        coder.encode(expiredTime, forKey: "expiredTime")
        coder.encode(needChangePassword, forKey: "needChangePassword")
    }
}
