//
//  GroupModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class GroupModel: NSObject, Codable {
    var groupId: String = ""
    var name: String = ""
    var coverImage: String = ""
    var blockType: BlockType = .film
    var content: [FilmModel] = []
    var groupType: GroupType = .filmCategoryGroup
    
    init(_ dto: GroupDTO) {
        groupId     = dto.groupId
        name        = dto.name
        coverImage  = dto.coverImage
        if dto.groupId == BlockType.watching.blockId() {
            blockType = .watching
        } else if dto.groupId == BlockType.comingsoon.blockId() {
            blockType = .comingsoon
        }  else  if dto.groupId == BlockType.series.blockId() {
            blockType = .series
        } else {
            blockType   = BlockType(rawValue: dto.type) ?? .film
        }
        
        groupType   = .filmCategoryGroup
        
        for dto in dto.content {
            content.append(FilmModel(dto, blockType: blockType))
        }
    }
    init(series : SeriesModel) {
        self.groupId = series.id
        self.name = series.name
        self.content =  series.serries
        blockType = .series
    }
    init(groupId : String, name : String) {
        self.groupId = groupId
        self.name = name
        self.coverImage = ""
        self.blockType = .film
        self.content = []
        self.groupType = .filmCategoryGroup
    }
    init(groupUpdate: NewUpdateDTO) {
        groupId = "\(groupUpdate.id)"
        name = groupUpdate.name
        
        for dto in groupUpdate.content {
            content.append(FilmModel(dto, blockType: blockType))
        }
    }
}
