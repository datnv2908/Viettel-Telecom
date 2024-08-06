//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PlayerInteractor: PlayerInteractorInputProtocol {
  
    weak var presenter: PlayerInteractorOutputProtocol?

    fileprivate var service = FilmService()
    init() {}

    func getPlayListDetail(_ filmId: String, partId: String?,noti :Bool, sendNoti : Bool) {
        service.getPlaylist(playListID: filmId, videoID: partId, profileID: nil, noti: noti, sendNoti: sendNoti) { (_ result) in
            self.presenter?.didGetPlayListDetail(result)
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

    func requestM3u8(_ urlString: String) {
        if let url = URL(string: urlString) {
            Alamofire.request(url).responseData { (response: DataResponse<Data>) in
                guard let data = response.result.value else {
                    self.presenter?.didGetM3u8File(content: nil)
                    return
                }
                let file = String(data: data, encoding: String.Encoding.utf8)
                self.presenter?.didGetM3u8File(content: file)
            }
        } else {
            self.presenter?.didGetM3u8File(content: nil)
        }
    }

    func registPackage(_ id: String, contentType: String, contentName: String) {
        service.registerService(packageID: id,
                                contentType: contentType,
                                contentName: contentName,
                                completion:
        { (json: JSON, err: NSError?) in
            if err != nil {
                if(json["is_confirm_sms"].intValue == 1){
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
    
    //Manhhx
    func KPITrace(_ model: KPIModel, completion: @escaping((NSError?) -> Void)) {
        service.KPITrace(model) { (error) in
            if let err = error {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }

    func cancelAllRequests() {
        service.cancelAllRequests()
    }

    deinit {
        service.cancelAllRequests()
    }
}
