
//
//  CommentDTO.swift
//  MyClip
//
//  Created by Os on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentDTO: NSObject {
    var id: String
    var msisdn: String
    var fullName: String
    var avatarImage: String
    var likeCount: Int
    var createdAt: String
    var createAtFormat: String
    var commentCount: Int
    var comment: String
    var parentId: String
    var isLike: Bool
    var userId: String
    var subComments: [CommentDTO]
    var disLikeCount : String
    var isDisLike : Bool
    init(_ json: JSON) {
        id              = json["id"].stringValue
        fullName        = json["full_name"].stringValue
        avatarImage     = json["avatarImage"].stringValue
        msisdn          = json["msisdn"].stringValue
        likeCount       = json["like_count"].intValue
        createdAt       = json["created_at"].stringValue
        createAtFormat  = json["created_at_format"].stringValue
        commentCount    = json["comment_count"].intValue
        comment         = json["comment"].stringValue
        parentId        = json["parent_id"].stringValue
        isLike          = json["is_like"].boolValue
        userId          = json["user_id"].stringValue
        subComments = []
//      if  json["like"].intValue  == 2 {
//         isDisLike = true
//         isLike = false
//      }else if json["like"].intValue  == 1{
//          isLike = true
//         isDisLike = false
//      }else{
//         isLike = false
//        isDisLike = false
//      }
        disLikeCount    = json["dislike_count"].stringValue
        self.isDisLike = json["isDisLike"].boolValue
        for (_, subJson) in json["children"] {
            let dto = CommentDTO(subJson)
            subComments.append(dto)
        }
    }
}
