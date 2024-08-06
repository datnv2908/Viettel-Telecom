//
//  TrailersModel.swift
//  5dmax
//
//  Created by admin on 8/23/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class TrailersModel: NSObject {
    var id: String
    var name: String
    var descriptionTrailer: String
    var coverImage: String
    var slug: String
    
    init(_ model: TrailersDTO) {
        id = model.id
        name = model.name
        descriptionTrailer = model.descriptionTrailer
        coverImage = model.coverImage
        slug = model.slug
    }
}
