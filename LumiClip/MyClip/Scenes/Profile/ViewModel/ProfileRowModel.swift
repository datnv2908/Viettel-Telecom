//
//  ProfileRowModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct ProfileRowModel: PBaseRowModel {
    var objectID: String
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var type: ProfileTypeEnum
    var thumbImage: UIImage
    var freeVideo: Bool
    init(type: ProfileTypeEnum) {
        self.type = type
        title = type.title()
        desc = ""
        image = ""
        identifier = ProfileTableViewCell.nibName()
        thumbImage = type.image()
        objectID = ""
        freeVideo = false
    }
}
