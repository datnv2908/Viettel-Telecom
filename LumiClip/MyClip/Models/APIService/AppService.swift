//
//  AppServicce.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

class AppService : APIServiceObject {
    static let sharedInstance: AppService = {
        let instance = AppService()
        return instance
    }()
    
    func getSettingsNotification(_ completion: @escaping (Result<APIResponse<Bool>>) -> ()) {
        let request = APIRequestProvider.shareInstance.settingsNotificationRequest()
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let isNotification = json["data"]["isNotification"].boolValue
                completion(Result.success(APIResponse(json, data: isNotification)))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
   func sentThemeForApp(isLight : Bool ,_ completion: @escaping (Result<APIResponse<JSON>>) -> ()) {
       let request = APIRequestProvider.shareInstance.sentThemeForApp(isLight: isLight)
       self.serviceAgent.startRequest(request) { (json, error) in
           if error == nil {
               let isNotification = json["data"]["isNotification"].boolValue
               completion(Result.success(APIResponse(json, data: json)))
           } else {
               completion(Result.failure(error!))
           }
       }
       addToQueue(request)
   }
   
    func getNotifications(_ completion: @escaping (Result<APIResponse<[NotificationModel]>>) -> ()) {
        let request = APIRequestProvider.shareInstance.getNotifications()
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let jsons = json["data"]["notifications"].arrayValue
                var models = [NotificationModel]()
                for item in jsons {
                    models.append(NotificationModel(NotificationDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: models)))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func markNotificationAsRead(_ id: String, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.markNotification(id)
        self.serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        }
        addToQueue(request)
    }
    
    func sendFeedBack(error id: String, content: String, objectId: String, type: ContentType, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.sendFeedBack(error: id, content: content, objectId: objectId, type: type)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        }
        addToQueue(request)
    }
    
