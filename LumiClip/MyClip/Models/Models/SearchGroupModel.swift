


//
//  SearchGroupModel.swift
//  MyClip
//
//  Created by Os on 9/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SearchGroupModel: NSObject {
    var id: String
    var name: String
    var type: String
    var contents: [ContentModel]
    
    init(_ dto: SearchGroupDTO) {
        id = dto.id
        name = dto.name
        type = dto.type
        contents = []
        for subDTO in dto.contents {
            contents.append(ContentModel(subDTO))
        }
    }
}
