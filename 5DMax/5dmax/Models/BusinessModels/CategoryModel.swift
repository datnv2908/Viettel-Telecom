//
//  CategoryModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class CategoryModel: NSObject, NSCoding {
    var categoryId: String
    var name: String
    var type: String
    var getMoreContentId: String
    var groupType: GroupType?

    init(_ dto: CategoryDTO) {
        categoryId = dto.categoryId
        name = dto.name
        type = dto.type
        getMoreContentId = dto.getMoreContentId
    }

    init(countryDTO: CountryDTO) {

        categoryId  = countryDTO.id
        name        = countryDTO.name
        type        = "FILM"
        getMoreContentId = "film_info_" + "\(categoryId)"
    }

    required init(coder decoder: NSCoder) {
        categoryId          = decoder.decodeObject(forKey: "categoryId") as? String ?? ""
        name                = decoder.decodeObject(forKey: "name") as? String ?? ""
        type                = decoder.decodeObject(forKey: "type") as? String ?? ""
        getMoreContentId    = decoder.decodeObject(forKey: "getMoreContentId") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(categoryId, forKey: "categoryId")
        coder.encode(name, forKey: "name")
        coder.encode(type, forKey: "type")
        coder.encode(getMoreContentId, forKey: "getMoreContentId")
    }

    init(group: GroupModel) {
        categoryId          = group.groupId
        getMoreContentId    = group.groupId
        name = group.name
        type = "FILM"
    }

    init(_ inputType: GroupType) {
        categoryId          = inputType.idStringValue()
        name                = inputType.name()
        type                = "FILM"
        getMoreContentId    = inputType.idStringValue()
        groupType = inputType
    }
}
