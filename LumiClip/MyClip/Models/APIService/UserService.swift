//
//  UserService.swift
//  MyClip
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
import DateToolsSwift

class UserService: APIServiceObject {

    func authorize(type: LoginType,
                   username: String?,
                   password: String?,
                   captcha: String?,
                   accessToken: String?,
                   completion: @escaping (Result<APIResponse<MemberModel>>) -> (Void)) {
        let request = APIRequestProvider.shareInstance.authorize(type: type,
                                                                 username: username,
                                                                 password: password,
                                                                 captcha: captcha,
                                                                 accessToken: accessToken)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = MemberModel(MemberDTO(json["data"]))
                DataManager.saveMemberModel(model)
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
        addToQueue(request)
    }    
    
    func registerDeviceToken(completion: @escaping (Result<Any>) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: Constants.kDeviceToken), let _ = DataManager.getCurrentMemberModel() else {
            return
        }
        let request = APIRequestProvider.shareInstance.registerDeviceTokenRequest(token: token)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(true))
            }
        }
        addToQueue(request)
    }

    func logout(_ completion: @escaping((Result<Any>) -> Void)) {
        guard let refreshToken = DataManager.getCurrentMemberModel()?.refreshToken else {
            completion(Result.success(true))
            return
        }
        let request = APIRequestProvider.shareInstance.logoutRequest(token: refreshToken)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(Result.success(true))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func changePassword(oldPassword: String, newPassword: String, reNewPassword: String,
                                             captcha: String, completion: @escaping (Result<String>) -> Void) {
        let request = APIRequestProvider.shareInstance.changePassword(oldPassword: oldPassword, newPassword: newPassword,
                                                                      repeatPassword: reNewPassword, captcha: captcha)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(json["message"].stringValue))
            }
        })
        addToQueue(request)
    }
    
    func mapAccount(msidn: String, otp: String, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.mapAccount(msidn: msidn, otp: otp)
        self.serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue, newAccessToken: json["data"]["newAccessToken"].stringValue, isShowPromotionAPP:json["data"]["isShowPromotionAPP"].intValue, isConfirmSms:"", content:"", number:"")))
            }
        })
        addToQueue(request)
    }
    
    func getOTP(msidn: String, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getOTP(msidn: msidn)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        })
        addToQueue(request)
    }
    
    func getAccountSettings(completion: @escaping (Result<APIResponse<AccountSettingsModel>>) -> (Void) ) {
        let request = APIRequestProvider.shareInstance.getAccountSettings()
        serviceAgent.startRequest(request, completion:{ (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = AccountSettingsModel(AccountSettingsDTO(json["data"]))
                DataManager.saveAccountSettingsModel(model)
                completion(Result.success(APIResponse(json, data: model)))
            }
        })
        addToQueue(request)
    }
    
    func getFollowedChannels(pager: Pager, includeHot: Int, completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getFollowChannel(limit: pager.limit, offset: pager.offset, includeHot: includeHot)
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
    
    func getHotChannels(completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getHotChannel()
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
    
    func getHotCategory(completion: @escaping (Result<APIResponse<[CategoryModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getHotCategory()
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [CategoryModel]()
                for item in json["data"]["content"].arrayValue {
                    let model = CategoryModel(CategoryDTO(item))
                    models.append(model)
                }
                completion(Result.success(APIResponse(json,data: models)))
            }
        }
        addToQueue(request)
    }
    
    func getAllPlaylist(completion: @escaping (Result<APIResponse<[PlaylistModel]>>) -> (Void)) {
        let request = APIRequestProvider.shareInstance.getAllPlaylist()
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var list = [PlaylistModel]()
                
                for(_, subjson) in json["data"]["content"] {
                    let model = PlaylistModel(PlaylistDTO(subjson))
                    list.append(model)
                }
                completion(Result.success(APIResponse(json, data: list)))
            }
        })
        addToQueue(request)
    }
    
    func getPublicPlaylist(_ categoryId: String, pager: Pager, completion: @escaping (Result<APIResponse<[PlaylistModel]>>) -> (Void)) {
        let request = APIRequestProvider.shareInstance.getPublicPlaylist(categoryId: categoryId, pager: pager)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var list = [PlaylistModel]()
                
                for(_, subjson) in json["data"]["content"] {
                    let model = PlaylistModel(PlaylistDTO(subjson))
                    list.append(model)
                }
                completion(Result.success(APIResponse(json, data: list)))
            }
        })
        addToQueue(request)
    }
    
    func createPlaylist(name: String, description: String, completion: @escaping((Result<APIResponse<PlaylistModel>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.createPlaylist(name: name, description: description)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = PlaylistModel(PlaylistDTO(json["data"]["playlist"]))
                completion(Result.success(APIResponse(json, data: model)))
            }
        })
        addToQueue(request)
    }
    
    func updatePlaylist(id: String, name: String, description: String, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.updatePlaylist(id: id, name: name, description: description)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(json))
            }
        })
        addToQueue(request)
    }
    
    func removePlaylist(id: String, completion: @escaping((Result<APIResponse<String>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.deletePlaylist(id: id)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        })
        addToQueue(request)
    }
    
    func getChannelDetails(_ id: String, completion: @escaping (Result<APIResponse<ChannelDetailsModel>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getDetailChannel(id: id)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = ChannelDetailsModel(ChannelDetailsDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
    }
    
    func getFollowContent(completion: @escaping (Result<APIResponse<FollowContentModel>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getFollowContent()
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = FollowContentModel(FollowContentDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
    }
    
    func followMultiChannel(ids: String,
                             status: Int,
                             notificationType: Int,
                             completion: @escaping (Result<APIResponse<Any>>) -> Void) {
        let request = APIRequestProvider.shareInstance.followMultiChannel(ids: ids, status: status, notificationType: notificationType)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: true)))
                NotificationCenter.default.post(name: .kNotificationShouldReloadFollow, object: nil, userInfo: nil)
            }
        }
    }
    
    func updateChannel(name: String, description: String, _ completion: @escaping (Result<Any>) -> ()) {
        let request = APIRequestProvider.shareInstance.updateChannel(name: name, description: description)
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        }
    }
    
    func getChannelInfor(id: String, _ completion: @escaping (Result<APIResponse<ChannelDetailsModel>>) -> ()) {
        let request = APIRequestProvider.shareInstance.getChannelInfor(id)
        self.serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = ChannelDetailsModel(ChannelDetailsDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
    }
    
    func registerPromotionApp(_ completion: @escaping (Result<Any>) -> ()) {
        let request = APIRequestProvider.shareInstance.registerPromotionApp()
        serviceAgent.startRequest(request, completion: { (json,error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        })
    }
    
    func getRelatedChannels(channelId: String, _ completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getRelatedOfChannel(id: channelId)
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
    
    func removeRelatedChannel(channelId: String, _ completion: @escaping (Result<Any>) -> ()) {
        let request = APIRequestProvider.shareInstance.removeRelatedOfChannel(id: channelId)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        })
    }
    
    func addRelatedChannel(channelId: String, _ completion: @escaping (Result<Any>) -> ()) {
        let request = APIRequestProvider.shareInstance.addRelatedOfChannel(id: channelId)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        })
    }
    
    func getHotChannelByAcc(channelId: String, _ completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getHotChannelByAcc(id: channelId)
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
    
    func searchChannelRelatedSuggestion(queryContent: String, _ completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.searchChannelRelatedSuggestion(query: queryContent)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [ChannelModel]()
                for group in json["data"].arrayValue {
                    for item in group["content"].arrayValue {
                        let model = ChannelModel(ChannelDTO(item))
                        models.append(model)
                    }
                    break;
                }
                completion(Result.success(APIResponse(json,data: models)))
            }
        }
        addToQueue(request)
    }
   func getDetailChannelAndUserEdit(id: String,type :  typeEditChannel , _ completion: @escaping (Result<APIResponse<ChannelEndUserEditModel>>) -> ()) {
       let request = APIRequestProvider.shareInstance.getDetailChannelAndUserEdit(id: id, type: type)
       self.serviceAgent.startRequest(request) { (json, error) in
           if let err = error {
               completion(Result.failure(err))
           }else{
               let model = ChannelEndUserEditModel(json["data"]["detail"])
               completion(Result.success(APIResponse(json, data: model)))
           }
       }
   }
}
