



//
//  SubCommentViewModel.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 11/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SubCommentViewModel {
   var comment: CommentModel?
   var data: [PBaseRowModel]
   var videoId: String = ""
   var isShowCommentView: Bool = false
   var listSubComment: [CommentModel]
   var listchildComment: [CommentDisPlay]
   init() {
      data = []
      listSubComment = []
      listchildComment = []
   }
   
   func doUpdateWithComment(_ comment: CommentModel) {
      data = []
      listSubComment = []
      data.append(CommentInfoRowModel(comment, isSubComment: false, identifier: RootCommentTableViewCell.nibName()))
      for item in comment.subComments {
         data.append(CommentInfoRowModel(item,isSubComment: true))
         listSubComment.append(item)
      }
   }
   func doUpdateWithToggleLikeComment(at indexPath: IndexPath) {
      var commentRowModel = data[indexPath.row] as! CommentInfoRowModel
      if commentRowModel.isLike {
         var numberLike = (Int(commentRowModel.numberLike))!
         numberLike -= 1
         commentRowModel.numberLike = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.numberLike))!
         numberLike += 1
         commentRowModel.numberLike = String(numberLike)
      }
      if commentRowModel.isDisLike {
         var numberLike = (Int(commentRowModel.numberDisLike))!
         numberLike -= 1
         commentRowModel.numberDisLike = String(numberLike)
         commentRowModel.isDisLike = false
      }
      commentRowModel.isLike = !commentRowModel.isLike
      data[indexPath.row] = commentRowModel
      // index of comment shoule be indexpath.row - 1
      // because the first row is comment input field
   }
   func doUpdateWithToggleDisLikeComment(at indexPath: IndexPath) {
      var commentRowModel = data[indexPath.row] as! CommentInfoRowModel
      if commentRowModel.isDisLike {
         var numberLike = (Int(commentRowModel.numberDisLike))!
         numberLike -= 1
         commentRowModel.numberDisLike = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.numberDisLike))!
         numberLike += 1
         commentRowModel.numberDisLike = String(numberLike)
      }
      if commentRowModel.isLike {
         var numberLike = (Int(commentRowModel.numberLike))!
         numberLike -= 1
         commentRowModel.numberLike = String(numberLike)
         commentRowModel.isLike = false
      }
      commentRowModel.isDisLike = !commentRowModel.isDisLike
      data[indexPath.row] = commentRowModel
      // index of comment shoule be indexpath.row - 1
      // because the first row is comment input field
   }
}
