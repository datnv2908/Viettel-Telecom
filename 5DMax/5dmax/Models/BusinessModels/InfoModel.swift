//
//  InfoModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class InfoModel: NSObject {
    var infoId: String
    var name: String
    var type: FilmInfoType
    init(_ dto: InfoDTO) {
        infoId = dto.infoId
        name = dto.name
        type = FilmInfoType(rawValue: dto.type) ?? .actor
    }
}
