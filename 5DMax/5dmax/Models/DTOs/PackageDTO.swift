//
//  PackageDTO.swift
//  5dmax
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class PackageDTO: NSObject {

    var packageId: String
    var name: String
    var fee: String
    var cycle: String
    var shortDesciption: String
    var desc: String
    var capacityFree: String
    var status: Bool
    var popup: [String]
    var expiredStr: String

    init(_ json: JSON) {
        packageId   = json["id"].stringValue
        name        = json["name"].stringValue
        fee         = json["fee"].stringValue
        shortDesciption = json["short_description"].stringValue
        desc        = json["description"].stringValue
        status      = json["status"].boolValue
        expiredStr  = json["expiredStr"].stringValue
        cycle       = json["cycle"].stringValue
    

        if let capacity = json["capacity_free"].string {
            capacityFree = capacity
        } else {
            capacityFree = ""
        }

        popup = []
        for (_, subJson) in json["popup"] {
            popup.append(subJson.stringValue)
        }
    }
}
