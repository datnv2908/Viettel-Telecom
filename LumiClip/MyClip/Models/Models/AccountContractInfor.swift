//
//  AccountContractInfor.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 9/17/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountContractInfor: NSObject {
    var status: Int
    var isHasVideo: Int
    var msisdn: String
    var idCardCreatedBy: String
    var idCardImageBackSide: String
    var email: String
    var idCardImageFrontSide: String
    var idCardNumber: String
    var name: String
    var idCardCreatedAt: String
    
    override init() {
        status = 0
        isHasVideo = 0
        msisdn = ""
        idCardCreatedBy = ""
        idCardImageBackSide = ""
        email = ""
        idCardImageFrontSide = ""
        idCardNumber = ""
        name = ""
        idCardCreatedAt = ""
    }
    
    init(_ json: JSON) {
        status = json["data"]["status"].intValue
        isHasVideo = json["data"]["isHasVideo"].intValue
        msisdn = json["data"]["msisdn"].stringValue
        idCardCreatedBy = json["data"]["id_card_created_by"].stringValue
        idCardImageBackSide = json["data"]["id_card_image_backside"].stringValue
        email = json["data"]["email"].stringValue
        idCardImageFrontSide = json["data"]["id_card_image_frontside"].stringValue
        idCardNumber = json["data"]["id_card_number"].stringValue
        name = json["data"]["name"].stringValue
        idCardCreatedAt = json["data"]["id_card_created_at"].stringValue
    }
}
