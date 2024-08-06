//
//  RecommendScreenEnum.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/5/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import Countly

struct LoggingRecommend{
    static let VIEW_HOME_PAGE = "view_home_page"
    static let VIEW_RECOMMENDATION_PAGE = "view_recommendation_page"
    static let VIEW_TRENDING_PAGE = "view_trending_page"
    static let VIEW_CHANNEL_HOME = "view_channel_home"
    static let VIEW_CHANNEL_VIDEOS = "view_channel_videos"
    static let VIEW_CHANNEL_PLAYLIST = "view_channel_playlist"
    static let VIEW_VIDEO_DETAIL = "view_video_detail"
    static let VIEW_SEARCH_RESULT = "view_search_result"
    static let VIEW_HISTORY = "view_history"
    static let VIEW_FOLLOW_PAGE = "view_follow_page"
    static let VIEW_FOLLOW_CHANNEL_LIST = "view_follow_channel_list"
    static let VIEW_WATCH_LATER = "view_watch_later"
    static let VIEW_PLAYLIST_DETAIL = "view_playlist_detail"
    static let VIEW_MY_VIDEOS = "view_my_videos"
    static let SEARCH_ACTION = "search_action"
    static let PACKAGE_REGISTER_ACTION = "goi_cuoc_register_action"
    static let AUTO_PLAY_ACTION = "auto_play_action"
    static let UPLOAD_ACTION = "upload_action"
    static let VIDEO_CLICK_ACTION = "video_click_action"
    static let CHANNEL_CLICK_ACTION = "channel_click_action"
    static let LOGOUT_ACTION = "logout_action"
    static let FOLLOW_CHANNEL_ACTION = "follow_channel_action"
    static let LIKE_VIDEO_ACTION = "like_video_action"
    static let SHARE_VIDEO_ACTION = "share_video_action"
    static let COMMENT_VIDEO_ACTION = "comment_video_action"
    static let ADD_PLAYLIST_ACTION = "add_playlist_action"
    static let VIDEO_TRACKING = "video_tracking"
    static let VIDEO_PLAY_NEXT_ACTION = "video_play_next_action"
    static let VIDEO_PAUSE_ACTION = "video_pause_action"
    static let REMOVE_VIDEO_FROM_PLAYLIST = "remove_video_from_playlist"
    static let DELETE_PLAYLIST_ACTION = "delete_playlist_action"
    static let CLOSE_VIDEO_ACTION = "close_video_action"
    static let DOWNLOADS_VIDEO_ACTION = "downloads_video_action"
    
    static let USER_ID_DB = "user_id_db"
    static let EMAIL = "email"
    static let NAME = "name"
    static let PHONE_NUMBER = "phone_number"
    static let GOI_CUOC_ID = "goi_cuoc_id"
    static let AGE = "age"
    static let GENDER = "gender"
    static let NO_FOLLOWERS = "no_followers"
    static let CURRENT_PAGE = "current_page"
    static let REFERRER_PAGE = "referrer_page"
    static let LOCAL_TIME = "local_time"
    static let TIME_STAMP = "time_stamp"
    static let SHOW_RECOMMENDATION = "show_recommendation"
    static let RESOLUTION = "resolution"
    static let OS = "os"
    static let OS_VERSION = "os_version"
    static let CHANNEL_ID = "channel_id"
    static let CHANNEL_NAME = "channel_name"
    static let CAT_ID = "cat_id"
    static let CAT_NAME = "cat_name"
    static let VIDEO_ID = "video_id"
    static let VIDEO_NAME = "video_name"
    static let UTM_SOURCE = "utm_source"
    static let UTM_MEDIUM = "utm_medium"
    static let FOLLOW_TYPE = "follow_type"
    static let PLAYLIST_ID = "playlist_id"
    static let PLAYLIST_NAME = "playlist_name"
    static let COMMENT_CONTENT = "comment_content"
    static let PACKAGE_ID = "goi_cuoc_id"
    static let PACKAGE_TYPE = "goi_cuoc_type"
    static let PACKAGE_PRICE = "goi_cuoc_price"
    static let NO_VIDEOS = "no_videos"
    static let DEVICE_ID = "device_id"
    static let KEYWORD = "Keyword"
    static let LIKE_TYPE = "like_type"
    
