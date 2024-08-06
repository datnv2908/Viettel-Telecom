
//
//  BannerModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class BannerModel: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var type: String
    var itemId: String
    var link: String
    
    init(_ dto: BannerDTO) {
        id = dto.id
        name = dto.name
        desc = dto.desc
        coverImage = dto.coverImage
        type = dto.type
        itemId = dto.itemId
        link = dto.link
    }
}
