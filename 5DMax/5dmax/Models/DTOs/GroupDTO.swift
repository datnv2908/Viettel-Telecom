//
//  GroupDTO.swift
//  5dmax
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class GroupDTO: NSObject {
    var groupId: String
    var name: String
    var type: String
    var coverImage: String
    var id: String
    var content: [FilmDTO] = []
    var trailer: [TrailersDTO] = []
    
    init(_ json: JSON) {
        groupId = json["id"].stringValue
        name = json["name"].stringValue
        type = json["type"].stringValue
        for (_, subJson) in json["content"] {
            let dto = FilmDTO(subJson)
            content.append(dto)
        }
        
        id = json["id"].stringValue
        coverImage = json["coverImage"].stringValue
    }
}
