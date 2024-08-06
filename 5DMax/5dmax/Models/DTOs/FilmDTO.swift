//
//  FilmDTO.swift
//  5dmax
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilmDTO: NSObject {

    /*
     *  parent id = id of film type series
     */
    var parentId: String
    /*
     *  = id of part if type = series
     *  = id of banner if type = banner
     *  = id of film if type = film
     */
    var id: String
    /*
     *  = id of film if parent type = Banner
     */
    var itemId: String
    var name: String
    var desc: String
    var slug: String
    var link: String
    var playTimes: String
    var coverImage: String
    var coverImageH: String
    var coverImageHX: String
    var type: String
    var duration: String
    var durationPercent: Double
    var trailer: Int
    var price: String

    init(_ json: JSON) {
        parentId = json["parentId"].stringValue
        itemId = json["itemId"].stringValue
        id = json["id"].stringValue
        itemId = json["itemId"].stringValue
        name = json["name"].stringValue
        link = json["link"].stringValue
        desc = json["description"].stringValue
        slug = json["slug"].stringValue
        playTimes = json["play_times"].stringValue
        coverImage = json["coverImage"].stringValue
        coverImageH = json["coverImageH"].stringValue
        coverImageHX = json["coverImageHX"].stringValue
        type = json["type"].stringValue
        duration = json["duration"].stringValue
        durationPercent = json["durationPercent"].doubleValue
        trailer = json["trailer"].intValue
        price = json["price_play"].stringValue
    }
}
