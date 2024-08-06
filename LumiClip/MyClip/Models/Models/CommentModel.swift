//
//  CommentModel.swift
//  MyClip
//
//  Created by Os on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import DateToolsSwift

class CommentModel: NSObject {
    var id: String
    var msisdn: String
    var fullName: String
    var avatarImage: String
    var likeCount: Int
    var createdAt: Date
    var createAtFormat: String
    var commentCount: Int
    var comment: String
    var parentId: String
    var isLike: Bool
    var userId: String
    var subComments:[CommentModel]
    var disLikeCount : String
    var isDisLike : Bool
    init(_ dto: CommentDTO) {
        id = dto.id
        fullName = dto.fullName
        avatarImage = dto.avatarImage
        msisdn = dto.msisdn
        likeCount = dto.likeCount
        createdAt = dto.createdAt.getDateWithFormat(Constants.dateFormatter) ?? Date()
        createAtFormat = dto.createAtFormat
        commentCount = dto.commentCount
        comment = dto.comment
        parentId = dto.parentId
        isLike = dto.isLike
        userId = dto.userId
        subComments = []
        isDisLike = dto.isDisLike
        disLikeCount = dto.disLikeCount
        for subDTO in dto.subComments {
            subComments.append(CommentModel(subDTO))
        }
    }
}
