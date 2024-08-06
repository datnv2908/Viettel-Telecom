//
//  FilmDetailModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmDetailModel: NSObject {
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
    var attributes: FilmType
    var contentFilter: String
    var nationInfo: [InfoModel]
    var actorInfo: [InfoModel]
    var directorInfo: [InfoModel]
    private var currentVideoId: String
    var coverImage: String
    var categories: [CategoryModel]
    var priceFull: String
    var drmContent: String?
    var subscription_type: FilmCostType
    var country: String
    var buyStatusText: String
    var extra_description: String
    
    init (_ dto: FilmDetailDTO) {
        filmId = dto.filmId
        name = dto.name
        desc = dto.desc
        type = dto.type
        avatarImage = dto.avatarImage
        avatarImageH = dto.avatarImageH
        link = dto.link
        slug = dto.slug
        isFavourite = dto.isFavourite
        playTimes = dto.playTimes
        yearOfProduct = dto.yearOfProduct
        imdb = dto.imdb
        priceFull = dto.priceFull
        duration = dto.duration
        attributes = FilmType(rawValue: dto.attributes) ?? .retail
        contentFilter = dto.contentFilter
        var infos = [InfoModel]()
        for info in dto.infos {
            infos.append(InfoModel(info))
        }
        nationInfo = infos.filter({ (element) -> Bool in
            return element.type == FilmInfoType.nation
        })
        actorInfo = infos.filter({ (element) -> Bool in
            return element.type == FilmInfoType.actor
        })
        directorInfo = infos.filter({ (element) -> Bool in
            return element.type == FilmInfoType.director
        })
        currentVideoId = dto.currentVideoId
        coverImage = dto.coverImage
        categories = [CategoryModel]()
        for categoryDTO in dto.categories {
            categories.append(CategoryModel(categoryDTO))
        }
        drmContent = dto.drmContent
        subscription_type = FilmCostType.typeWithInt(dto.subscription_type)
        country = dto.country
        buyStatusText = dto.buyStatusText
        extra_description = dto.extra_description
    }

    func getCurrentVideoId() -> String {
        return currentVideoId
    }

    func setCurrentVideoId(_ videoId: String) {
        currentVideoId = videoId
    }
}
