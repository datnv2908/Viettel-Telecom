//
//  SearchHistoryModel.swift
//  5dmax
//
//  Created by admin on 10/5/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class SearchHistoryModel: NSObject {
    var keyId: String?
    var keySearch: String?
    
    init(keyID: String, search: String) {
        keyId = keyID
        keySearch = search
    }
}
