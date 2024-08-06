//
//  CommentInfoRowModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import DateToolsSwift

struct CommentInfoRowModel: PBaseRowModel {
   var title: String
   var desc: String
   var image: String
   var identifier: String
   var objectID: String
   var postedAt: String
   var numberLike: String
   var numberDisLike: String
   var numberComment: String
   var isLike: Bool
   var needShowMore: Bool
   var isSubComment: Bool
   var freeVideo: Bool
   var isDisLike : Bool
   var isManagerComment : Bool
   init(_ model: CommentModel, isSubComment: Bool = false, identifier: String = CommentInfoTableViewCell.nibName()) {
      title = model.comment
      desc = model.fullName
      image = model.avatarImage
      self.identifier = identifier
      objectID = model.id
      numberDisLike  = model.disLikeCount
      if(model.createAtFormat.isEmpty){
         let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm dd-MM-yyyy"
         let myString = formatter.string(from: Date())
         postedAt = myString
      }else{
         postedAt = model.createAtFormat
      }
      isDisLike = model.isDisLike
      numberLike = String(model.likeCount)
      numberComment = String(model.commentCount)
      isLike = model.isLike
      if model.subComments.count > 0 {
         needShowMore = true
      } else {
         needShowMore = false
      }
      self.isSubComment = isSubComment
       freeVideo = false
      isManagerComment = false
   }
   init( Approvedmodel: CommentModel, SubComment: Bool = false) {
      title = Approvedmodel.comment
      desc = Approvedmodel.fullName
      image = Approvedmodel.avatarImage
      self.identifier = ApprovedSubCommentCell.nibName()
      objectID = Approvedmodel.id
      numberDisLike  = Approvedmodel.disLikeCount
      if(Approvedmodel.createAtFormat.isEmpty){
         let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm dd-MM-yyyy"
         let myString = formatter.string(from: Date())
         postedAt = myString
      }else{
         postedAt = Approvedmodel.createAtFormat
      }
      isDisLike = Approvedmodel.isDisLike
      numberLike = String(Approvedmodel.likeCount)
      numberComment = String(Approvedmodel.commentCount)
      isLike = Approvedmodel.isLike
      if Approvedmodel.subComments.count > 0 {
         needShowMore = true
      } else {
         needShowMore = false
      }
      self.isSubComment = SubComment
       freeVideo = false
      isManagerComment = false
   }
   init(_ model: CommentDisPlay, isSubComment: Bool = false, identifier: String = CommentInfoTableViewCell.nibName() , justSent : Bool ) {
      title = model.comment
      desc = model.fullName ?? ""
      image = model.avatarImage
      self.identifier = identifier
      objectID = model.id
      isDisLike = model.isDisLike
      if justSent {
         postedAt = String.recent
      }else{
         postedAt = model.createdAtFormat
      }
      numberDisLike = model.disLikeCount
      numberLike = String(model.likeCount)
      numberComment = ""
      isLike = model.isLike
      needShowMore = false
      self.isSubComment = isSubComment
      freeVideo = false
      isManagerComment = true
   }
   init(_ Approvedmodel: CommentDisPlay, SubComment: Bool = false, justSent : Bool ) {
      title = Approvedmodel.comment
      desc = Approvedmodel.fullName ?? ""
      image = Approvedmodel.avatarImage
      self.identifier = ApprovedSubCommentCell.nibName()
      objectID = Approvedmodel.id
      isDisLike = Approvedmodel.isDisLike
      if justSent {
         postedAt = String.recent
      }else{
         postedAt = Approvedmodel.createdAtFormat
      }
      numberDisLike = Approvedmodel.disLikeCount
      numberLike = String(Approvedmodel.likeCount)
      numberComment = ""
      isLike = Approvedmodel.isLike
      needShowMore = false
      self.isSubComment = SubComment
      freeVideo = false
      isManagerComment = true
   }
   init( rejectComment: CommentDisPlay, isSubComment : Bool) {
        desc = rejectComment.comment
       title = rejectComment.fullName ?? ""
      image = rejectComment.avatarImage
      self.identifier = RejectCommentCell.nibName()
      objectID = rejectComment.id

         postedAt = rejectComment.createdAtFormat
      isDisLike = rejectComment.isDisLike
      numberDisLike = rejectComment.disLikeCount
      numberLike = String(rejectComment.likeCount)
      numberComment = ""
      isLike = false
      needShowMore = false
      self.isSubComment =  isSubComment
      freeVideo = false
      isManagerComment = false
   }
   init( watingModel: CommentDisPlay, isSubComment : Bool) {
        desc = watingModel.comment
       title = watingModel.fullName ?? ""
      image = watingModel.avatarImage
      self.identifier = WaitAprroveCommentCell.nibName()
      objectID = watingModel.id
     postedAt = watingModel.createdAtFormat
      isDisLike = watingModel.isDisLike
      numberDisLike = watingModel.disLikeCount
      numberLike = String(watingModel.likeCount)
      numberComment = ""
      isLike = false
      needShowMore = false
      self.isSubComment =  isSubComment
      freeVideo = false
      isManagerComment = false
   }
}
