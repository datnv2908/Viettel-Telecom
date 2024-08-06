//
//  ContractInfor.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 9/20/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class ContractInfor: NSObject {
    var id: Int
    var userId: Int
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
    var reason: String
    var taxCode: String
    var accountNumber: String
    var paymentType: String
    var msisdnPay: String
    var bankName: String
    var bankDepartment: String
    var address: String
    var condition: String
    
    override init() {
        id = 0
        userId = 0
        status = -1
        isHasVideo = 0
        msisdn = ""
        idCardCreatedBy = ""
        idCardImageBackSide = ""
        email = ""
        idCardImageFrontSide = ""
        idCardNumber = ""
        name = ""
        idCardCreatedAt = ""
        reason = ""
        taxCode = ""
        accountNumber = ""
        paymentType = ""
        msisdnPay = ""
        bankName = ""
        bankDepartment = ""
        address = ""
        condition = ""
    }
    
    init(_ json: JSON) {
        id = json["data"]["contract"]["id"].intValue
        userId = json["data"]["contract"]["user_id"].intValue
        status = json["data"]["contract"]["status"].intValue
        isHasVideo = json["data"]["contract"]["isHasVideo"].intValue
        msisdn = json["data"]["contract"]["msisdn"].stringValue
        idCardCreatedBy = json["data"]["contract"]["id_card_created_by"].stringValue
        idCardImageBackSide = json["data"]["contract"]["card_image_backside"].stringValue
        email = json["data"]["contract"]["email"].stringValue
        idCardImageFrontSide = json["data"]["contract"]["card_image_frontside"].stringValue
        idCardNumber = json["data"]["contract"]["id_card_number"].stringValue
        name = json["data"]["contract"]["name"].stringValue
        idCardCreatedAt = json["data"]["contract"]["id_card_created_at"].stringValue
        reason = json["data"]["contract"]["reason"].stringValue
        taxCode = json["data"]["contract"]["tax_code"].stringValue
        accountNumber = json["data"]["contract"]["account_number"].stringValue
        paymentType = json["data"]["contract"]["payment_type"].stringValue
        msisdnPay = json["data"]["contract"]["msisdn_pay"].stringValue
        bankName = json["data"]["contract"]["bank_name"].stringValue
        bankDepartment = json["data"]["contract"]["bank_department"].stringValue
        address = json["data"]["contract"]["address"].stringValue
        condition = json["data"]["condition"].stringValue
    }
}
