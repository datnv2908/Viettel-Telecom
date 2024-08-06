//
//  VideoDetailDTO.swift
//  MyClip
//
//  Created by Os on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoDetailDTO: NSObject {
    var detail: DetailDTO
    var streams: StreamsDTO
    var relates: GroupDTO
    var playlist: GroupDTO
    var nextId: String
    var previousId: String
    
    init(_ json: JSON) {
        detail          = DetailDTO(json["detail"])
        streams         = StreamsDTO(json["streams"])
        relates         = GroupDTO(json["relateds"])
        playlist         = GroupDTO(json["videoOfPlaylist"])
        nextId          = json["nextId"].stringValue
        previousId      = json["previousId"].stringValue
    }
}
