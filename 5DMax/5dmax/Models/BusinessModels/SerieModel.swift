//
//  SerieModel.swift
//  5dmax
//
//  Created by Toan on 7/15/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class ContentSeries : NSObject {
    var yearOfProduct : String
    var duration : String
    var coverImageHX : String
    var pricePlay : String
    var imageForTVLarge : String
    var type : String
    var coverImageHLarge :String
    var imdb : String
    var contentFilter : String
    var playTimes  : String
    var desc : String
    var id : Int
    var coverImageLarge :String
    var trailer : String
    var attributes : String
    var slug: String
    var extraDescription : String
    var coverImage : String
    var isDrm : String
    var name : String
    var coverImageH: String
    var awards : String
    init(_ json : JSON) {
        self.yearOfProduct = json["year_of_product"].stringValue
        self.duration = json["duration"].stringValue
        self.coverImageHX = json["coverImageHX"].stringValue
        self.pricePlay = json["price_play"].stringValue
        self.imageForTVLarge = json["imageForTVLarge"].stringValue
        self.type = json["type"].stringValue
        self.coverImageHLarge = json["coverImageHLarge"].stringValue
        self.imdb = json["imdb"].stringValue
        self.contentFilter = json["content_filter"].stringValue
        self.playTimes = json["play_times"].stringValue
        self.desc = json["description"].stringValue
        self.id = json["id"].intValue
        self.coverImageLarge = json["coverImageLarge"].stringValue
        self.trailer = json["trailer"].stringValue
        self.attributes = json["attributes"].stringValue
        self.slug = json["slug"].stringValue
        self.extraDescription = json["extra_description"].stringValue
        self.coverImage = json["coverImage"].stringValue
        self.isDrm = json["is_drm"].stringValue
        self.name = json["name"].stringValue
        self.coverImageH = json["coverImageH"].stringValue
        self.awards = json["awards"].stringValue
    }
}
class SeriesModel: NSObject {
    var id :  String
    var name : String
    var serries = [FilmModel]()
    init(_ json : JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        for item in json["content"].arrayValue{
             let model = FilmModel(FilmDTO(item))
            serries.append(model)
        }
    }
}
