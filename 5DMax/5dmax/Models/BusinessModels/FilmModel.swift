//
//  FilmModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmModel: NSObject, Codable {

    var id: String // id of the film
    var partId: String? // id of the watching part
    var itemId: String? // id of banner if has
    var name: String
    var link: String
    var desc: String
    var slug: String
    var playTimes: String
    var coverImage: String
    var coverImageH: String
    var coverImageHX: String
    var contentType: ContentType
    var blockType: BlockType
    var duration: String
    var durationPercent: Double
    var trailer: Int
    var price: Int?
    
    init(_ dto: FilmDTO, blockType: BlockType = .film) {
        name = dto.name
        link = dto.link
        desc = dto.desc
        slug = dto.slug
        playTimes = dto.playTimes
        coverImage = dto.coverImage
        coverImageH = dto.coverImageH
        coverImageHX = dto.coverImageHX
        contentType = ContentType(rawValue: dto.type) ?? .film
        self.blockType = blockType

        if blockType == .banner {
            id = dto.itemId
            partId = nil
            itemId = dto.id
        } else {
            if contentType == .film {
                id = dto.id
                partId = nil
            } else {
                id = dto.parentId
                partId = dto.id
            }
            itemId = nil
        }
        duration = dto.duration
        durationPercent = dto.durationPercent
        trailer = dto.trailer
        price = Int(dto.price)
    }
    
    init(_ dto: FilmModel) {
        id = dto.id
        name = dto.name
        link = dto.link
        desc = dto.desc
        slug = dto.slug
        playTimes = dto.playTimes
        coverImage = dto.coverImage
        coverImageH = dto.coverImageH
        coverImageHX = dto.coverImageHX
        contentType = dto.contentType
        blockType = dto.blockType
        itemId = dto.itemId
        partId = dto.partId
        duration = dto.duration
        durationPercent = dto.durationPercent
        trailer = dto.trailer
        price = dto.price
    }
}
