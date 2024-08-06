


//
//  AuthorizationDTO.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class AuthorizationDTO: NSObject {
    var accessToken: String
    var refressToken: String
    var msisdn: String
    var expiredTime: String
    var needChangePassword: Bool
    
    init(_ json: JSON) {
        accessToken                 = json["accessToken"].stringValue
        refressToken                = json["refressToken"].stringValue
        msisdn                      = json["msisdn"].stringValue
        expiredTime                 = json["expiredTime"].stringValue
        needChangePassword          = json["needChangePassword"].boolValue
    }
}
