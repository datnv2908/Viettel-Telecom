//
//  ManagerCommentViewModel.swift
//  MeuClip
//
//  Created by mac on 21/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

struct ManagerCommentViewModel : ManagerCommentViewModelOutput {
   var listStatusComment : [CommentStatus] = [.all,.approvedComment,.waitApprove,.rejectComment]
   var currentIndexStatus = 0
   var isLike : Bool = false
   var listVideoComment = [CommentModelDisplay]()
   var indexSelectedComment: IndexPath?
   var isShowCommentView: Bool = false
   var data: [PBaseRowModel] = []
   var listchildComment: [CommentDisPlay] = []
   var listSubComment: [CommentDisPlay] = []
   var fromNoti: Bool = false
   mutating func setUpStatus(index : Int) -> CommentStatus{
      if listStatusComment.indices.contains(index){
         currentIndexStatus = index
      }
      return listStatusComment[currentIndexStatus]
   }
   
   func getCurrentComment() ->  CommentStatus{
      return listStatusComment[currentIndexStatus]
   }
    
   mutating func setUpData(listVideoComment : [CommentModelDisplay] , curentStatus : CommentStatus, fromNoti : Bool){
      self.listVideoComment = listVideoComment
      self.fromNoti = fromNoti
      for (index,item) in listStatusComment.enumerated() {
         if item.getId() == curentStatus.getId()
         {
         self.currentIndexStatus = index
         }
      }
   }
   mutating func doUpdateWithChildComment(index : IndexPath, isAproved : Bool ,listComment : [CommentModelDisplay]){
      self.listchildComment = []
      self.data = []
      let model = listComment[index.section].listComment[index.row]
      self.listVideoComment = listComment
      self.indexSelectedComment = index
         data.append(CommentInfoRowModel(model, isSubComment: false, identifier: RootCommentTableViewCell.nibName(),justSent: false))
         for item in model.childcomment {
            if item.status == CommentStatus.approvedComment.getId() {
               data.append(CommentInfoRowModel(item,SubComment: true
               ,justSent: false))
            }else if item.status == CommentStatus.waitApprove.getId() {
               data.append(CommentInfoRowModel(watingModel: item, isSubComment: true))
            }else{
               data.append(CommentInfoRowModel(rejectComment: item, isSubComment: true))
            }
           listchildComment.append(item)
         }
      
   }
   mutating func doUpdateSubComment(index : IndexPath, model : CommentDisPlay){
      data.insert(CommentInfoRowModel(model,SubComment: true
                                      ,justSent: true), at: 1)
      listchildComment.insert(model, at: 0)
      self.listVideoComment[index.section].listComment[index.row].childcomment.insert(model, at: 0)
   }
   mutating func removeSubComment (index : IndexPath , isAprove :  Bool){
      if let indexComment = self.indexSelectedComment {
         if self.listVideoComment.indices.contains(indexComment.section) && self.listVideoComment[indexComment.section].listComment.indices.contains(indexComment.row) && self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment.indices.contains(index.row - 1 ) {
              let model = self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment[index.row - 1]
               if model.status == CommentStatus.waitApprove.getId() {
                  if isAprove {
                     self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment[index.row - 1].status = CommentStatus.approvedComment.getId()
                      data.remove(at: index.row)
                      data.insert(CommentInfoRowModel(model,SubComment: true
                                                      ,justSent: false), at: index.row)
                  }else{
                     self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment[index.row - 1].status = CommentStatus.rejectComment.getId()
                     data.remove(at: index.row)
                     data.insert(CommentInfoRowModel(rejectComment: model, isSubComment: true), at: index.row)
                  }
               } else if model.status == CommentStatus.approvedComment.getId(){
                  self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment[index.row - 1].status = CommentStatus.rejectComment.getId()
                  data.remove(at: index.row)
                  data.insert(CommentInfoRowModel(rejectComment: model, isSubComment: true), at: index.row)
               } else {
                  self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment[index.row - 1].status = CommentStatus.approvedComment.getId()
                  data.remove(at: index.row)
                  data.insert(CommentInfoRowModel(model,SubComment: true
                                                  ,justSent: false), at: index.row)
                  
               }
            if  self.listVideoComment[indexComment.section].listComment[indexComment.row].childcomment.count == 0 {
               self.listVideoComment[indexComment.section].listComment.remove(at: indexComment.row)
               if self.listVideoComment[indexComment.section].listComment.count == 0 {
                  self.listVideoComment.remove(at: indexComment.section)
               }
            }
         }else{
            return
         }
         
      }
   }
   mutating func removeComment (index : IndexPath){
      if let indexComment = self.indexSelectedComment {
         if self.listVideoComment.indices.contains(indexComment.section) && self.listVideoComment[indexComment.section].listComment.indices.contains(indexComment.row) {
              self.listVideoComment[indexComment.section].listComment.remove(at: index.row)
                  data.remove(at: index.row + 1)
               if self.listVideoComment[indexComment.section].listComment.count == 0 {
                  self.listVideoComment.remove(at: indexComment.section)
                  self.data.removeAll()
               }
         }else{
            return
         }
         
      }
   }

   mutating func doUpdateWithComment(_ comment: CommentDisPlay ) {
      data.append(CommentInfoRowModel(comment,SubComment: true
                                      ,justSent: true))
      if let index = self.indexSelectedComment {
         self.listVideoComment[index.section].listComment[index.row].childcomment.insert(comment, at: 0)
      }
      
   }
   
