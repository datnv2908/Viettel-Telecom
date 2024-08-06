//
//  Constant.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

class CompletionBlockResult: NSObject {
    var isCancelled: Bool
    var isSuccess: Bool
    var userInfo: [String:Any]?
    init(isCancelled: Bool, isSuccess: Bool, with object: [String: Any]? = nil, error: Error? = nil) {
        self.isCancelled = isCancelled
        self.isSuccess = isSuccess
        self.userInfo = object
    }
}

typealias CompletionBlock = ((CompletionBlockResult) -> Void)

func getShortLanguage() -> String {
    return RTLocalizationSystem.rtGetLanguage()
}

struct Constants {
    static let kDefaultLimit          = 15
    static let kDefaultMargin         = 15
    static let passwordMinLength      = 8
    static let kFirstOffset           = 0
    static let kDefaultRetryTimes     = 3
    static let kShowNotifyViewInterval: TimeInterval          = 5
    static let kToastDuration: Float  = 2.0
    static let bannerHeight           = floor(Constants.screenWidth * 160.0 / 375.0)
    static let videoPlayerHeight      = floor(Constants.screenWidth * 9.0 / 16.0)
    static let contentMargin: CGFloat = 15.0
    static let tabbarHeight: CGFloat = 50
    static let notifyBarHeight: CGFloat = 65

    static let appDelegate         = UIApplication.shared.delegate as! AppDelegate
    static let screenWidth         = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    static let screenHeight        = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
    static let isIphone            = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    static let isIphoneX           = max(UIScreen.main.nativeBounds.size.width, UIScreen.main.nativeBounds.size.height) == 2436
    static let iPhoneXBottomMargin: CGFloat = 34
    static let isIpad              = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    static let iPhone              = "iPhone"
    static let iPad                = "iPad"
    static let loggedIn            = "logged_in"
    static let loggedOut           = "logged_out"
    static let supportPhone        = "100"
    static let didShowTutorialPage = "Constants.didShowTutorialPage"
    static let kDeviceToken        = "device_token"
    static let kLoginStatus        = "login_status"
    static let kLoginFacebook      = "login_facebook"
    static let kUserModel          = "USER_MODEL"
    static let kSettingDefault     = "Constants.kSettingDefault"
    static let kDefaultQuality     = "Constants.kDefaultQuality"
    static let kDefaultOnlyPlayHD  = "Constants.kDefaultOnlyPlayHD"
    static let kFilmQuality        = "Constants.kFilmQuality"
    static let kDownloadQuality    = "Constants.kDownloadQuality"
    static let kDownloadWifi       = "Constants.kDownloadWifi"
    static let kListPackage        = "Constants.kListPackage"
    static let kPinCode            = "Constants.kPinCode"
    static let kShouldNotAutoPlay  = "kShouldNotAutoPlay"
    static let kSufferVideoInPlaylist = "kSufferVideoInPlaylist"
    static let kRepeatVideoInPlaylist = "kRepeatVideoInPlaylist"
    static let kForgetNewAppVersionNotice = "ForgetNewAppVersionNotice"
    static let kRatingUrl          = "itms-apps://itunes.apple.com/app/id1186215150"
    static let dateFormatter       = "yyyy-MM-dd HH:mm:ss"
    static let kShowKeywordSearch  = "kShowKeywordSearch"
    static let kShowTutorial       = "kShowTutorial_v2"
    static let kVideoId            = "video_id"
    static let kDelaytime          = 5.0
    static let kDefaultSeek        = 15.0
    static let mainColorHex        = "#fbe116"
   static let statusBarStyle        = "statusBarStyle"
   static let isLightStatusBar        = "isLightStatusBar"
    static func months() -> [String] {
        var array = [String]()
        for i in 1...12 {
            if i < 10 {
                array.append(String.init(format: "0%d", i))
            }
        }
        return array
    }

    static func days() -> [String] {
        var array = [String]()
        for i in 1...31 {
            if i < 10 {
                array.append(String.init(format: "0%d", i))
            } else {
                array.append(String.init(format: "%d", i))
            }
        }
        return array
    }
    
    static var hasSafeArea: Bool {
        guard #available(iOS 11.0, *), let topPadding = UIApplication.shared.keyWindow?.safeAreaInsets.top, topPadding > 24 else {
            return false
        }
        return true
    }
}
