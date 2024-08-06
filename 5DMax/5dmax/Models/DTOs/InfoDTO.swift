//
//  InfoDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class InfoDTO: NSObject {

    var infoId: String
    var name: String
    var type: Int

    init(_ json: JSON) {
        infoId = json["id"].stringValue
        name = json["name"].stringValue
        type = json["type"].intValue
    }
}