   func getCurrentStatus() -> CommentStatus {
      return listStatusComment[currentIndexStatus]
   }
   
   
   mutating func removeComment(indexCommennt: IndexPath) {
      if listVideoComment.indices.contains(indexCommennt.section) && listVideoComment[indexCommennt.section].listComment.indices.contains(indexCommennt.row){
         if listVideoComment[indexCommennt.section].listComment.count == 1{
            listVideoComment.remove(at: indexCommennt.section)
         }else{
            listVideoComment[indexCommennt.section].listComment.remove(at: indexCommennt.row)
         }
      }
   }
   
   mutating func doUpdateWithToggleLikeComment(at indexPath: IndexPath) {
      let commentRowModel = listVideoComment[indexPath.section].listComment[indexPath.row]
      if commentRowModel.isLike {
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike -= 1
         commentRowModel.likeCount = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike += 1
         commentRowModel.likeCount = String(numberLike)
      }
      if commentRowModel.isDisLike == true {
         commentRowModel.isDisLike = false
         var numberDisLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberDisLike -= 1
         commentRowModel.disLikeCount = String(numberDisLike)
      }
      commentRowModel.isLike = !commentRowModel.isLike
   }
   mutating func doUpdateWithToggleLikeHeaderSubComment(at indexPath: IndexPath){
      let commentRowModel = listVideoComment[indexSelectedComment!.section].listComment[indexSelectedComment!.row]
      let model = (data[0] as! CommentInfoRowModel)
      var newModel =  model

      if commentRowModel.isLike {
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike -= 1
         
         commentRowModel.likeCount = String(numberLike)
         newModel.numberLike = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike += 1
         commentRowModel.likeCount = String(numberLike)
         newModel.numberLike = String(numberLike)
      }
      if commentRowModel.isDisLike == true {
         commentRowModel.isDisLike = false
         newModel.isDisLike = false
         var numberDisLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberDisLike -= 1
         commentRowModel.disLikeCount = String(numberDisLike)
      }
      newModel.isLike = !commentRowModel.isLike
      data[0] = newModel
      commentRowModel.isLike = !commentRowModel.isLike
   }
   
   mutating func doUpdateWithToggleLikeSubComment(at indexPath: IndexPath) {
      let commentRowModel = listVideoComment[indexSelectedComment!.section].listComment[indexSelectedComment!.row].childcomment[indexPath.row - 1]
      let model = (data[indexPath.row] as! CommentInfoRowModel)
      var newModel =  model

      if commentRowModel.isLike {
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike -= 1
         
         commentRowModel.likeCount = String(numberLike)
         newModel.numberLike = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike += 1
         commentRowModel.likeCount = String(numberLike)
         newModel.numberLike = String(numberLike)
      }
      if commentRowModel.isDisLike == true {
         commentRowModel.isDisLike = false
         newModel.isDisLike = false
         var numberDisLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberDisLike -= 1
         commentRowModel.disLikeCount = String(numberDisLike)
         newModel.numberDisLike = String(numberDisLike)
      }
      newModel.isLike = !commentRowModel.isLike
      data[indexPath.row] = newModel
      commentRowModel.isLike = !commentRowModel.isLike
   }
   mutating func doUpdateWithToggleDisLikeComment(at indexPath: IndexPath) {
      let commentRowModel = listVideoComment[indexPath.section].listComment[indexPath.row]
      if commentRowModel.isDisLike {
         var numberLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberLike -= 1
         commentRowModel.disLikeCount = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberLike += 1
         commentRowModel.disLikeCount = String(numberLike)
      }
      if commentRowModel.isLike  == true {
         commentRowModel.isLike = false
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike -= 1
         commentRowModel.likeCount = String(numberLike)
      }
      commentRowModel.isDisLike = !commentRowModel.isDisLike
   }
   mutating func doUpdateWithToggleDisLikeHeaderSubComment(at indexPath: IndexPath) {
      let commentRowModel = listVideoComment[indexSelectedComment!.section].listComment[indexSelectedComment!.row]
      let model = (data[0] as! CommentInfoRowModel)
      var newModel =  model
      if commentRowModel.isDisLike {
         var numberLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberLike -= 1
         commentRowModel.disLikeCount = String(numberLike)
         newModel.numberDisLike = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberLike += 1
         commentRowModel.disLikeCount = String(numberLike)
         newModel.numberDisLike = String(numberLike)
      }
      if commentRowModel.isLike  == true {
         commentRowModel.isLike = false
         newModel.isLike = false
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike -= 1
         commentRowModel.likeCount = String(numberLike)
         newModel.numberLike = String(numberLike)
         
      }
      newModel.isDisLike = !commentRowModel.isDisLike
      data[0] = newModel
      commentRowModel.isDisLike = !commentRowModel.isDisLike
   }
   mutating func doUpdateWithToggleDisLikeSubComment(at indexPath: IndexPath) {
      let commentRowModel = listVideoComment[indexSelectedComment!.section].listComment[indexSelectedComment!.row].childcomment[indexPath.row - 1]
      let model = (data[indexPath.row] as! CommentInfoRowModel)
      var newModel =  model
      if commentRowModel.isDisLike {
         var numberLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberLike -= 1
         commentRowModel.disLikeCount = String(numberLike)
         newModel.numberDisLike = String(numberLike)
      } else {
         var numberLike = (Int(commentRowModel.disLikeCount)) ?? 0
         numberLike += 1
         commentRowModel.disLikeCount = String(numberLike)
         newModel.numberDisLike = String(numberLike)
      }
      if commentRowModel.isLike  == true {
         commentRowModel.isLike = false
         newModel.isLike = false
         var numberLike = (Int(commentRowModel.likeCount)) ?? 0
         numberLike -= 1
         commentRowModel.likeCount = String(numberLike)
         newModel.numberLike = String(numberLike)
      }
      newModel.isDisLike = !commentRowModel.isDisLike
      data[indexPath.row] = newModel
      commentRowModel.isDisLike = !commentRowModel.isDisLike
   }
}
