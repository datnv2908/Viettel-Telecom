//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON

class VideoDetailInteractor: NSObject {
    weak var presenter: VideoDetailInteractorOutput?
    let service = VideoServices()
    let appservice = AppService()
    deinit {
//        service.cancelAllRequests()
    }
}

extension VideoDetailInteractor: VideoDetailInteractorInput {
    func sendWatchTime(id: String,
                       time: Double,
                       type: ContentType,
                       completion: @escaping (Result<Any>) -> Void) {
        
    }

    func getData(videoId: String, playlistId: String?,
                 acceptLostData: Bool,
                 completion: @escaping (Result<APIResponse<VideoDetailModel>>) -> Void) {
        service.getVideoDetail(for: videoId,
                               playlistId: playlistId,
                               acceptLostData: acceptLostData) { (result) in
            completion(result)
        }
    }
    
   func postComment(type: String,
                    parentId: String,
                     contentID: String,
                     comment: String,
                     completion: @escaping (Result<APIResponse<CommentModel>>) -> Void) {
      service.postComment(type : type , parentId: parentId , 
                            contentId: contentID,
                            comment: comment) { (result) in
            completion(result)
        }
    }
    
    func toggleLikeVideo(videoId: String,
                         status: LikeStatus,
                         completion: @escaping (Result<APIResponse<Int>>) -> Void) {
        service.toggleLikeVideo(videoId: videoId, status: status) { (result) in
            completion(result)
        }
    }
    
    func toggleLikeComment(type: String,
                           contentID: String,
                           commentId: String,
                           completion: @escaping (Result<Any>) -> Void) {
        service.toggleLikeComment(type: type,
                                  contentId: contentID,
                                  commentId: commentId) { (result) in
            completion(result)
        }
    }
   func toggleDisLikeComment(type: String,
                          contentID: String,
                          commentId: String,
                          completion: @escaping (Result<Any>) -> Void) {
      service.toggleDisLikeComment(type: "", contentId: contentID, commentId: commentId) { (result) in
         completion(result)
     }
       }
   func toggleRejectComment(isApprove: Bool, id: String, completion: @escaping (Result<APIResponse<JSON>>) -> Void){
      service.sendApproveComment(isApprove: isApprove, id: id ) {  result  in
         completion(result)
      }
   }
    func toggleFollowChannel(channelId: String,
                             status: Int,
                             notificationType: Int,
                             completion: @escaping (Result<Any>) -> Void) {
        service.toggleFollowChannel(channelId: channelId,
                                    status: status,
                                    notificationType: notificationType) { (result) in
            completion(result)
        }
    }
    
    func getSuggestionsChannel(
                             completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void) {
        service.getSuggestionsChannel()
            {
                (result) in completion(result)
        }
    }
    
    func getListComment(type: ContentType,
                        contentId: String,
                        pager: Pager,
                        completion: @escaping (Result<APIResponse<[CommentModel]>>) -> Void) {
        service.getListComment(type: type,
                               contentId: contentId,
                               pager: pager) { (result) in
            completion(result)
        }
    }
    
    func deleteComment(commentId: String,
                       completion: @escaping (Result<APIResponse<Bool>>) -> Void) {
        service.deleteComment(id: commentId) { (result) in
            completion(result)
        }
    }
    
    func updateComment(commentId: String,
                       comment: String,
                       completion: @escaping (Result<APIResponse<Bool>>) -> Void) {
        service.updateComment(id: commentId, comment: comment) { (result) in
            completion(result)
        }
    }
    
    func registPackage(_ id: String, contentId: String,
                       completion: @escaping(Result<APIResponse<String>>) -> Void) {
        appservice.registerServicePackage(id: id, contentId: contentId) { (result) in
            completion(result)
        }
        LoggingRecommend.packageRegisterAction(packageId: id)
    }        
    
    func buyRetail(_ id: String,
                   type: ContentType,
                   completion: @escaping (Result<APIResponse<String>>) -> Void) {
        appservice.buyRetail(item: id, type: type) { (result) in
            completion(result)
        }
    }
}
