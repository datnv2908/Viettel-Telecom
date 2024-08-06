//
//  SearchServices.swift
//  5dmax
//
//  Created by admin on 10/2/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class SearchServices: NSObject {
    static let sharedInstance: SearchServices = {
        let instance = SearchServices()
        return instance
    }()
    
    func saveHistorySearch(model: SearchHistoryModel) {
        let realm = try! Realm()
        var object = SearchHistoryObject()
        if let savedObject = realm.objects(SearchHistoryObject.self).first{
            let item = realm.objects(SearchHistoryObject.self).filter({$0.keySearch == model.keySearch})
            if item.count == 0 {
                try! realm.write({
                    object.initSearch(model)
                    realm.add(object, update: true)
                })
            }
        } else {
            try! realm.write({
                object.initSearch(model)
                realm.add(object, update: true)
            })
        }
    }
    
    func deleteHistorySearch(_ id: String) {
        let realm = try! Realm()
        let items = realm.objects(SearchHistoryObject.self).filter({$0.keyID == id})
        for item in items {
            realm.beginWrite()
            realm.delete(item)
            try! realm.commitWrite()
        }
    }
    
    
    func getSearchHistory() -> [SearchHistoryObject] {
        let realm = try! Realm()
        var result: [SearchHistoryObject] = []
        let data = realm.objects(SearchHistoryObject.self).sorted(byKeyPath: "keyID")
        result.append(contentsOf: data)
        return result
    }
}
