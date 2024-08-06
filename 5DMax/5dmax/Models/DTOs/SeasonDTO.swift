//
//  SeasonDTO.swift
//  5dmax
//
//  Created by Toan on 5/26/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class SeasonDTO: NSObject {
    var parentId : Int
    var id : Int
    var name : String
    var index : Int
    init(_ json: JSON) {
        self.parentId =  json["parent_id"].intValue
        self.id =  json["id"].intValue
        self.name = json ["name"].stringValue
        self.index = json ["index"].intValue
    }
    init(_ dto: SeasonDTO) {
        parentId = dto.parentId
        id = dto.id
        name = dto.name
        index = dto.index
    }
}
