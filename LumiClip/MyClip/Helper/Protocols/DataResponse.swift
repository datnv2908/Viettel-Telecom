//
//  DataResponse.swift
//  MyClip
//
//  Created by Huy Nguyen on 7/28/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct APIResponse<T> {
    var errorCode: Int
    var message: String
    var newAccessToken: String
    var isShowPromotionAPP: Int
    var isConfirmSms: String
    var content: String
    var number: String
    var data: T
    var paging: Pager?
    var popupEvent: PopupEventModel
    init(_ json: JSON, data: T) {
        errorCode = json["errorCode"].intValue
        message = json["message"].stringValue
        
        self.newAccessToken = ""
        self.isShowPromotionAPP = 0
        self.isConfirmSms = "0";
        self.content = ""
        self.number = ""
        
        paging = Pager(offset: json["offset"].intValue,
                       limit: json["limit"].intValue)
        
        popupEvent = PopupEventModel(message:json["popup"]["message"].stringValue, image: json["popup"]["image"].stringValue)
        
        self.data = data
    }
    init(_ json: JSON, data: T, newAccessToken: String, isShowPromotionAPP: Int, isConfirmSms: String,
         content: String, number: String) {
        errorCode = json["errorCode"].intValue
        message = json["message"].stringValue
        
        self.newAccessToken = newAccessToken;
        self.isShowPromotionAPP = isShowPromotionAPP
        self.isConfirmSms = isConfirmSms;
        self.content = content
        self.number = number
        
        paging = Pager(offset: json["offset"].intValue,
                       limit: json["limit"].intValue)
        
        popupEvent = PopupEventModel(message:json["popup"]["message"].stringValue, image: json["popup"]["image"].stringValue)
        
        self.data = data
    }
}

public struct Pager {
    var offset: Int
    var limit: Int
}
