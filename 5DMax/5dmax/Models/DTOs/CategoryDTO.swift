//
//  categoryDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryDTO: NSObject {
    var categoryId: String
    var name: String
    var type: String
    var getMoreContentId: String

    init(_ json: JSON) {
        categoryId = json["id"].stringValue
        name = json["name"].stringValue
        if let contentType = json["type"].string {
            type = contentType
        } else {
            type = ""
        }
        if let contentId = json["getMoreContentId"].string {
            getMoreContentId = contentId
        } else {
            getMoreContentId = ""
        }
    }
}
