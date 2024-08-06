//
//  HtmlContentDTO.swift
//  5dmax
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class HtmlContentDTO: NSObject {

    var type: String
    var content: String

    init(_ json: JSON) {
        type = json["type"].stringValue
        content = json["content"].stringValue
    }
}
