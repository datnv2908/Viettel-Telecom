



//
//  UploadRowModel.swift
//  MyClip
//
//  Created by hnc on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class UploadRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var objectID: String
    var percent: Float
    var time: String
    var thumbImage: UIImage
    var status: UploadStatus
    var freeVideo: Bool
    init(_ model: UploadModel, identifier: String = UploadTableViewCell.nibName()) {
        title = model.title
        desc = String.dang_cho
        image = ""
        self.identifier = identifier
        objectID = ""
        percent = model.percent
        let asset = AVAsset(url: model.videoUrl)
        thumbImage = model.thumbImage
        self.status = model.status
        time = ""
        freeVideo = false
        let duration = asset.duration
        time = self.convertPlayerTime(time: duration)
        if status == .uploading {
            desc = "\(String.dang_tai_len)... \(Int(model.percent*100))%"
        }
        if model.percent == 1 {
            desc = String.dang_xu_ly
        }
        if model.status == .error {
            desc = String.tai_len_loi
        }
     
    }
    
    func convertPlayerTime(time: CMTime) -> String {
        if time.isValid == false || time.isIndefinite == true {
            return "00:00"
        }
        let timeValue = CMTimeGetSeconds(time)
        return Int(timeValue).durationString()
    }
}
