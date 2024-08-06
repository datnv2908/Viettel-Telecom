//
//  PopupDTO.swift
//  5dmax
//
//  Created by Hoang on 3/28/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class PopupDTO: NSObject {

    var confirm: String
    var isBuyVideo: Bool
    var confirmRegisterSub: String
    var confirmBuyPlaylist: String
    var isBuyPlaylist: Bool
    var isRegisterSub: Bool
    var packageId: String
    var isConfirmSMS: Bool
    var isRegisterFast: Bool
    var canView: Bool
    var isEverBuyPlaylist: Bool
    var is_new_sub: Bool
    var is_temp_sub: Bool

    init(_ json: JSON) {
        confirm               = json["confirm"].stringValue
        isBuyVideo            = json["is_buy_video"].boolValue
        confirmRegisterSub    = json["confirm_register_sub"].stringValue
        confirmBuyPlaylist    = json["confirm_buy_playlist"].stringValue
        isBuyPlaylist         = json["is_buy_playlist"].boolValue
        isRegisterSub         = json["is_register_sub"].boolValue
        packageId             = json["package_id"].stringValue
        isConfirmSMS          = json["is_confirm_sms"].boolValue
        isRegisterFast        = json["is_register_fast"].boolValue
        canView               = json["canView"].boolValue
        
        isEverBuyPlaylist     = false
        isEverBuyPlaylist     = json["isEverBuyPlaylist"].boolValue
        
        is_new_sub            = false
        is_new_sub            = json["is_new_sub"].boolValue
        
        is_temp_sub           = false
        is_temp_sub           = json["is_temp_sub"].boolValue
    }
}
