//
//  VideoDTO.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContentDTO: NSObject {
    var coverImage: String
    var desc: String
    var duration: String
    var durationPercent: Double
    var id: String
    var name: String
    var fullName: String
    var play_times: String
    var publishedTime: String
    var type: String
    var userAvatarImage: String
    var userId: String
    var userName: String
    var fullUserName: String
    var link: String
    var reason: String
    var status: String
    var feedback_reject_reason: String
    var feedback_status: String
    var animatedImage: String
   var price_play: String
    
    /////for search v2/////
    var published_time : String
    var channel_id : String
    var channel_name : String
    var num_video : String
    var num_follow : String
   var linkSocial : String
   var freeVideo : Bool
   var canComment : Bool
    init(_ json: JSON) {
        coverImage      = json["coverImage"].stringValue
        desc            = json["description"].stringValue
        duration        = json["duration"].stringValue
        durationPercent = json["durationPercent"].doubleValue
        id              = json["id"].stringValue
        name            = json["name"].stringValue
        fullName        = json["fullName"].stringValue
        play_times      = json["play_times"].stringValue
        publishedTime   = json["publishedTime"].stringValue
        type            = json["type"].stringValue
        userAvatarImage = json["userAvatarImage"].stringValue
        userId          = json["userId"].stringValue
        userName        = json["userName"].stringValue
        fullUserName    = json["fullUserName"].stringValue
        link            = json["link"].stringValue
        status          = json["status"].stringValue
        reason          = json["reason"].stringValue
        feedback_reject_reason = json["feedback_reject_reason"].stringValue
        feedback_status = json["feedback_status"].stringValue
        animatedImage   = json["animationImage"].stringValue
        linkSocial      = json["linkSocial"].stringValue
      price_play       = json["price_play"].stringValue
        /////for search v2/////
        published_time = json["published_time"].stringValue
        channel_id = json["channel_id"].stringValue
        channel_name = json["channel_name"].stringValue
        num_video = json["num_video"].stringValue
      num_follow = json["num_follow"].stringValue
      if json["can_comment"].stringValue  == "1"{
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
