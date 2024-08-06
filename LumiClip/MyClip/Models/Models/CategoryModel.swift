//
//  CategoryModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 7/25/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//
import UIKit

class CategoryModel: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var avatarImage: String
    var avatarImageHX: String
    var type: String
    var playTimes: String
    var isEvent: Int
    override init(){
        id = ""
        name = ""
        desc = ""
        coverImage = ""
        avatarImage = ""
        avatarImageHX = ""
        type = ""
        playTimes = ""
        isEvent = 0
    }
    init(_ dto: CategoryDTO) {
        id = dto.id
        name = dto.name
        desc = dto.desc
        coverImage = dto.coverImage
        avatarImage = dto.avatarImage
        avatarImageHX = dto.avatarImageHX
        type = dto.type
        playTimes = dto.playTimes
        isEvent = dto.isEvent
    }
}
