//
//  ManagerCommentInteractor.swift
//  MeuClip
//
//  Created by Toannx on 21/11/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class ManagerCommentInteractor: NSObject {
   let appService = CommentServices()
   var viewModel : ManagerCommentViewModelOutput?
}
extension ManagerCommentInteractor : ManagerCommentControllerInput {
   func getData(id: String, completion: @escaping (Result<APIResponse<[CommentModelDisplay]>>) -> Void) {
         appService.getCommentForID(status: id ) { resurt in
            completion(resurt)
         }
   }
   
   
   
   func sendApproveComment(isApprove: Bool, id: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void) {
      appService.sendApproveComment(isApprove: isApprove, id: id ) {  result  in
         completion(result)
      }
      
   }
   
   func likeAnDislikeComment( index : IndexPath ,isLike: Bool, idComment: String, idVideo: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void) {
         appService.likeAnDislikeComment(isLike: isLike, idComment: idComment, idVideo: idVideo) { resurt in
            completion(resurt)
         }
      }
   
   func getPostComment(indexCell : IndexPath, contentId: String, comment: String, parent_id :String, completion: @escaping (Result<APIResponse<CommentDisPlay>>) -> Void) {
         appService.getPostComment(contentId: contentId, comment: comment,parent_id: parent_id) { [weak self] result in
            completion(result)
         }
   }
}
