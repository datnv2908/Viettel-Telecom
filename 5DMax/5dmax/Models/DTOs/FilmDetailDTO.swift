//
//  FilmDetailDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilmDetailDTO: NSObject {

    var filmId: String
    var name: String
    var desc: String
    var type: String
    var avatarImage: String
    var avatarImageH: String
    var link: String
    var slug: String
    var isFavourite: Bool
    var playTimes: String
    var yearOfProduct: String
    var imdb: String
    var duration: String
    var attributes: String
    var contentFilter: String
    var infos: [InfoDTO]
    var currentVideoId: String
    var coverImage: String
    var categories: [CategoryDTO]
    var drmContent: String?
    var subscription_type: Int
    var country: String
    var priceFull: String
    var buyStatusText: String
    var extra_description: String
    
    init(_ json: JSON) {
        filmId = json["id"].stringValue
        name = json["name"].stringValue
        desc = json["description"].stringValue
        type = json["type"].stringValue
        avatarImage = json["avatarImage"].stringValue
        avatarImageH = json["avatarImageH"].stringValue
        link = json["link"].stringValue
        slug = json["slug"].stringValue
        isFavourite = json["isFavourite"].boolValue
        playTimes = json["play_times"].stringValue
        yearOfProduct = json["year_of_product"].stringValue
        imdb = json["imdb"].stringValue
        duration = json["duration"].stringValue
        attributes = json["attributes"].stringValue
        contentFilter = json["content_filter"].stringValue
        currentVideoId = json["currentVideoId"].stringValue
        coverImage = json["coverImage"].stringValue
        subscription_type = json["subscription_type"].intValue
        infos = []
        for (_, subJson) in json["infos"] {
            infos.append(InfoDTO(subJson))
        }
        categories = []
        for (_, subJson) in json["categories"] {
            categories.append(CategoryDTO(subJson))
        }
        priceFull = json["price_play"].stringValue
        drmContent = json["drm_content_id"].string
        country = json["country"].stringValue
        buyStatusText = json["buyStatusText"].stringValue
        extra_description = json["extra_description"].stringValue
    }
}
