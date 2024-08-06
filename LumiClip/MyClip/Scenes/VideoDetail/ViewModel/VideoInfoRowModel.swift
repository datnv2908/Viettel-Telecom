//
//  VideoInfoRowModel.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct VideoInfoRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var objectID: String
    var numberLike: String
    var numberDislike: String
    var isExpand: Bool
    var likeStatus: LikeStatus
    var downloadStatus: DownloadStatus = DownloadStatus.new
    var freeVideo: Bool
    init(_ model: DetailModel, isExpand: Bool) {
        self.isExpand = isExpand
        title = model.name
        desc = "\(model.playTimes) \(String.luot_xem.lowercased())"
        image = model.coverImage
        identifier = VideoInfoTableViewCell.nibName()
        objectID = model.id
        numberLike = model.likeCount.isEmpty ? "0" : model.likeCount
        numberDislike = model.dislikeCount.isEmpty ? "0" : model.dislikeCount
        likeStatus = model.likeStatus
        freeVideo = model.freeVideo
    }
}
