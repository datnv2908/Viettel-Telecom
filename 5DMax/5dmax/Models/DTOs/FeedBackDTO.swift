//
//  FeedBackDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedBackDTO: NSObject {

    var id: String
    var content: String

    init(_ json: JSON) {
        id = json["id"].stringValue
        content = json["content"].stringValue
    }
}
