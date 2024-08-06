//
//  RelateVideoRowModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct RelateVideoRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var objectID: String
    var postedAt: String
    var userName: String = ""
    var freeVideo: Bool
    init(_ model: ContentModel) {
        title = model.name
        desc = "\(model.play_times) \(String.luot_xem.lowercased())"
        image = model.coverImage
        identifier = VideoSmallImageTableViewCell.nibName()
        objectID = model.id
        postedAt = model.publishedTime
       freeVideo = model.freeVideo
    }
    
    init(download: DownloadObject) {
        title = download.name
        desc = "\(download.playTimes) \(String.luot_xem.lowercased())"
        image = download.coverImage
        identifier = VideoSmallImageTableViewCell.nibName()
        objectID = download.id
        postedAt = download.publishedTime
        userName = download.userName
        freeVideo =  false
     }
}
