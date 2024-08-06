//
//  NotificationServices.swift
//  imuzik
//
//  Created by hnc on 11/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

protocol NotificationServicesDelegate {
    func didUpdateNotifi(in: NotificationServices, model: NotificationObject)
}

class NotificationServices: NSObject {
    static let sharedInstance: NotificationServices = {
        let instance = NotificationServices()
        return instance
    }()
    
    var delegate: NotificationServicesDelegate?
    
    func saveNotify(_ model: NotificationModel) {
        let realm = try! Realm()
        let object = NotificationObject()
        if (realm.objects(NotificationObject.self).filter("userId =%@", model.userId).filter("localID =%@", model.localID).first == nil) {
            try! realm.write({
                object.initalize(from: model)
                realm.add(object, update: true)
            })
        } else {
            let item = realm.objects(NotificationObject.self).filter("localID =%@", model.localID)
            for i in item {
                if i.userId != model.userId {
                    try! realm.write({
                        object.initalize(from: model)
                        realm.add(object, update: true)
                    })
                } else {
                    model.isRead = i.isRead
                    try! realm.write({
                        object.initalize(from: model)
                        realm.add(object, update: true)
                    })
                }
            }
        }
    }
    
    func getNotification() -> [NotificationModel] {
        guard let user = DataManager.getCurrentMemberModel() else {
            return [];
        }
        
        let realm = try! Realm()
        var result: [NotificationModel] = []
        let data = realm.objects(NotificationObject.self).sorted(byKeyPath: "senttime", ascending: false).filter("userId =%@", "\(user.userId)")
        for entity in data {
            let model = NotificationModel(object: entity)
            result.append(model)
        }
        return result
    }
    
    func getUnreadNotification() -> [NotificationModel] {
        guard let user = DataManager.getCurrentMemberModel() else {
            return [];
        }
        let realm = try! Realm()
        var result: [NotificationModel] = []
        let data = realm.objects(NotificationObject.self).sorted(byKeyPath: "senttime", ascending: false).filter("userId =%@", "\(user.userId)")
        let maxIndex = data.count > 2 ? 2 : data.count
        
        for i in 0..<maxIndex {
            let entity = data[i]
            if entity.isRead == false {
                let model = NotificationModel(object: entity)
                result.append(model)
            }
        }
        return result
    }
    
    func getUnreadNotificationCount() -> Int {
        guard let user = DataManager.getCurrentMemberModel() else {
            return 0;
        }
        let realm = try! Realm()
        let data = realm.objects(NotificationObject.self).filter("userId =%@", "\(user.userId)").filter({$0.isRead == false})
        return data.count
    }
    
    func updateStatus(_ model: NotificationModel) {
        let realm = try! Realm()
        let notiModel = NotificationObject()
        let predicate = NSPredicate(format: "localID = %@", model.localID)
        if realm.objects(NotificationObject.self).filter(predicate).first != nil {
            if model.groupId.isEmpty {
                notiModel.initalize(from: model)
                notiModel.isRead = true
                try! realm.write({
                    realm.add(notiModel, update: true)
                    delegate?.didUpdateNotifi(in: self, model: notiModel)
                })
            } else {
                notiModel.initalize(from: model)
                notiModel.isRead = true
                try! realm.write({
                    realm.add(notiModel, update: true)
                    delegate?.didUpdateNotifi(in: self, model: notiModel)
                })
            }
        }
    }
    
    func updateNotificationObjectReaded(_ model: NotificationObject) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "localID = %@", model.localID)
        if let saveItem =  realm.objects(NotificationObject.self).filter(predicate).first {
            try! realm.write({
                saveItem.isRead = true
                realm.add(saveItem, update: true)
                delegate?.didUpdateNotifi(in: self, model: saveItem)
            })
        } else {
            
        }
    }
}
