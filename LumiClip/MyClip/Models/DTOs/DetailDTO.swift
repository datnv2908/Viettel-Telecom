//
//  DetailDTO.swift
//  MyClip
//
//  Created by Os on 9/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailDTO: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var watchTime: Double
    var type: String
    var likeCount: String
    var dislikeCount: String
    var playTimes: String
    var suggestPackageId: String
    var isFavourite: Int
    var link: String
    var linkSocial : String
    var duration: String
    var publishedTime: String
    var previewImage: String
    var showTimes: TimeInterval
    var owner: ChannelDTO
    var canComment : Bool
   var freeVideo : Bool
    
    init(_ json: JSON) {
        id               = json["id"].stringValue
        name             = json["name"].stringValue
        desc             = json["description"].stringValue
        coverImage       = json["coverImage"].stringValue
        watchTime        = json["watchTime"].doubleValue
        type             = json["type"].stringValue
        likeCount        = json["likeCount"].stringValue
        dislikeCount     = json["dislikeCount"].stringValue
        playTimes        = json["play_times"].stringValue
        suggestPackageId = json["suggest_package_id"].stringValue
        isFavourite      = json["isFavourite"].intValue
        link             = json["link"].stringValue
        duration         = json["duration"].stringValue
        publishedTime    = json["publishedTime"].stringValue
        previewImage     = json["previewImage"].stringValue
        showTimes        = json["show_times"].doubleValue
        owner            = ChannelDTO(json["owner"])
      linkSocial        = json["linkSocial"].stringValue
      if json["can_comment"].stringValue ==  "1" {
         canComment = true
      }else{
         canComment = false
      }
        if json["price_play"].stringValue == "0" {
               self.freeVideo = true
            }else{
               self.freeVideo = false
            }
    }
}