    func getPackage(_ completion: @escaping (Result<APIResponse<[PackageModel]>>) -> ()) {
        let request = APIRequestProvider.shareInstance.getPackagesRequest()
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let jsons = json["data"].arrayValue
                var models = [PackageModel]()
                for item in jsons {
                    models.append(PackageModel(PackageDTO(item)))
                }
                completion(Result.success(APIResponse(json, data: models, newAccessToken: "", isShowPromotionAPP:0, isConfirmSms:json["is_confirm_sms"].stringValue, content:"", number:"")))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func registerServicePackage(id: String, contentId: String, _ completion: @escaping (Result<APIResponse<String>>) -> ()) {
        let request = APIRequestProvider.shareInstance.registerPackage(id, contentId: contentId)
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(APIResponse(json, data: message)))
            } else {
                let isConfirmSms = json["is_confirm_sms"].stringValue
                if(isConfirmSms == "1"){
                    let message = json["message"].stringValue
                    completion(Result.success(APIResponse(json, data: message, newAccessToken: "", isShowPromotionAPP:0, isConfirmSms:json["is_confirm_sms"].stringValue,
                                                          content:json["content"].stringValue, number:json["number"].stringValue)))
                }else{
                    completion(Result.failure(error!))
                }
            }
        }
        addToQueue(request)
    }
    
    func unregisterServicePackage(id: String, _ completion: @escaping (Result<Any>) -> ()) {
        let request = APIRequestProvider.shareInstance.unregisterPackage(id)
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(message))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func buyRetail(item id: String, type: ContentType, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.buyRetail(item: id, type: type)
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let message = json["message"].stringValue
                completion(Result.success(APIResponse(json, data: message)))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func getKeyword(completion: @escaping (Result<APIResponse<[String]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.getKeywordSearch()
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var keywords = [String]()
                for string in json["data"] {
                    keywords.append(string.1.stringValue)
                }
                completion(Result.success(APIResponse(json, data: keywords)))
            }
        }
        addToQueue(request)
    }
    
    func searchSuggest(query: String, completion: @escaping (Result<APIResponse<[SearchGroupModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.searchSuggetion(query: query)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var groups = [SearchGroupModel]()
                for group in json["data"].arrayValue {
                    groups.append(SearchGroupModel(SearchGroupDTO(group)))
                }
                completion(Result.success(APIResponse(json, data: groups)))
            }
        }
        addToQueue(request)
    }
    
    func searchSuggestMore(query: String, pager: Pager,
                    completion: @escaping (Result<APIResponse<[SearchGroupModel]>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getSearchSuggetionMore(query: query, pager: pager)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var groups = [SearchGroupModel]()
                for group in json["data"].arrayValue {
                    groups.append(SearchGroupModel(SearchGroupDTO(group)))
                }
                completion(Result.success(APIResponse(json, data: groups)))
            }
        }
        addToQueue(request)
    }
    
    func search(query: String, completion: @escaping (Result<APIResponse<[GroupModel]>>) -> Void ) {
        let request = APIRequestProvider.shareInstance.search(query: query)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var groups = [GroupModel]()
                for group in json["data"].arrayValue {
                    groups.append(GroupModel(GroupDTO(group)))
                }
                completion(Result.success(APIResponse(json, data: groups)))
            }
        }
        addToQueue(request)
    }
    
    func searchMore(query: String, pager: Pager,
                    completion: @escaping (Result<APIResponse<[GroupModel]>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getSearchMore(query: query, pager: pager)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                var groups = [GroupModel]()
                for group in json["data"].arrayValue {
                    groups.append(GroupModel(GroupDTO(group)))
                }
                completion(Result.success(APIResponse(json, data: groups)))
            }
        }
        addToQueue(request)
    }
    
    func KpiInit(video id: String, url: String, completion: @escaping (Result<APIResponse<KPIToken>>) -> Void) {
        let request = APIRequestProvider.shareInstance.KpiInitRequest(video: id, url: url)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                let model = KPIToken(json)
                completion(Result.success(APIResponse(json, data: model)))
            }
        }
    }
    
    func KPITrace(_ model: KPIModel, completion: @escaping(Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.KPITraceRequest(model)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(true))
            }
        }
    }
    
    func ReportBySession(_ totalError: Int,_ totalSucess: Int,_ avgTime: Double, completion: @escaping(Result<Any>) -> Void) {
        let request = APIRequestProvider.shareInstance.ReportBySessionRequest(totalError, totalSucess, avgTime)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(true))
            }
        }
    }
    
    func getAccountInfoUpload(_ completion: @escaping (Result<APIResponse<AccountContractInfor>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getAccountInfoUpload()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let model = AccountContractInfor(json)
                completion(Result.success(APIResponse(json, data: model)))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func getContractCondition(_ completion: @escaping (Result<APIResponse<ContractInfor>>) -> Void) {
        let request = APIRequestProvider.shareInstance.getContractCondition()
        self.serviceAgent.startRequest(request) { (json, error) in
            if error == nil {
                let contractInfor = ContractInfor(json)
                completion(Result.success(APIResponse(json, data: contractInfor)))
            } else {
                completion(Result.failure(error!))
            }
        }
        addToQueue(request)
    }
    
    func updateBankPaymentInfor(accountNumber: String, bankName: String, bankDepartment: String, address: String, taxCode: String, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.updateBankPaymentInfor(accountNumber: accountNumber, bankName: bankName, bankDepartment: bankDepartment, address: address, taxCode: taxCode)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        }
        addToQueue(request)
    }
    
    func updateVTPPaymentInfor(phoneNumber: String, address: String, taxCode: String, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.updateVTPPaymentInfor(phoneNumber: phoneNumber, address: address, taxCode: taxCode)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        }
        addToQueue(request)
    }
   func getMutilChannelDetails(_ id: String , getActiveChannel : getAllChannels , completion: @escaping (Result<APIResponse<ChannelDetailsDTO>>) -> Void) {
       let request = APIRequestProvider.shareInstance.getMuttilChannel(id: id,active: getActiveChannel  )
       serviceAgent.startRequest(request) { (json, error) in
           if let err = error {
               completion(Result.failure(err))
           } else {
               let model = ChannelDetailsDTO(json["data"])
               completion(Result.success(APIResponse(json, data: model)))
           }
       }
   }
    func confirmContract(_ status: Int, completion: @escaping (Result<APIResponse<String>>) -> Void) {
        let request = APIRequestProvider.shareInstance.confirmContract(status)
        serviceAgent.startRequest(request) { (json, error) in
            if let err = error {
                completion(Result.failure(err))
            } else {
                completion(Result.success(APIResponse(json, data: json["message"].stringValue)))
            }
        }
        addToQueue(request)
    }
}
