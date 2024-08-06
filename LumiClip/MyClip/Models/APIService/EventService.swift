//
//  EventService.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventService: APIServiceObject {
    func getConfig(_ completion: @escaping((Result<APIResponse<EventConfigModel>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getConfigs()
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let models = EventConfigModel(EventConfigDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
        addToQueue(request)
    }
    func getPoints(_ completion: @escaping((Result<APIResponse<PointModel>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getPoints()
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let models = PointModel(PointDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
        addToQueue(request)
    }
    
    func getMonthAward(for monthReport: String,
                       page: Int,_ completion: @escaping((Result<APIResponse<[UserAwardModel]>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getMonthAward(monthReport: monthReport, page: page)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [UserAwardModel]()
                for item in json["data"].arrayValue {
                    models.append(UserAwardModel(UserAwardDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
        addToQueue(request)
    }
    
    func getWeekAward(fromDate: String, toDate: String,
                       page: Int,_ completion: @escaping((Result<APIResponse<[UserAwardModel]>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getWeekAward(fromDate: fromDate, toDate: toDate, page: page)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var models = [UserAwardModel]()
                for item in json["data"].arrayValue {
                    models.append(UserAwardModel(UserAwardDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
        addToQueue(request)
    }
    
    func getMonthEarning(limit: Int,_ completion: @escaping((Result<APIResponse<EarningInfoModel>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getMonthEarning(limit: limit)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let models = EarningInfoModel(EarningInfoDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
        addToQueue(request)
    }
    
    func getMonthEarningMore(limit: Int, offset: Int,_ completion: @escaping((Result<APIResponse<EarningInfoModel>>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getMonthEarningMore(limit: limit, offset: offset)
        serviceAgent.startRequest(request, completion: { (json,error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let models = EarningInfoModel(EarningInfoDTO(json["data"]))
                completion(Result.success(APIResponse(json, data: models)))
            }
        })
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
    
    func getAccountOTP(msisdn: String, _ completion: @escaping((Result<Any>) -> Void)) {
        let request = APIRequestProvider.shareInstance.getAccountOTP(msisdn:msisdn)
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
