//
//  VideoDetailModel.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class VideoDetailModel: NSObject {
    var detail: DetailModel
    var streams: StreamsModel
    var relates: GroupModel
    var playlist: GroupModel
    var nextId: String
    var previousId: String
    
    init(_ dto: VideoDetailDTO) {
        detail = DetailModel(dto.detail)
        streams = StreamsModel(dto.streams)
        relates = GroupModel(dto.relates)
        playlist = GroupModel(dto.playlist)
        nextId = dto.nextId == "0" ? "" : dto.nextId
        previousId = dto.previousId == "0" ? "" : dto.previousId
    }

    init(download model: DownloadModel) {
        detail = DetailModel(download: model)
        streams = StreamsModel(download: model)
        relates = GroupModel()
        playlist = GroupModel()
        nextId = ""
        previousId = ""
    }
}
