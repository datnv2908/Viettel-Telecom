//
//  StreamsDTO.swift
//  MyClip
//
//  Created by Os on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class StreamsDTO: NSObject {
    var errorCode: Int
    var message: String
    var urlStreaming: String
    var popup: PopupDTO
    
    init(_ json: JSON) {
        errorCode           = json["errorCode"].intValue
        message             = json["message"].stringValue
        urlStreaming        = json["urlStreaming"].stringValue
        popup = PopupDTO(json["popup"])
    }
}
