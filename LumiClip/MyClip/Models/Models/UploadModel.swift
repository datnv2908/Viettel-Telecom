
//
//  UploadModel.swift
//  MyClip
//
//  Created by hnc on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Alamofire

enum UploadStatus {
    case new, uploading, paused, cancelled, error
}

class UploadModel: NSObject {
    var id: String
    var videoUrl: URL
    var title: String
    var desc: String
    var thumbImage: UIImage
    var videoMode: Int
    var percent: Float
    var status: UploadStatus {
        didSet {
            switch status {
            case .new, .cancelled, .error:
                percent = 0.0
            default:
                break
            }
        }
    }
    var uploadRequest: UploadRequest?
     var channelID : String
     var categoryID : String
   
   init(videoUrl: URL, title: String, desc: String, thumbImage: UIImage, videoMode: Int,channelID :String, categoryID : String) {
        id = UUID().uuidString
        self.videoUrl = videoUrl
        self.title = title
        self.desc = desc
        self.thumbImage = thumbImage
        self.videoMode = videoMode
        self.status = .new
        percent = 0.0
        self.channelID = channelID
         self.categoryID = categoryID
    }

    func resume() {
        status = .uploading
        uploadRequest?.resume()        
    }

    func stop() {
        status = .cancelled
        uploadRequest?.cancel()
    }
}
