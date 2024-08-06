//
//  Enum.swift
//  MyClip
//
//  Created by Huy Nguyen on 6/9/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum GrantType {
   case autoLogin
   case login
   case loginSocial
   case refreshToken
   
   func stringValue() -> String {
      switch self {
      case .autoLogin:
         return "auto_login"
      case .login:
         return "login"
      case .loginSocial:
         return "login-social"
      case .refreshToken:
         return "refresh_token"
      }
   }
}

enum APIErrorCode: Int {
   case success            = 200
   case fail               = 201
   case requireLogin       = 401
   case refreshTokenFail   = 402
   case refreshToken       = 403
   case needMapAccount     = 440
   case needCaptcha        = 800
   case invalidCaptcha     = 808
   case unknow             = 99999
}

enum LoginType {
   case normal
   case auto
   case facebook
   case google
   case refreshToken
   
   func grantType() -> String {
      switch self {
      case .normal:
         return "login"
      case .auto:
         return "auto_login"
      case .facebook, .google:
         return "login-social"
      case .refreshToken:
         return "refresh_token"
      }
   }
   
   func socialId() -> String {
      switch self {
      case .facebook:
         return "facebook"
      case .google:
         return "google"
      default:
         return ""
      }
   }
}
enum CommentStatus{
   case approvedComment
   case waitApprove
   case rejectComment
   case all
   func getTitle() ->String{
      switch self {
      case .approvedComment:
         return String.approved_comment
      case .waitApprove :
         return String.wait_approve
      case .rejectComment :
         return String.reject_comment
      case .all :
         return String.all_comment
      }
   }
   func getId() -> String {
      switch self {
      case .approvedComment:
         return ("\(1)")
      case .waitApprove :
         return ("\(0)")
      case .rejectComment :
         return ("\(2)")
      case .all :
         return "\(4)"
      }
   }
}
enum ActionAddRemove {
   case add
   case remove
   
   func value() -> String {
      switch self {
      case .add:
         return "add"
      case .remove:
         return "remove"
      }
   }
}

enum ContentType: String {
   case video = "VOD"
   case playlist = "PLAYLIST"
   case channel = "CHANNEL"
}

enum NotificationType: String {
   case video = "VOD"
   case channel = "CHANNEL"
   case link = "LINK"
   case playlist = "USER_PLAYLIST"
}

enum GroupType: String {
   case relate = "video_relate"
   case channel = "CHANNEL"
   case video = "VOD"
   case search = "SEARCH"
   case none = ""
}

enum SearchType {
   case history
   case searchSuggest
   case search
   case keyword
}

enum LikeStatus: Int {
   case none = 0
   case like = 1
   case dislike = -1
}

enum MoreContentType: String {
   case home     = "video_home"
   case recommend = "video_hot_2"
   case tet2018   = "tet_holiday"
   case history  = "video_history"
   case later    = "video_watch_later"
   case playlist = "video_playlist_"
   case owner    = "video_owner"
   case follow   = "video_channel_follow"
   case channel  = "video_new_of_channel_"
   case channelplaylist = "playlist_public_"
}

enum ChannelNotificationType: Int {
   case none = 0
   case sometimes = 1
   case always = 2
}

enum VideoMode {
   case kPublic
   case kPrivate
   
   func stringValue() -> String {
      switch self {
      case .kPublic:
         return String.cong_khai
      case .kPrivate:
         return String.khong_cong_khai
      default:
         return ""
      }
   }
   
   func intValue() -> Int {
      switch self {
      case .kPublic:
         return 1
      case .kPrivate:
         return 0
      }
   }
}

enum PlaybackRate: Double {
   case lowSpeed = 0.5
   case standardSpeed = 1
   case mediumSpeed = 1.5
   case highSpeed = 2
   func title() -> String {
      switch self {
      case .lowSpeed:
         return "0.5x"
      case .standardSpeed:
         return String.chuan
      case .mediumSpeed:
         return "1.5x"
      case .highSpeed:
         return "2x"
      }
   }
}

enum PlayerState: String {
   case new = "new"
   case preparing = "preparing"
   case ready = "ready"
   case playing = "playing"
   case pause = "paused"
   case finish = "finished"
   case invalid = "invalid"
}

enum VideoState: String {
   case none = ""
   case pending = "1"
   case approved = "2"
   case refuse = "3"
   
   func value() -> String {
      switch self {
      case .pending:
         return String.cho_phe_duyet_chua_xem_duoc
      case .approved:
         return String.da_phe_duyet
      case .refuse:
         return String.tu_choi_duyet
      case .none:
         return ""
      }
   }
}

enum HtmlContentType: String {
   case aboutUs
   case contact
   case termOfUse
   
   func content() -> String {
      switch self {
      case .aboutUs:
         if let model = DataManager.getCurrentAccountSettingsModel() {
            if model.htmlContents.count > 2 {
               return model.htmlContents[1].content
            }
         }
         return ""
      case .contact:
         if let model = DataManager.getCurrentAccountSettingsModel() {
            if model.htmlContents.count > 2 {
               return model.htmlContents[2].content
            }
         }
         return ""
      case .termOfUse:
         if let model = DataManager.getCurrentAccountSettingsModel() {
            if model.htmlContents.count > 2 {
               return model.htmlContents[0].content
            }
         }
         return ""
      }
   }
}

enum ProgressHudStyle {
   case custom, normal
}

enum GoogleAnalyticKeys: String {
   case home = "iOS_home"
   case recommend = "iOS_recommend"
   case trending = "iOS_trending"
   case search = "iOS_search"
   case videoDetails = "iOS_chitietvideo"
   case channelDetails = "iOS_chitietkenh"
   case profile = "iOS_canhan"
   case package = "iOS_package"
   case follow = "iOS_theodoi"
   case notifications = "iOS_thongbao"
   case upload = "iOS_upload"
}
enum MoreContentForUser :String {
   case  newestVideo = "video_new_of_user_"
   case  oldVideo = "video_old_of_user_"
   case  mostOfView = "video_most_view_of_user_"
}
enum MoreContentForChannel :String {
   case  newestVideo = "video_new_of_channel_"
   case  oldVideo = "video_old_of_channel_"
   case  mostOfView = "video_most_view_of_channel_"
}
enum getAllChannels : String {
   // get Channel have video > 0
   case isChannelActive = "1"
   //get all Channel
   case allChannel = "0"
}
enum typeEditChannel  : String {
   case  channel = "channel"
   case user = "user"
   
}

enum MyChannelEnum : String {
   case myChannel = "myChannel"
   case videos = "videos"
   case playList = "PlayList"
   case about = "about"
}
