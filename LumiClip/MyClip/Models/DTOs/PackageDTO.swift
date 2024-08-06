//
//  PackageDTO.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/18/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class PackageDTO: NSObject {
    var id: String
    var name: String
    var desc: String
    var shortDesc: String
    var popup: [String]
    var fee: Int
    var status: Int
    
    init(_ json: JSON) {
        id          = json["id"].stringValue
        name        = json["name"].stringValue
        desc        = json["description"].stringValue
        shortDesc   = json["short_description"].stringValue
        popup       = json["popup"].arrayObject as! [String]
        fee         = json["fee"].intValue
        status      = json["status"].intValue
    }
}
