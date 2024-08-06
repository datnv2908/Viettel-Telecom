
//
//  SearchRealmModel.swift
//  MyClip
//
//  Created by Os on 8/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import RealmSwift

class SearchRealmModel: Object {
    @objc dynamic var keyword = ""
    @objc dynamic var date: Date = Date()
    
    override static func primaryKey() -> String? {
        return "keyword"
    }
}
