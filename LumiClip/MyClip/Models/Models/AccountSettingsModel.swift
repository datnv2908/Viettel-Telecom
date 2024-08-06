//
//  AccountSettings.swift
//  MyClip
//
//  Created by sunado on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class QualityVideoModel: NSObject, NSCoding {
    var name: String
    var vod_profile_id: Int
    var live_profile_id: Int
    
    init(_ dto: QualityVideoDTO) {
        name            = dto.name
        vod_profile_id  = dto.live_profile_id
        live_profile_id = dto.live_profile_id
    }
    
    required init?(coder decoder: NSCoder) {
        name            = decoder.decodeObject(forKey: "qualityVideo_name") as? String ?? ""
        vod_profile_id  = Int(decoder.decodeCInt(forKey: "vod_profile_id"))
        live_profile_id = Int(decoder.decodeCInt(forKey: "live_profile_id"))
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "qualityVideo_name")
        coder.encode(vod_profile_id, forKey: "vod_profile_id")
        coder.encode(live_profile_id, forKey: "live_profile_id")
    }
}

class FeedBackModel: NSObject, NSCoding {
    var id: String
    var content: String
    
    init(_ dto: FeedBackDTO){
        id      = dto.id
        content = dto.content
    }
    
    required init?(coder decoder: NSCoder) {
        id = decoder.decodeObject(forKey: "feedBack_id") as? String ?? ""
        content = decoder.decodeObject(forKey: "feadBack_content") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "feedBack_id")
        coder.encode(content, forKey: "feadBack_content")
    }
}


class HtmlContentModel: NSObject, NSCoding {
    var type: String
    var content: String
    
    init(_ dto: HtmlContentDTO) {
        type     = dto.type
        content  = dto.content
    }
    
    required init?(coder decoder: NSCoder) {
        type    = decoder.decodeObject(forKey: "htmlContent_type") as? String ?? ""
        content = decoder.decodeObject(forKey: "htmlContent_content") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: "htmlContent_type")
        coder.encode(content, forKey: "htmlContent_content")
    }
}

//class CategoryModel: NSObject, NSCoding {
//    var id: Int
//    var name: String
//    var type: String
//    var getMoreContentId: String
//    var filter_type: String
//
//    init(_ dto: CategoryDTO) {
//        id               = dto.id
//        name             = dto.name
//        type             = dto.type
//        getMoreContentId = dto.getMoreContentId
//        filter_type      = dto.filter_type
//    }
//
//    required init?(coder decoder: NSCoder) {
//        id               = Int(decoder.decodeCInt(forKey: "category_id"))
//        name             = decoder.decodeObject(forKey: "category_name") as? String ?? ""
//        type             = decoder.decodeObject(forKey: "category_type") as? String ?? ""
//        getMoreContentId = decoder.decodeObject(forKey: "category_moreContentId") as? String ?? ""
//        filter_type      = decoder.decodeObject(forKey: "category_filer_type") as? String ?? ""
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(id, forKey: "category_id")
//        coder.encode(name, forKey: "category_name")
//        coder.encode(type, forKey: "category_type")
//        coder.encode(getMoreContentId, forKey: "category_moreContentId")
//        coder.encode(filter_type, forKey: "category_filer_type")
//    }
//
//}


class AccountSettingsModel: NSObject, NSCoding {
    var qualities: [QualityVideoModel]
    var feedBacks: [FeedBackModel]
    var htmlContents: [HtmlContentModel]
    var event: String = ""
//    var categories: [CategoryModel]
    
    init(_ dto: AccountSettingsDTO) {
        qualities = []
        for subDto in dto.qualities {
            let model = QualityVideoModel(subDto)
            qualities.append(model)
        }
        
        feedBacks = []
        for subDto in dto.feedBacks {
            let model = FeedBackModel(subDto)
            feedBacks.append(model)
        }
        
        htmlContents = []
        for subDto in dto.htmlContents {
            let model = HtmlContentModel(subDto)
            htmlContents.append(model)
        }
        
        event = dto.event
//        categories = []
//        for subDto in dto.categories {
//            let model = CategoryModel(subDto)
//            categories.append(model)
//        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        qualities    = aDecoder.decodeObject(forKey: "quanlities") as! [QualityVideoModel]
        feedBacks    = aDecoder.decodeObject(forKey: "feedBacks") as! [FeedBackModel]
        htmlContents = aDecoder.decodeObject(forKey: "htmlContents") as! [HtmlContentModel]
        if aDecoder.containsValue(forKey: "event") {
            event = aDecoder.decodeObject(forKey: "event") as! String
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(qualities, forKey: "quanlities")
        aCoder.encode(feedBacks, forKey: "feedBacks")
        aCoder.encode(htmlContents, forKey: "htmlContents")
        aCoder.encode(event, forKey: "event")
    }
    
}
