//
//  VideoTrailerDTO.swift
//  5dmax
//
//  Created by admin on 8/27/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoTrailerDTO: NSObject {
    var errorCode: Int
    var message: String
    var urlStreaming: String
    var videoId: String
    var traceKey: String
    
    init(_ json: JSON) {
        let streamsJson = json["streams"]
        errorCode       = streamsJson["errorCode"].intValue
        message         = streamsJson["message"].stringValue
        urlStreaming    = streamsJson["urlStreaming"].stringValue
        videoId         = streamsJson["videoId"].stringValue
        traceKey        = streamsJson["traceKey"].stringValue
    }
}
