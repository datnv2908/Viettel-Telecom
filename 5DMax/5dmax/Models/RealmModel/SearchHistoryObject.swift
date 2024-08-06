//
//  SearchHistoryModel.swift
//  5dmax
//
//  Created by admin on 9/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class SearchHistoryObject: Object {
    
    @objc dynamic var keyID: String = ""
    @objc dynamic var keySearch: String = ""
    
    func initSearch(_ model: SearchHistoryModel) {
        keyID = model.keyId!
        keySearch = model.keySearch!
    }
    
    override static func primaryKey() -> String {
        return "keyID"
    }
}
