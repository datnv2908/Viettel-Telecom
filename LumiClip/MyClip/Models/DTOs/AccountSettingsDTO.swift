//
//  AccountSettingsDTO.swift
//  MyClip
//
//  Created by sunado on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class QualityVideoDTO: NSObject {
    var name: String
    var vod_profile_id: Int
    var live_profile_id: Int
    
    init(_ json: JSON) {
        name            = json["name"].stringValue
        vod_profile_id  = json["vod_profile_id"].intValue
        live_profile_id = json["live_profile_id"].intValue
    }
}

class FeedBackDTO: NSObject {
    var id: String
    var content: String
    
    init(_ json: JSON) {
        id      = json["id"].stringValue
        content = json["content"].stringValue
    }
}

class HtmlContentDTO: NSObject {
    var type: String
    var content: String
    
    init(_ json: JSON) {
        type     = json["type"].stringValue
        content  = json["content"].stringValue
    }
}

//class CategoryDTO: NSObject {
//    var id: Int
//    var name: String
//    var type: String
//    var getMoreContentId: String
//    var filter_type: String
//
//    init(_ json: JSON) {
//        id               = json["id"].intValue
//        name             = json["name"].stringValue
//        type             = json["type"].stringValue
//        getMoreContentId = json["getMoreContentId"].stringValue
//        filter_type      = json["filter_type"].stringValue
//    }
//}

class AccountSettingsDTO: NSObject {
    var qualities: [QualityVideoDTO]
    var feedBacks: [FeedBackDTO]
    var htmlContents: [HtmlContentDTO]
//    var categories: [CategoryDTO]
    var event: String
    
    init(_ json:JSON) {
        qualities = []
        for (_, subjson) in json["quality"] {
            let dto = QualityVideoDTO(subjson)
            qualities.append(dto)
        }
        
        feedBacks = []
        for (_, subjson) in json["feedBack"] {
            let dto = FeedBackDTO(subjson)
            feedBacks.append(dto)
        }
        
        htmlContents = []
        for(_, subjson) in json["htmlContent"] {
            let dto = HtmlContentDTO(subjson)
            htmlContents.append(dto)
        }
        
        event = json["event"].stringValue
        
//        categories = []
//        for(_, subjson) in json["categories"] {
//            let dto = CategoryDTO(subjson)
//            categories.append(dto)
//        }
    }
}
