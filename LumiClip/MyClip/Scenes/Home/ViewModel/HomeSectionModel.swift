//
//  HomeSectionModel.swift
//  MyClip
//
//  Created by Os on 8/29/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeSectionModel {
    var title: String
    var identifier: String?
    var objectId: String
    
    init(title: String, identifier: String, objectId: String) {
        self.title = title
        self.identifier = identifier
        self.objectId = objectId
    }
}
