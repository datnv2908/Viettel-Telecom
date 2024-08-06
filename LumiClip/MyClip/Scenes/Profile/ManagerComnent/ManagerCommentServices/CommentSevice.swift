//
//  CommentSevice.swift
//  MeuClip
//
//  Created by mac on 22/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentServices : APIServiceObject{
   
   func getCommentForID(status : String ,completion: @escaping (Result<APIResponse<[CommentModelDisplay]>>) -> Void){
      let request = APIRequestProvider.shareInstance.getListComment(status: status)
      serviceAgent.startRequest(request) {(json,errors) in
         if let err = errors {
            completion(Result.failure(err))
         }else{
            var  listComment = [CommentModelDisplay]()
            for item in json["data"].arrayValue {
               let model = CommentModelDisplayDTO(json: item )
               let commentDisplay = CommentModelDisplay(model: model)
               listComment.append(commentDisplay)
            }
            completion(Result.success(APIResponse(json, data: listComment)))
            
         }
      }
   }
   
   func getCommentForNotify(status : String ,idVideo : String ,idComment : String ,completion: @escaping (Result<APIResponse<[CommentModelDisplay]>>) -> Void){
      let request = APIRequestProvider.shareInstance.getListCommentWithID(status: status, idVideo: idVideo, idComment: idComment)
      serviceAgent.startRequest(request) {(json,errors) in
         if let err = errors {
            completion(Result.failure(err))
         }else{
            var  listComment = [CommentModelDisplay]()
            for item in json["data"].arrayValue {
               let model = CommentModelDisplayDTO(json: item )
               let commentDisplay = CommentModelDisplay(model: model)
               listComment.append(commentDisplay)
            }
            completion(Result.success(APIResponse(json, data: listComment)))
            
         }
      }
   }
   func sendApproveComment(isApprove: Bool , id: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void ){
      let request = APIRequestProvider.shareInstance.sendApproveComment(isApprove: isApprove, id: id)
      serviceAgent.startRequest(request) { (message,errors) in
         if let err = errors {
            completion(Result.failure(err))
         } else {
            completion(Result.success(APIResponse(message, data: message)))
         }
      }
   }
   func likeAnDislikeComment(isLike : Bool, idComment : String,idVideo : String ,completion: @escaping (Result<APIResponse<JSON>>) -> Void ) {
      let request = APIRequestProvider.shareInstance.sendLikeAndDislike(isLike: isLike, idComment: idComment, idVideo: idVideo)
      serviceAgent.startRequest(request) { (message,errors) in
         if let err = errors {
            completion(Result.failure(err))
         } else {
            completion(Result.success(APIResponse(message, data: message)))
         }
      }
   }
   func getPostComment(contentId: String ,comment: String ,parent_id : String , completion:@escaping (Result<APIResponse<CommentDisPlay>>)-> Void) {
      let request = APIRequestProvider.shareInstance.manageComment(contentId: contentId, comment: comment, parent_id: parent_id)
      serviceAgent.startRequest(request) { (json, error) in
         if let err = error {
            completion(Result.failure(err))
         } else {
            let model = CommentDisPlay(model: CommentDisPlayDTO(json: json["data"]))
            completion(Result.success(APIResponse(json, data: model)))
         }
      }
   }
   
}
