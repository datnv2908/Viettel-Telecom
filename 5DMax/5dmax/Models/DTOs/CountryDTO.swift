//
//  CountryDTO.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountryDTO: NSObject {

    var id: String
    var name: String

    init(_ json: JSON) {
        id      = json["id"].stringValue
        name    = json["name"].stringValue
    }
}
