//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import Foundation
import UIKit
import RealmSwift

class SearchInteractor: NSObject {
    var presenter: SearchInteractorOutput?
    let service = AppService()
}

extension SearchInteractor: SearchInteractorInput {
    func getHistorySearch(keyword: String) -> [SearchRealmModel] {
        service.cancelAllRequests()
        let realm = try! Realm()
        let data = realm.objects(SearchRealmModel.self).filter("keyword contains %@", keyword)
        let list = data.sorted(byKeyPath: "date")
        var models = [SearchRealmModel]()
        for model in list.reversed() {
            models.append(model)
        }
        return models
    }
    
    func deleteHistorySearch(_ object: SearchRealmModel) {
        service.cancelAllRequests()
        let realm = try! Realm()
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func deleteAllHistorySearch() {
        service.cancelAllRequests()
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func getKeyword(completion: @escaping (Result<APIResponse<[String]>>) -> Void) {
        service.getKeyword { (result) in
            completion(result)
        }
    }
    
    func search(query: String, completion: @escaping (Result<APIResponse<[GroupModel]>>) -> Void) {
        service.search(query: query) { (result) in
            completion(result)
        }
    }
    
    func getMoreDataSearch(query: String, pager: Pager, completion: @escaping (Result<APIResponse<[GroupModel]>>) -> Void) {
        service.searchMore(query: query, pager: pager) { (result) in
            completion(result)
        }
    }
    
    func searchSuggest(query: String, completion: @escaping (Result<APIResponse<[SearchGroupModel]>>) -> Void) {
        service.cancelAllRequests()
        service.searchSuggest(query: query) { (result) in
            completion(result)
        }
    }
    
    func getMoreDataSearchSuggest(query: String, pager: Pager, completion: @escaping (Result<APIResponse<[SearchGroupModel]>>) -> Void) {
        service.cancelAllRequests()
        service.searchSuggestMore(query: query, pager: pager) { (result) in
            completion(result)
        }
    }
}
