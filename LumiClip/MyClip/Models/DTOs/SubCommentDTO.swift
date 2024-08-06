



//
//  SubCommentDTO.swift
//  MyClip
//
//  Created by Os on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class SubCommentDTO: NSObject {
    var id: String
    var content: String
    var name: String
    var likeCount: Int
    var createdAt: String
    
    init(_ json: JSON) {
        id              = json["id"].stringValue
        content         = json["content"].stringValue
        name            = json["name"].stringValue
        likeCount       = json["likeCount"].intValue
        createdAt       = json["createdAt"].stringValue
    }
}
