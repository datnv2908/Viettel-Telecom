
//
//  SearchGroupDTO.swift
//  MyClip
//
//  Created by Os on 9/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchGroupDTO: NSObject {
    var id: String
    var name: String
    var type: String
    var contents: [ContentDTO]
    
    init(_ json: JSON) {
        id              = json["id"].stringValue
        name            = json["name"].stringValue
        type            = json["type"].stringValue
        contents = []
        for (_, subJson) in json["content"] {
            let dto = ContentDTO(subJson)
            contents.append(dto)
        }
    }
}
