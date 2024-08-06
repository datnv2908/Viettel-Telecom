//
//  PopupModel.swift
//  5dmax
//
//  Created by Hoang on 3/28/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PopupModel: NSObject {

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

    init(_ dto: PopupDTO) {
        confirm               = dto.confirm
        isBuyVideo            = dto.isBuyVideo
        confirmRegisterSub    = dto.confirmRegisterSub
        confirmBuyPlaylist    = dto.confirmBuyPlaylist
        isBuyPlaylist         = dto.isBuyPlaylist
        isRegisterSub         = dto.isRegisterSub
        packageId             = dto.packageId
        isConfirmSMS          = dto.isConfirmSMS
        isRegisterFast        = dto.isRegisterFast
        canView               = dto.canView
        
        isEverBuyPlaylist     = false
        isEverBuyPlaylist     = dto.isEverBuyPlaylist
        
        is_new_sub            = false
        is_new_sub            = dto.is_new_sub
        
        is_temp_sub           = false
        is_temp_sub           = dto.is_temp_sub
    }
}
