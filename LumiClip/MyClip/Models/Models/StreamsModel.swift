//
//  StreamsModel.swift
//  MyClip
//
//  Created by Os on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class StreamsModel: NSObject {
    var errorCode: APIErrorCode
    var message: String
    var urlStreaming: String
    var popup: PopupModel
    
    init(_ dto: StreamsDTO) {
        errorCode = APIErrorCode(rawValue: dto.errorCode) ?? .unknow
        message = dto.message
        urlStreaming = dto.urlStreaming
        popup = PopupModel(dto.popup)
    }

    init(download model: DownloadModel) {
        errorCode = .success
        message = ""
        urlStreaming = model.localFilePath()
        popup = PopupModel()
    }
}
