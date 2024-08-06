//
//  PopupModel.swift
//  5dmax
//
//  Created by Hoang on 3/28/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PopupModel: NSObject {
    var acceptLossData: Bool
    var isBuyVideo: Bool
    var isBuyPlaylist: Bool
    var isRegisterSub: Bool
    var confirm: String
    var confirmAcceptLostData: String
    var confirmBuyVideo: String
    var confirmBuyPlaylist: String
    var confirmRegisterSub: String
    var packageId: String
    var isConfirmSms: String
    var isRegisterFast: Int
    var contentId: String
    var exceedMaxFreeWatchingTimes : Bool
    override init() {
        acceptLossData = false
        isBuyVideo = false
        isBuyPlaylist = false
        isRegisterSub = false
        confirm = ""
        confirmAcceptLostData = ""
        confirmBuyVideo = ""
        confirmBuyPlaylist = ""
        confirmRegisterSub = ""
        packageId = ""
        isConfirmSms = ""
        isRegisterFast = 0
        contentId = ""
        exceedMaxFreeWatchingTimes = false
    }

    init(_ dto: PopupDTO) {
        acceptLossData = dto.acceptLossData
        isBuyVideo = dto.isBuyVideo
        isBuyPlaylist = dto.isBuyPlaylist
        isRegisterSub = dto.isRegisterSub
        confirm = dto.confirm
        confirmAcceptLostData = dto.confirmAcceptLostData
        confirmBuyVideo = dto.confirmBuyVideo
        confirmBuyPlaylist = dto.confirmBuyPlaylist
        confirmRegisterSub = dto.confirmRegisterSub
        packageId = dto.packageId
        isConfirmSms = dto.isConfirmSMS
        isRegisterFast = dto.isRegisterFast
        contentId = dto.contentId
        exceedMaxFreeWatchingTimes = dto.exceedMaxFreeWatchingTimes
    }
    
    func attributedConfirmMessage(_ confirm: String) -> NSAttributedString {
        var htmlContent: String
        if let path = Bundle.main.path(forResource: "confirm", ofType: "html") {
            htmlContent = try! String.init(contentsOfFile: path, encoding: String.Encoding.utf8)
            htmlContent = String.init(format: htmlContent, confirm)
        } else {
            htmlContent = confirm
        }
        let attrStr = try! NSAttributedString(
            data: htmlContent.data(using: String.Encoding.utf8)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue] as [NSAttributedString.DocumentReadingOptionKey : Any],
            documentAttributes: nil)
        return attrStr
    }
}
