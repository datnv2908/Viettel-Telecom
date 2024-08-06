//
//  PartModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class SeriModel: NSObject {
    var descSeri : String
    var parts = [PartModel]()
    init(_ json : JSON) {
        for subJson in json["parts"].arrayValue {
            let modelOTD = PartDTO(subJson)
            let model = PartModel(modelOTD)
            self.parts.append(model)
        }
        descSeri = json["description"]["description"].stringValue
    }
}
class PartModel: NSObject {
    var partId: String
    var alias: String
    var name: String
    var desc: String
    var coverImage: String
    var duration: Int
    var filmDesc : String
    var index : Int
    init(_ dto: PartDTO) {
        partId = dto.partId
        alias = dto.alias
        name = dto.name
        desc = dto.desc
        coverImage = dto.coverImage
        duration = dto.duration
        filmDesc = dto.filmDesc
        index = dto.index
    }
}
