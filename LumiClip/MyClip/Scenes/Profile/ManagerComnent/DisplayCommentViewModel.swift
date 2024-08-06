//
//  DisplayCommentViewModel.swift
//  MeuClip
//
//  Created by Toannx on 06/12/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class DisplayCommentViewModel: NSObject {
   var sections = [SectionModel]()
   
   init(index : IndexPath, isAproved : Bool ,listComment : [CommentModelDisplay]) {
      let model = listComment[index.section].listComment[index.row]
      if isAproved {
         let modelHeader = DisplayCommentSection(model: model, identifier: HeaderInforVideo.nibName())
         var section = SectionModel(rows: [])
          section.header = modelHeader
         for item in model.childcomment {
            let  data = CommentInfoRowModel(item,isSubComment: true,justSent: false)
            section.rows.append(data)
         }
      }else{
         let modelHeader = DisplayCommentSection(model: model, identifier: HeaderInforVideo.nibName())
         var section = SectionModel(rows: [])
          section.header = modelHeader
         for item in model.childcomment {
            let  data = CommentInfoRowModel(watingModel: item, isSubComment: true)
            section.rows.append(data)
      }
      
//      for (index,item) in  listVideoComment.enumerated(){
//         let model = DisplayCommentSection(model: item, identifier: HeaderInforVideo.nibName())
//         var section = SectionModel(rows: [])
//         section.header = model
//         for sudComment in item.listComment {
//            let  data = CommentInfoRowModel(sudComment)
//            section.rows.append(data)
//         }
//      }
   }
   
   
}
}


class DisplayCommentSection : PBaseHeaderModel{
    var identifier: String?
   var commentModel : CommentDisPlay?
    var title: String
   
   init(model : CommentDisPlay , identifier : String = HeaderInforVideo.nibName()) {
      self.identifier = identifier
      self.commentModel = model
      self.title = model.fullName ?? ""
    }
}

