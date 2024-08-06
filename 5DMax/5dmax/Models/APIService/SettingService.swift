//
//  SettingService.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingService: APIServiceObject {
    
    func getGamerUrl(completion: ((String, NSError?) -> (Void))?) {
        let request = APIRequestProvider.shareInstance.getGamerUrl()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                var gamerUrl = ""
                gamerUrl = json["urlGame"].string ?? ""
                
                if let block = completion {
                    block(gamerUrl, nil)
                }
            } else {
                
                if let block = completion {
                    block("", error)
                }
                DLog("lấy game " + (error?.localizedDescription)!)
            }
        }
        addToQueue(request)
    }
    
    func getSetting(completion: @escaping((SettingModel?, NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.getSetting()
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                let dto = SettingDTO(json)
                let model = SettingModel(dto)
                completion(model, nil)
            } else {
                completion (nil, error)
            }
        }
        addToQueue(request)
    }
    
    func mpsDetectLink(_ url: String, completion: @escaping((String?, NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.mpsDetectLink(url)
        self.serviceAgent.startRequestBase(request) { (_ str: String, _ error: NSError?) in
            if error == nil {
                completion(str, nil)
            } else {
                completion (nil, error)
            }
        }
        addToQueue(request)
    }
    
    func feedBack(id: String, content: String, itemId: String,
                  type: String, completion: @escaping((NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.feedback(id: id, content: content, itemId: itemId, type: type)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                completion(nil)
            } else {
                completion (error)
            }
        }
        addToQueue(request)
    }
    
    func searchSuggestion(search: String, completion:@escaping((GroupModel?, NSError?) -> Void)) {
        let request = APIRequestProvider.shareInstance.searchSuggestion(query: search)
        self.serviceAgent.startRequest(request) { (_ json: JSON, _ error: NSError?) in
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
                completion(nil,error)
            }
        }
        addToQueue(request)
    }
    
    func listNotification(completion: (([NotificationModel], NSError?) -> (Void))?) {
        let request = APIRequestProvider.shareInstance.getListNotification()
        self.serviceAgent.startRequestNotify(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                var dtos: [NotificationModel] = []
                    for subJson in json.arrayValue {
                    let dto = NotificationDTO(subJson)
                    let model = NotificationModel(dto)
                    dtos.append(model)
                }
                
                if let block = completion {
                    block(dtos, nil)
                }
            } else {
                
                if let block = completion {
                    block([], error)
                }
//                DLog("tải thông báo bị lỗi " + (error?.localizedDescription)!)
            }
        }
        addToQueue(request)
    }
    
    //Manhhx them phan confirm sms
    func listPackage(completion: (([PackageModel], Bool, Bool, NSError?) -> (Void))?) {
        let request = APIRequestProvider.shareInstance.getListPackage()
        self.serviceAgent.startRequestWithConfirmSMS(request) { (_ json: JSON, _ error: NSError?) in
            if error == nil {
                
                var dtos: [PackageModel] = []
                
                for subJson in json["data"].arrayValue {
                    let dto = PackageDTO(subJson)
                    let model = PackageModel(dto)
                    dtos.append(model)
                }
                
                DataManager.saveListPackage(dtos)
                
                if let block = completion {
                    block(dtos, json["is_confirm_sms"].boolValue, json["is_register_fast"].boolValue, nil)
                }
                DLog("Lưu các gói dịch vụ")
            } else {
                
                if let block = completion {
                    block([], false, false, error)
                }
                DLog("tải dữ liệu gói dịch vụ bị lỗi " + (error?.localizedDescription)!)
            }
        }
        addToQueue(request)
    }
    
}
