//
//  StreamDTO.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct StreamDTO {
    var errorCode: Int
    var message: String
    var urlStreaming: String
    var traceKey: String
    var videoId: String
    var popup: PopupDTO?
    var previewImage: String

    init(_ json: JSON) {
        errorCode       = json["errorCode"].intValue
        message         = json["message"].stringValue
        urlStreaming    = json["urlStreaming"].stringValue
        traceKey        = json["traceKey"].stringValue
        videoId         = json["videoId"].stringValue
        previewImage    = json["previewImage"].stringValue
        
        if json["popup"].exists(), json["popup"].isEmpty == false {
            popup = PopupDTO(json["popup"])
        }
    }
}
