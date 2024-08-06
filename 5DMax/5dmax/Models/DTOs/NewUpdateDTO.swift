//
//  NewUpdateDTO.swift
//  5dmax
//
//  Created by admin on 10/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewUpdateDTO: NSObject {
    var id: Int
    var name: String
    var slug: String
    var content: [FilmDTO] = []
    
    init(_ json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        slug = json["slug"].stringValue
        
        for (_, subJson) in json["content"] {
            let dto = FilmDTO(subJson)
            content.append(dto)
        }
    }
}