    static func commonParams() -> Dictionary<String, String> {
        if DataManager.isLoggedIn(){
            let dict : Dictionary<String, String> = [
                "user_id_db": (DataManager.getCurrentMemberModel()?.userId)!,
                "email": "",
                "name": (DataManager.getCurrentMemberModel()?.fullName)!,
                "phone_number": (DataManager.getCurrentMemberModel()?.msisdn)!,
                "goi_cuoc_id": "",
                "age": "",
                "gender": "",
                "no_followers": "",
                "current_page":"",
                "referrer_page":"",
                "local_time": getLocalTime(),
                "time_stamp": Date().timeIntervalSince1970.description,
                "show_recommendation": "",
                "os":"iOS",
                "os_version":(UIDevice.current.systemVersion as String),
                "device_id": (UIDevice.current.identifierForVendor?.uuidString)!,
                "resolution": getResolution()
            ]
            return dict
        }else{
            let dict : Dictionary<String, String> = [
                "user_id_db": "",
                "email": "",
                "name": "",
                "phone_number": "",
                "goi_cuoc_id": "",
                "age": "",
                "gender": "",
                "no_followers": "",
                "current_page":"",
                "referrer_page":"",
                "local_time": getLocalTime(),
                "time_stamp": Date().timeIntervalSince1970.description,
                "show_recommendation": "",
                "os":"iOS",
                "os_version":(UIDevice.current.systemVersion as String),
                "device_id": (UIDevice.current.identifierForVendor?.uuidString)!,
                "resolution": getResolution()
            ]
            return dict
        }
    }
    
    static func getResolution() -> String{
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let strResolution = "\(screenWidth)x\(screenHeight)"
        return strResolution
    }
    
    static func getLocalTime() -> String{
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "y-MM-dd H:m:ss"
        return df.string(from: d)
    }
    
    static func viewHomePage(){
        let param = commonParams()
        Countly.sharedInstance().recordEvent(VIEW_HOME_PAGE, segmentation:param)
    }
    
    static func viewRecommendPage(){
        let param = commonParams()
        Countly.sharedInstance().recordEvent(VIEW_RECOMMENDATION_PAGE, segmentation:param)
    }
    
    static func viewTrendingPage(){
        let param = commonParams()
        Countly.sharedInstance().recordEvent(VIEW_TRENDING_PAGE, segmentation:param)
    }
    
    static func viewChannelHome(channelId: String, channelName: String){
        var param = commonParams()
        param[CHANNEL_ID] = channelId
        param[CHANNEL_NAME] = channelName
        Countly.sharedInstance().recordEvent(VIEW_CHANNEL_HOME, segmentation:param)
    }
    
    static func viewVideoDetail(channelId: String, channelName: String, videoId: String, videoName: String){
        var param = commonParams()
        param[CHANNEL_ID] = channelId
        param[CHANNEL_NAME] = channelName
        param[VIDEO_ID] = videoId
        param[VIDEO_NAME] = videoName
        Countly.sharedInstance().recordEvent(VIEW_CHANNEL_HOME, segmentation:param)
    }
    
    static func viewHistory(noVideos: Int){
        var param = commonParams()
        param[NO_VIDEOS] = String(noVideos)
        Countly.sharedInstance().recordEvent(VIEW_HISTORY, segmentation:param)
    }
    
    static func viewFollowPage(){
        let param = commonParams()
        Countly.sharedInstance().recordEvent(VIEW_FOLLOW_PAGE, segmentation:param)
    }
    
    static func viewFollowChannelList(){
        let param = commonParams()
        Countly.sharedInstance().recordEvent(VIEW_FOLLOW_CHANNEL_LIST, segmentation:param)
    }
    
    static func viewWatchLater(noVideos: Int){
        var param = commonParams()
        param[NO_VIDEOS] = String(noVideos)
        Countly.sharedInstance().recordEvent(VIEW_WATCH_LATER, segmentation:param)
    }
    
    static func viewPlaylistDetail(playlistId: String, playlistName: String, noVideos: Int){
        var param = commonParams()
        param[PLAYLIST_ID] = playlistId
        param[PLAYLIST_NAME] = playlistName
        param[NO_VIDEOS] = String(noVideos)
        Countly.sharedInstance().recordEvent(VIEW_PLAYLIST_DETAIL, segmentation:param)
    }
    
    static func viewMyVideos(noVideos: Int){
        var param = commonParams()
        param[NO_VIDEOS] = String(noVideos)
        Countly.sharedInstance().recordEvent(VIEW_MY_VIDEOS, segmentation:param)
    }
    
