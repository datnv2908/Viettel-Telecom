//
//  Constant.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

let kDefaultLimit      = 30
let kDefaultOffset     = 0
let kDefaultRetryTimes = 3

func getShortLanguage() -> String {
    return RTLocalizationSystem.rtGetLanguage()
//    let lang_str = "es"
//    let lang_arr = DataManager.objectForKey("AppleLanguages") as! NSArray
//    if (lang_arr.count > 0) {
//        let lang = ["es", "vi", "en"].filter({$0 == (lang_arr[0] as! String)})
//        if (lang.count > 0) {
//            return lang[0]
//        }
//    }
//
//    return lang_str
}

struct Constants {
    
    static let kGoogelSpeechAPILienseKey = "AIzaSyBX6H316myCME3M3SAxIEZo8403_KAdIsI"
    
    static let kDefaultLimit = 30
    static let kDefaultOffset = 0
    static let kDefaultRetryTimes = 3
    static let kToastDuration: Float = 2.0
    static let relateSize: CGSize = CGSize(width: 130, height: 235)
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let isIphone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let isIpad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let iPhone = "iPhone"
    static let iPad = "iPad"
    static let loggedIn = "logged_in"
    static let loggedOut = "logged_out"

    static let didShowTutorialPage = "Constants.didShowTutorialPageNew"
    static let kDeviceToken = "device_token"
    static let kDidRegisterDeviceToken = "kDidRegisterDeviceToken"
    static let kDidRegisterDeviceTokenDefault = "kDidRegisterDeviceTokenDefault"
    static let kNotificationLoginSuccess = "kNotificationLoginSuccess"
    static let kNotificationResignActive = "kNotificationResignActive"
    static let kLoginStatus = "login_status"
    static let kLoginFacebook = "login_facebook"
    static let kUserModel = "USER_MODEL"
    static let kMPSDetectLink = "mpsDetectLink"
    static let kSettingDefault = "Constants.kSettingDefault"
    static let kFilmQuality = "Constants.kFilmQuality"
    static let kDownloadQuality = "Constants.kDownloadQuality"
    static let kDownloadWifi = "Constants.kDownloadWifi"
    static let kListPackage = "Constants.kListPackage"
    static let kPinCode = "Constants.kPinCode"
    static let kSupportPhoneNumber = "198"

    static let fire_base_home_page_event = "home_page_screen"
    static let fire_base_detail_event = "detail_screen"
    static let fire_base_package_event = "package_screen"
    static let fire_base_play_movie_event = "play_screen"

    static let fire_base_home_page = "Home Page"
    static let fire_base_detail = "Film Detail"
    static let fire_base_package = "Package"
    static let fire_base_play_movie = "Player"
    static let PlayList = "PLAYLIST"
    static let Video = "VOD"
    
    static let nMPSDetectLinkSuccess = "MPSDetectLinkSuccess"
    static let nMPSDetectLinkFaild = "MPSDetectLinkFaild"
    
    static let kCacheHome = "Constants.kCacheHome"
    static let time_Expire =  "Constants.time_Expire"
    static let pushSeason = "push_Season_Data"
    static let pushSeasonFirstTime = "pushSeasonFirstTime"
    static let launchFromNotification = "launchFromNotification"
}
