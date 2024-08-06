//
//  EventSectionModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/24/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation

class EventSectionModel {
    var title: String
    var identifier: String?
    var objectId: String
    
    init(title: String, identifier: String, objectId: String) {
        self.title = title
        self.identifier = identifier
        self.objectId = objectId
    }
}
