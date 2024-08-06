//
//  SettingModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SettingModel: NSObject, NSCoding {

    var quality: [QualityModel] = []
    var feedBack: [FeedBackModel] = []
    var htmlContent: [HtmlContentModel] = []
    var categories: [CategoryModel] = []
    var countries: [CategoryModel] = []
    var hotKeywords: [String] = []
    var menuCollections: [NewUpdateModel] = []
    var animation: String
    var popup_tet: String
    var game: String
    var game_landscape: String
    var hiddenVIP: String
    var isShowBannerSub: String
    var mpsDetectLink: String

    init(_ dto: SettingDTO) {

        isShowBannerSub = "0"
        isShowBannerSub = dto.isShowBannerSub
        
        game = "0"
        game = dto.game
        
        animation = "0"
        animation = dto.animation
        
        popup_tet = "0"
        popup_tet = dto.popup_tet
        
        game_landscape = "0"
        game_landscape = dto.game_landscape
        
        hiddenVIP = "0"
        hiddenVIP = dto.hiddenVIP
        
        mpsDetectLink = ""
        mpsDetectLink = dto.mpsDetectLink
        
        quality = []
        for dto in dto.quality {
            quality.append(QualityModel(dto))
        }

        feedBack = []
        for dto in dto.feedBack {
            feedBack.append(FeedBackModel(dto))
        }

        htmlContent = []
        for dto in dto.htmlContent {
            htmlContent.append(HtmlContentModel(dto))
        }

        categories = []
        for dto in dto.categories {
            categories.append(CategoryModel(dto))
        }

        countries = []
        for dto in dto.countries {
            countries.append(CategoryModel(countryDTO: dto))
        }

        hotKeywords = []
        hotKeywords.append(contentsOf: dto.hotKeywords)
        
        for dto in dto.menuCollections {
            menuCollections.append(NewUpdateModel(dto))
        }
    }

    required init(coder decoder: NSCoder) {
        isShowBannerSub = decoder.decodeObject(forKey: "isShowBannerSub") as? String ?? "0"
        game            = decoder.decodeObject(forKey: "game") as? String ?? "0"
        game_landscape  = decoder.decodeObject(forKey: "game_landscape") as? String ?? "0"
        hiddenVIP       = decoder.decodeObject(forKey: "hiddenVIP") as? String ?? "0"
        mpsDetectLink   = decoder.decodeObject(forKey: "mpsDetectLink") as? String ?? ""
        animation       = decoder.decodeObject(forKey: "animation") as? String ?? "0"
        popup_tet       = decoder.decodeObject(forKey: "popup_tet") as? String ?? "0"
        quality         = decoder.decodeObject(forKey: "quality") as? [QualityModel] ?? []
        quality         = decoder.decodeObject(forKey: "quality") as? [QualityModel] ?? []
        feedBack        = decoder.decodeObject(forKey: "feedBack") as? [FeedBackModel] ?? []
        htmlContent     = decoder.decodeObject(forKey: "htmlContent") as? [HtmlContentModel] ?? []
        categories      = decoder.decodeObject(forKey: "categories") as? [CategoryModel] ?? []
        countries       = decoder.decodeObject(forKey: "countries") as? [CategoryModel] ?? []
        hotKeywords     = decoder.decodeObject(forKey: "hotKeywords") as? [String] ?? []
        menuCollections = decoder.decodeObject(forKey: "menuCollections") as? [NewUpdateModel] ?? []
    }

    func encode(with coder: NSCoder) {
        coder.encode(isShowBannerSub, forKey: "isShowBannerSub")
        coder.encode(game, forKey: "game")
        coder.encode(hiddenVIP, forKey: "hiddenVIP")
        coder.encode(hiddenVIP, forKey: "mpsDetectLink")
        coder.encode(game_landscape, forKey: "game_landscape")
        coder.encode(animation, forKey: "animation")
        coder.encode(popup_tet, forKey: "popup_tet")
        coder.encode(quality, forKey: "quality")
        coder.encode(feedBack, forKey: "feedBack")
        coder.encode(htmlContent, forKey: "htmlContent")
        coder.encode(categories, forKey: "categories")
        coder.encode(countries, forKey: "countries")
        coder.encode(hotKeywords, forKey: "hotKeywords")
        coder.encode(menuCollections, forKey: "menuCollections")
    }

    func getHTMLWithType(contenType: HTMLContentType) -> HtmlContentModel? {
        if htmlContent.first?.contentType == contenType {
            return htmlContent.first
        } else if htmlContent[1].contentType == contenType {
            return htmlContent[1]
        } else if htmlContent[2].contentType == contenType {
            return htmlContent[2]
        } else if htmlContent[3].contentType == contenType {
            return htmlContent[3]
        } else if htmlContent[4].contentType == contenType {
            return htmlContent[4]
        } else {
            return nil
        }
//        for item in htmlContent {
//            if item.contentType == contenType {
//                return item
//            } else {
//                return nil
//            }
//        }

//       return nil
    }
}
