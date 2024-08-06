//
//  VideoTrailerModel.swift
//  5dmax
//
//  Created by admin on 8/27/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class VideoTrailerModel: NSObject {
    var errorCode: Int
    var message: String
    var urlStreaming: String
    var videoId: String
    var traceKey: String
    
    init(_ dto: VideoTrailerDTO) {
        errorCode = dto.errorCode
        message = dto.message
        urlStreaming = dto.urlStreaming
        videoId = dto.videoId
        traceKey = dto.traceKey
    }
}

