//
//  ChannelRowModel.swift
//  MyClip
//
//  Created by Os on 8/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct ChannelRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var objectID: String
    var isSelected: Bool
    var numberRegister: Int
    var freeVideo: Bool
    init(title: String, image: String, identifier: String, objectId: String, isSelected: Bool) {
        self.title = title
        self.desc = ""
        self.image = image
        self.identifier = identifier
        self.objectID = objectId
        self.isSelected = isSelected
        self.numberRegister = 0
      freeVideo = false
    }
    
    init(title: String, desc: String, image: String, identifier: String, numberRegister: Int) {
        self.title = title
        self.desc = ""
        self.image = image
        self.identifier = identifier
        self.objectID = ""
        self.isSelected = false
        self.numberRegister = numberRegister
        freeVideo = false
    }
}
