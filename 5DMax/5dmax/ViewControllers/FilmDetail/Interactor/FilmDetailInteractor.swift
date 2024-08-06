//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import SwiftyJSON

class FilmDetailInteractor: FilmDetailInteractorInputProtocol {
    
    weak var presenter: FilmDetailInteractorOutputProtocol?
    var service: FilmService = FilmService()

    init() {}

    func getPlayListDetail(_ listId: String, _ partId: String?, noti : Bool, sendNoti : Bool) {
        weak var wself = self
        service.cancelAllRequests()
        service.getPlaylist(playListID: listId, videoID: partId, profileID: nil, noti: noti, sendNoti: sendNoti) { (_ result) in
            wself?.presenter?.didGetPlayListDetail(result)
            
        }
    }

    func getStream(_ filmId: String, partId: String?, completion: @escaping (Result<Any>) -> Void) {
        service.getPlaylistStream(playListID: filmId, videoID: partId, profileID: nil) { (_ result) in
            completion(result)
        }
    }
    
    func getVideoTrailer(_ ItemId: String, completion: @escaping (Result<Any>) -> Void) {
        service.getVideoTrailer(ItemId: ItemId) { (_ result) in
            completion(result)
        }
    }
    
    func addOrRemoveFilmToMyList(_ id: String) {
        weak var wself = self
        service.addFilmToMyList(id: id) { (isAdd: Bool, err: NSError?) in
            wself?.presenter?.didAddOrRemoveFilmToMyList(err: err, isAdd: isAdd)
        }
    }

    func registPackage(_ id: String, contentType: String, contentName: String, isRegisterFast: Bool) {
        service.registerService(packageID: id,
                                contentType: contentType,
                                contentName: contentName,
                                completion: { (json: JSON, err: NSError?) in
            if err != nil {
                if(json["is_confirm_sms"].intValue == 1){
                   self.presenter?.didRegistPackageWithSMS(message: json["message"].stringValue,
                                                           number: json["number"].stringValue,
                                                           smsContent: json["content"].stringValue,
                                                           isRegisterFast: isRegisterFast)
                } else {
                    self.presenter?.didRegistPackage(Result.failure(err!))
                }
            } else {
                 self.presenter?.didRegistPackage(Result.success(true))
            }
        })
    }
    
    func registPackage(_ model: PopupModel, contentType: String, contentName: String) {
        service.registerService(packageID: model.packageId,
                                contentType: contentType,
                                contentName: contentName,
                                completion: { (json: JSON, err: NSError?) in
            if err != nil {
                if (json["is_confirm_sms"].intValue == 1 && model.isConfirmSMS){
                    self.presenter?.didRegistPackageWithSMS(message: json["message"].stringValue,
                                                            number: json["number"].stringValue,
                                                            smsContent: json["content"].stringValue)
                } else {
                    self.presenter?.didRegistPackage(Result.failure(err!))
                }
            } else {
                self.presenter?.didRegistPackage(Result.success(true))
            }
        })
    }

    func buyRetail(_ id: String, type: String, completion: @escaping (Result<Any>) -> Void) {
        service.buyFilm(id: id, type: type) { (error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(true))
            }
        }
    }
    func getRelateFilmBySeason(_ itemId: String, completion: @escaping (Result<[PartModel]>) -> Void) {
        service.getRelateFilmBySeason(id: itemId) { (json, error) in
            if let err = error {
                completion(Result.failure(err as! Error))
            }else{
                var parts = [PartModel]()
                for subJson in json["parts"].arrayValue {
                    let modelOTD = PartDTO(subJson)
                    let model = PartModel(modelOTD)
                    parts.append(model)
                }
                completion(Result.success(parts))
            }
            
        }
    }
    func getSerriFilm(_ itemId: String, completion: @escaping (Result<SeriModel>) -> Void) {
           service.getRelateFilmBySeason(id: itemId) { (json, error) in
               if let err = error {
                   completion(Result.failure(err as! Error))
               }else{
                   let serri = SeriModel(json)
                   completion(Result.success(serri))
               }
               
           }
       }
    deinit {
        service.cancelAllRequests()
    }
}
