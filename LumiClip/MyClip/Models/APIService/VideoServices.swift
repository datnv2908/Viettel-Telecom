//
//  VideoServices.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoServices: APIServiceObject {
    func getHomeContents(completion: @escaping (Result<APIResponse<HomeModel>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getHomeContent()
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var channels = [ChannelModel]()
                var videos = [ContentModel]()
                for dataItem in json["data"].arrayValue{
                    if(dataItem["type"].stringValue == "NEWSFEED"){
                        for item in dataItem["content"].arrayValue {
                            videos.append(ContentModel(ContentDTO(item)))
                        }
                    }
                    if(dataItem["type"].stringValue == ContentType.channel.rawValue){
                        for item in dataItem["content"].arrayValue {
                            channels.append(ChannelModel(ChannelDTO(item)))
                        }
                    }
                }
                let homeItem = HomeModel(channels: channels, videos: videos)
                
                completion(Result.success(APIResponse(json, data: homeItem)))
            }
        }
        addToQueue(request)
    }
    func getMoreContents(for category: String,
                         pager: Pager,
                         completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getMoreContent(category, pager: pager)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [ContentModel]()
                for item in json["data"]["content"].arrayValue {
                    models.append(ContentModel(ContentDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: models)))
            }
        }
        addToQueue(request)
    }
   func alowCommentForVideo(idVideo : String, enableComment : Bool,
                        completion: @escaping (Result<APIResponse<JSON>>) -> Void) {
       let request = APIRequestProvider.shareInstance.alowCommentForVideo(idVideo: idVideo, enableComment: enableComment)
       serviceAgent.startRequest(request) { (json, error) in
           if let err = error {
               completion(Result.failure(err))
           } else {
               completion(Result.success(APIResponse(json, data: json)))
           }
       }
       addToQueue(request)
   }
    func getVideoDetail(for videoId: String,
                        playlistId: String?,
                        acceptLostData: Bool,
                         completion: @escaping (Result<APIResponse<VideoDetailModel>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getVideoDetail(id: videoId,
                                                                      playlistId: playlistId,
                                                                      acceptLostData: acceptLostData)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = VideoDetailModel(VideoDetailDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
        addToQueue(request)
    }
    
    func sendWatchTime(id: String,
                       time: Double,
                       type: ContentType,
                       completion: @escaping(Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.watchTime(id: id, time: time, type: type)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(true))
            }
        }
        addToQueue(request)
    }
    
    func getVideoHistory(completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getHistoryContent()
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [ContentModel]()
                for item in json["data"]["content"].arrayValue {
                    models.append(ContentModel(ContentDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
        addToQueue(request)
    }
    
    func deleteComment(id: String, completion: @escaping (Result<APIResponse<Bool>>) -> Void) {
        let request = APIRequestProvider.shareInstance.deleteComment(id: id)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: true)))
            }
        })
        addToQueue(request)
    }
    
    func deleteVideo(id: String, completion: @escaping (Result<APIResponse<Bool>>) -> Void) {
        let request = APIRequestProvider.shareInstance.deleteVideo(id: id)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: true)))
            }
        })
        addToQueue(request)
    }
    
    func updateComment(id: String,
                       comment: String,
                       completion: @escaping (Result<APIResponse<Bool>>) -> Void) {
        let request = APIRequestProvider.shareInstance.updateComment(id: id, comment: comment)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: true)))
            }
        })
        addToQueue(request)
    }
    
   func postComment(type: String,
                    parentId: String,
                     contentId: String,
                     comment: String,
                     completion: @escaping (Result<APIResponse<CommentModel>>) -> Void ) {
      let request = APIRequestProvider.shareInstance.postComment(type: type , contentId: contentId, parent_id: parentId, comment: comment)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = CommentModel(CommentDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
        addToQueue(request)
    }
    
    func clearVideoHistory(ids: String, completion: @escaping (Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.deleteHistoryView(ids: ids)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(json["message"].stringValue))
            }
        })
        addToQueue(request)
    }
    
    func toggleWatchLater(id: String,
                          status: Int,
                          completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.toggleWatchLater(id: id, status: status)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        })
        addToQueue(request)
    }
    
    func toggleVideoToPlaylist(playlistId: String,
                               videoId: String,
                               status: Int,
                               completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.toggleAddVideo(playlistId: playlistId,
                                                                      videoId: videoId,
                                                                      status: status)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        })
        addToQueue(request)
    }
    
    func getAllPlaylist(completion: @escaping (Result<APIResponse<[PlaylistModel]>>) -> (Void)) {
        let request = APIRequestProvider.shareInstance.getAllPlaylist()
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var list = [PlaylistModel]()
                
                for subJson in json["data"]["content"].arrayValue {
                    let model = PlaylistModel(PlaylistDTO(subJson))
                    list.append(model)
                }
                completion(Result.success(APIResponse(json, data: list)))
            }
        })
        addToQueue(request)
    }
    
    func toggleLikeVideo(videoId: String, status: LikeStatus, completion: @escaping (Result<APIResponse<Int>>) -> Void) {
        let request = APIRequestProvider.shareInstance.toggleLikeVideo(id: videoId, status: status)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let value = json["data"]["STATUS"].intValue
                completion(Result.success(APIResponse(json, data: value)))
            }
        }
        addToQueue(request)
    }
    
    func toggleLikeComment(type: String,
                           contentId: String,
                           commentId: String, completion: @escaping (Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.toggleLikeComment(type: type,
                                                                         contentId: contentId,
                                                                         commentId: commentId)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(true))
            }
        }
        addToQueue(request)
    }
   func toggleDisLikeComment(type: String,
                          contentId: String,
                          commentId: String, completion: @escaping (Result<Any>) -> Void) {
       let request = APIRequestProvider.shareInstance.toggleLikeDisLikeComment(like: false, commentId: commentId, contentId: contentId)
       serviceAgent.startRequest(request) { (json, error) in
           if let err = error {
               completion(Result.failure(err))
           } else {
               completion(Result.success(true))
           }
       }
       addToQueue(request)
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
    func toggleFollowChannel(channelId: String,
                             status: Int, notificationType: Int,
                             completion: @escaping (Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.followChannel(id: channelId,
                                                                     status: status,
                                                                     notificationType: notificationType)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(json["message"].stringValue))
                NotificationCenter.default.post(name: .kNotificationShouldReloadFollow,
                                                object: nil,
                                                userInfo: nil)
            }
        }
        addToQueue(request)
    }
    
    func getSuggestionsChannel(completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getSuggestionsChannel()
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [ChannelModel]()
                for item in json["data"]["content"].arrayValue {
                    let model = ChannelModel(ChannelDTO(item))
                    models.append(model)
                }
                completion(Result.success(APIResponse(json,data: models)))
            }
        }
        addToQueue(request)
    }
    
    func getListComment(type: ContentType,
                        contentId: String,
                        pager: Pager,
                        completion: @escaping (Result<APIResponse<[CommentModel]>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getListComment(type: type,
                                                                      contentId: contentId,
                                                                      pager: pager)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var comments = [CommentModel]()
                for item in json["data"].arrayValue {
                    comments.append(CommentModel(CommentDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: comments)))
            }
        }
        addToQueue(request)
    }

    func getDownloadLink(_ id: String, completion: @escaping (Result<APIResponse<StreamsModel>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getDownloadLink(id)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let dto = StreamsDTO(json["data"]["streams"])
                let model = StreamsModel(dto)
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
        addToQueue(request)
    }
    
    func getAccountInfoUpload(_ completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getAccountInfoUpload()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
}