    static func searchAction(keyword: String){
        var param = commonParams()
        param[KEYWORD] = keyword
        Countly.sharedInstance().recordEvent(SEARCH_ACTION, segmentation:param)
    }
    
    static func packageRegisterAction(packageId: String){
        var param = commonParams()
        param[PACKAGE_ID] = packageId
        Countly.sharedInstance().recordEvent(PACKAGE_REGISTER_ACTION, segmentation:param)
    }
    // chua lam
    static func uploadAction(videoId: String, videoName: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        param[VIDEO_NAME] = videoName
        Countly.sharedInstance().recordEvent(UPLOAD_ACTION, segmentation:param)
    }
    
    static func videoClickAction(videoId: String, videoName: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        param[VIDEO_NAME] = videoName
        Countly.sharedInstance().recordEvent(VIDEO_CLICK_ACTION, segmentation:param)
    }
    
    //not implement
    static func channelClickAction(channelId: String, channelName: String){
        var param = commonParams()
        param[CHANNEL_ID] = channelId
        param[CHANNEL_NAME] = channelName
        Countly.sharedInstance().recordEvent(CHANNEL_CLICK_ACTION, segmentation:param)
    }
    
    static func logoutAction(){
        let param = commonParams()
        Countly.sharedInstance().recordEvent(LOGOUT_ACTION, segmentation:param)
    }
    
    static func followChannelAction(channelId: String, channelName: String, followType: Bool){
        var param = commonParams()
        param[CHANNEL_ID] = channelId
        param[CHANNEL_NAME] = channelName
        param[FOLLOW_TYPE] = "\(followType)"
        Countly.sharedInstance().recordEvent(FOLLOW_CHANNEL_ACTION, segmentation:param)
    }
    
    static func likeVideoAction(videoId: String, videoName: String, type:Bool){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        param[VIDEO_NAME] = videoName
        param[LIKE_TYPE] = "\(type)"
        Countly.sharedInstance().recordEvent(LIKE_VIDEO_ACTION, segmentation:param)
    }
    
    static func shareVideoAction(videoId: String, videoName: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        param[VIDEO_NAME] = videoName
        Countly.sharedInstance().recordEvent(SHARE_VIDEO_ACTION, segmentation:param)
    }
    
    static func commentVideoAction(videoId: String, comment: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        param[COMMENT_CONTENT] = comment
        Countly.sharedInstance().recordEvent(COMMENT_VIDEO_ACTION, segmentation:param)
    }
    
    static func addPlaylistAction(channelId: String, channelName: String, videoId: String, playlistId: String){
        var param = commonParams()
        param[CHANNEL_ID] = channelId
        param[CHANNEL_NAME] = channelName
        param[VIDEO_ID] = videoId
        param[PLAYLIST_ID] = playlistId
        Countly.sharedInstance().recordEvent(ADD_PLAYLIST_ACTION, segmentation:param)
    }
    
    static func videoPlayNextAction(videoId: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        Countly.sharedInstance().recordEvent(VIDEO_PLAY_NEXT_ACTION, segmentation:param)
    }
    
    static func videoPauseAction(videoId: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        Countly.sharedInstance().recordEvent(VIDEO_PAUSE_ACTION, segmentation:param)
    }
    
    static func removeVideoFromPlaylist(channelId: String, channelName: String, videoId: String, playlistId: String){
        var param = commonParams()
        param[CHANNEL_ID] = channelId
        param[CHANNEL_NAME] = channelName
        param[VIDEO_ID] = videoId
        param[PLAYLIST_ID] = playlistId
        Countly.sharedInstance().recordEvent(REMOVE_VIDEO_FROM_PLAYLIST, segmentation:param)
    }
    
    static func deletePlaylistAction(playlistId: String, playlistName: String){
        var param = commonParams()
        param[PLAYLIST_ID] = playlistId
        param[PLAYLIST_NAME] = playlistName
        Countly.sharedInstance().recordEvent(DELETE_PLAYLIST_ACTION, segmentation:param)
    }
    
    static func downloadVideoAction(videoId: String, videoName: String){
        var param = commonParams()
        param[VIDEO_ID] = videoId
        param[VIDEO_NAME] = videoName
        Countly.sharedInstance().recordEvent(DOWNLOADS_VIDEO_ACTION, segmentation:param)
    }
}
