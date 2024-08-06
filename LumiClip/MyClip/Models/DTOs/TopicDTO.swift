//
//  TopicDTO.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class TopicDTO: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var type: String
    var itemId: String
    
    init(_ json: JSON) {
        id              = json["id"].stringValue
        name            = json["name"].stringValue
        desc            = json["description"].stringValue
        coverImage      = json["coverImage"].stringValue
        type            = json["type"].stringValue
        itemId          = json["item_id"].stringValue
    }
}
