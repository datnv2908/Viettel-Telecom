

//
//  SubCommentModel.swift
//  MyClip
//
//  Created by Os on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SubCommentModel: NSObject {
    var id: String
    var content: String
    var name: String
    var likeCount: Int
    var createdAt: String
    
    init(_ dto: SubCommentDTO) {
        id = dto.id
        content = dto.content
        name = dto.name
        likeCount = dto.likeCount
        createdAt = dto.createdAt
    }
}
