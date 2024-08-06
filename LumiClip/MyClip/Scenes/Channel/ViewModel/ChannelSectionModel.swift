//
//  ChannelSectionModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class ChannelSectionModel {
    var title: String
    var identifier: String?
    var objectId: String
    
    init(title: String, identifier: String, objectId: String) {
        self.title = title
        self.identifier = identifier
        self.objectId = objectId
    }
}
