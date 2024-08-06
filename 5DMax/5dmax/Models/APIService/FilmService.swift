//
//  FilmService.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilmService: APIServiceObject {

    func getHomeFilm(completion: @escaping(([GroupModel], NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getHomeFilm()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            print(json)
            if error == nil {
                var models = [GroupModel]()
                for subJson in json.arrayValue {
                    let dto = GroupDTO(subJson)
                    let model = GroupModel(dto)
                    if !model.content.isEmpty {
                        models.append(model)
                    }
                }
                completion(models, nil)
            } else {
                completion ([GroupModel](), error)
            }
        }
        addToQueue(request)
    }
    func getSeriesFilm(completion: @escaping(([GroupModel], NSError?,SeriesModel?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getSeriesFilm()
        self.serviceAgent.startRequestSeries(request) { (_ json: JSON, _ error: NSError?) in
            print(json)
            if error == nil {
                var models = [GroupModel]()
                for subJson in json["data"].arrayValue {
                    let dto = GroupDTO(subJson)
                    let model = GroupModel(dto)
                    if !model.content.isEmpty {
                        models.append(model)
                    }
                }
                let modelarr = json["data_series"].arrayValue.first
                let serriesModel = SeriesModel(modelarr!)
                completion(models, nil,serriesModel)
            } else {
                completion ([GroupModel](), error,nil)
            }
        }
    }
    func getOddFilm(completion: @escaping(([GroupModel], NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getOddFilm()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            print(json)
            if error == nil {
                var models = [GroupModel]()
                for subJson in json.arrayValue {
                    let dto = GroupDTO(subJson)
                    let model = GroupModel(dto)
                    if !model.content.isEmpty {
                        models.append(model)
                    }
                }
                completion(models, nil)
            } else {
                completion ([GroupModel](), error)
            }
        }
    }
    func getChargesFilm(completion: @escaping(([GroupModel], NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getChargesFilm()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                var models = [GroupModel]()
                for subJson in json.arrayValue {
                    let dto = GroupDTO(subJson)
                    let model = GroupModel(dto)
                    if !model.content.isEmpty {
                        models.append(model)
                    }
                }
                completion(models, nil)
            } else {
                completion ([GroupModel](), error)
            }
        }
        addToQueue(request)
    }   

    func getPlaylist(playListID: String, videoID: String?,
                     profileID: String?,noti : Bool , sendNoti : Bool,completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getDetail(playListID: playListID,
                                                                 videoID: videoID,
                                                                 profileID: profileID, noti: noti, sendNoti: sendNoti)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                // View right web provision device if needed.
                if ViewRightWeb.isDevicePrivisoned() == false {
                    ViewRightWeb.forceProvisionDevice()
                } else {
                    // do nothing
                }
                let dto = PlaylistDTO(json)
                let model = PlayListModel(dto)
                completion(Result.success(model))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func getCollectionPlayList(playListID:String, offset: Int, limit: Int, completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getDetailCollection(playListID: playListID, offset: offset, limit: limit)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let dto = NewUpdateDTO(json)
                let model = GroupModel(groupUpdate: dto)
                completion(Result.success(model))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func getVideoTrailer(ItemId: String, comletion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getVideoTrailer(ItemId)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let dto = StreamDTO(json["streams"])
                let model = StreamModel(dto)
                comletion(Result.success(model))
            } else {
                comletion(Result.failure(error!))
            }
        }
    }
    
    func getPlaylistStream(playListID: String, videoID: String?, profileID: String?,
                           completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getPlaylistStream(playListID: playListID,
                                                                         videoID: videoID, profileID: profileID)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                // View right web provision device if needed.
                if ViewRightWeb.isDevicePrivisoned() == false {
                    ViewRightWeb.forceProvisionDevice()
                } else {
                    // do nothing
                }
                let dto = StreamDTO(json["streams"])
                let model = StreamModel(dto)
                completion(Result.success(model))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }

    func getMoreContent(id: String, offset: Int, limit: Int, completion: @escaping((GroupModel?, NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getMoreContent(id: id, offset: offset, limit: limit)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let dto = GroupDTO(json)
                let model = GroupModel(dto)
                completion(model, nil)
            } else {
                completion (nil, error)
            }
        }
        addToQueue(request)
    }
    
    func getCollectionMoreContent(id: String, offset: Int, limit: Int, isSeries: Bool?, completion: @escaping((GroupModel?, NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getCollectionMoreContent(id: id, offset: offset, limit: limit, isSeries: isSeries)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let dto = GroupDTO(json)
                let model = GroupModel(dto)
                completion(model, nil)
            } else {
                completion (nil, error)
            }
        }
        addToQueue(request)
    }
    
    func addFilmToMyList(id: String, completion: @escaping((_ isAdd: Bool, _ err: NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.toggleLikePlaylist(id: id)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {

                let isAdd = json["isLike"].boolValue
                completion(isAdd, nil)
            } else {
                completion (false, error)
            }
        }
        addToQueue(request)
    }

    func registerService(packageID: String, contentType: String, contentName: String, completion: @escaping((_ json: JSON, _ error: NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.registerService(packageID: packageID, contentType: contentType, contentName: contentName)
        self.serviceAgent.startRequestWithConfirmSMS(request) { (_ json: JSON, _ error: NSError?) in
            completion(json, error)
        }
        addToQueue(request)
    }

    func unRegisterService(package: PackageModel, completion: @escaping((NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.unRegisterService(package: package)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(nil)
            } else {
                completion (error)
            }
        }
        addToQueue(request)
    }

    func buyFilm(id: String, type: String, completion: @escaping((NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.buy(id: id, type: type)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(nil)
            } else {
                completion (error)
            }
        }
        addToQueue(request)
    }
    func getRelateFilmBySeason(id : String , completion: @escaping((_ json: JSON, _ error: NSError?) -> Void)){
        let request = APIRequestProvider.shareInstance.getRelateFilm(id: id)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(json,nil)
            } else {
                completion(json,error)
            }
        }
        addToQueue(request)
    }
    func search(keyword: String, completion: @escaping((GroupModel?, NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.search(query: keyword)
        self.serviceAgent.startRequestSearch(request) { (json, error) in
            if error == nil {
                if let subJson = json.arrayValue.first {
                    let dto = GroupDTO(subJson)
                    let model = GroupModel(dto)
                    completion(model, nil)
                } else {
                    let dto = GroupDTO(json)
                    let model = GroupModel(dto)
                    completion(model, nil)
                }
            } else {
                if (error?.code == 888888) {
                    if let subJson = json.arrayValue.first {
                        let dto = GroupDTO(subJson)
                        let model = GroupModel(dto)
                        completion(model, error)
                    } else {
                        let dto = GroupDTO(json)
                        let model = GroupModel(dto)
                        completion(model, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
        addToQueue(request)
    }

    func removeFromHistory(_ id: String, _ completion: @escaping (Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.removeFromHistory(id)
        self.serviceAgent.startRequest(request) { (_, error) in
            if error != nil {
                completion(Result.failure(error!))
            } else {
                completion(Result.success(true))
            }
        }
        addToQueue(request)
    }
    
    func KPITrace(_ model: KPIModel, completion: @escaping((NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.KPITraceRequest(model)
        serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                completion(nil)
                print("Sent time success")
                
            } else {
                completion (error)
            }
        }
        addToQueue(request)
    }
}
