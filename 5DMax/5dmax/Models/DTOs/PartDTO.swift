//
//  PartDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class PartDTO: NSObject {

    var partId: String
    var alias: String
    var name: String
    var desc: String
    var coverImage: String
    var duration: Int
    var filmDesc : String
    var index : Int
    init(_ json: JSON) {
        partId = json["id"].stringValue
        alias = json["alias"].stringValue
        name = json["name"].stringValue
        desc = json["description"].stringValue
        coverImage = json["coverImage"].stringValue
        duration = json["duration"].intValue
        filmDesc = json["description"].stringValue
        index = json["index"].intValue
    }

}
