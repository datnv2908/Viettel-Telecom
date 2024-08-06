//
//  StreamModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct StreamModel {
    var errorCode: APIErrorCode
    var message: String
    var urlStreaming: String
    var traceKey: String
    var videoId: String
    var popup: PopupModel?
    var previewImage: String

    init(_ dto: StreamDTO) {
        errorCode       = APIErrorCode(rawValue: dto.errorCode) ?? .unknow
        message         = dto.message
        urlStreaming    = dto.urlStreaming
        traceKey        = dto.traceKey
        videoId         = dto.videoId
        previewImage    = dto.previewImage
        
        if let popupDTO = dto.popup {
            popup = PopupModel(popupDTO)
        }
    }
}
