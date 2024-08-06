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

    var acceptLossData: Bool
    var isBuyVideo: Bool
    var isBuyPlaylist: Bool
    var isRegisterSub: Bool
    
    var confirm: String
    
    var confirmAcceptLostData: String
    var confirmBuyVideo: String
    var confirmBuyPlaylist: String
    var confirmRegisterSub: String
    var isConfirmSMS: String
    var isRegisterFast: Int
    var exceedMaxFreeWatchingTimes : Bool
    var packageId: String
    var contentId: String

    init(_ json: JSON) {
        acceptLossData        = json["accept_loss_data"].boolValue
        isBuyVideo            = json["is_buy_video"].boolValue
        isBuyPlaylist         = json["is_buy_playlist"].boolValue
        isRegisterSub         = json["is_register_sub"].boolValue
        
        confirm               = json["confirm"].stringValue
        
        confirmAcceptLostData = json["confirm_accept_loss_data"].stringValue
        confirmBuyVideo       = json["confirm_buy_video"].stringValue
        confirmRegisterSub    = json["confirm_register_sub"].stringValue
        confirmBuyPlaylist    = json["confirm_buy_playlist"].stringValue
        isConfirmSMS          = json["is_confirm_sms"].stringValue
        isRegisterFast        = json["is_register_fast"].intValue
        packageId             = json["package_id"].stringValue
        contentId             = json["content_id"].stringValue
      exceedMaxFreeWatchingTimes = json["exceedMaxFreeWatchingTimes"].boolValue
    }
}
