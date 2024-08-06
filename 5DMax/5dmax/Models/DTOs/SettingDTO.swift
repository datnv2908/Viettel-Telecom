//
//  SettingDTO.swift
//  5dmax
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingDTO: NSObject {

    var quality: [QualityDTO]
    var feedBack: [FeedBackDTO]
    var htmlContent: [HtmlContentDTO]
    var categories: [CategoryDTO]
    var countries: [CountryDTO]
    var hotKeywords: [String]
    var menuCollections: [NewUpdateDTO] = []
    var animation: String
    var popup_tet: String
    var game: String
    var game_landscape: String
    var hiddenVIP: String
    var isShowBannerSub: String
    var mpsDetectLink: String
    
    init(_ json: JSON) {
        
        isShowBannerSub = "0"
        isShowBannerSub = json["isShowBannerSub"].boolValue == true ? "1" : "0"
        
        game = "0"
        game = json["game"].stringValue
        
        animation = "0"
        animation = json["animation"].stringValue
        
        popup_tet = "0"
        popup_tet = json["popup_tet"].stringValue
        
        game_landscape = "0"
        game_landscape = json["game_landscape"].stringValue
        
        hiddenVIP = "0"
        let hiddenStr = json["hidden"].stringValue
        hiddenVIP = hiddenStr.count > 0 ? hiddenStr : "0"
        
        mpsDetectLink = ""
        mpsDetectLink = json["mpsDetectLink"].stringValue

        quality = []
        for (_, subJson) in json["quality"] {
            quality.append(QualityDTO(subJson))
        }

        feedBack = []
        for (_, subJson) in json["feedBack"] {
            feedBack.append(FeedBackDTO(subJson))
        }

        htmlContent = []
        for (_, subJson) in json["htmlContent"] {
            htmlContent.append(HtmlContentDTO(subJson))
        }

        categories = []
        for (_, subJson) in json["categories"] {
            categories.append(CategoryDTO(subJson))
        }

        countries = []
        for (_, subJson) in json["countries"] {
            countries.append(CountryDTO(subJson))
        }

        hotKeywords = []
        for (_, subJson) in json["hotKeywords"] {
            hotKeywords.append(subJson.stringValue)
        }
        
        for (_, subJson) in json["menuCollections"] {
            menuCollections.append(NewUpdateDTO(subJson))
        }
    }
}
