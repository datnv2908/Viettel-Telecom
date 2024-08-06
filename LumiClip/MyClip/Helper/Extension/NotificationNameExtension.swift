//
//  NotificationNameExtension.swift
//  MyClip
//
//  Created by Huy Nguyen on 7/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
extension Notification.Name {
    static let kPassVideoToRoot = Notification.Name("kPassVideoToRoot")
    static let kShouldClosePlayer = Notification.Name("kSHouldClosePlayer")
    static let kShouldPausePlayer = Notification.Name("kShouldPausePlayer")
    static let kShouldGetNotification = Notification.Name("kShouldGetNotification")
    static let kNotificationShouldReloadFollow = Notification.Name("shouldReloadFollow")
    static let kNotificationShowGotoDownload = Notification.Name("kNotificationShowGotoDownload")
    static let kNotificationHideGotoDownload = Notification.Name("kNotificationHideGotoDownload")
    static let kNotificationUploadStarted = Notification.Name("kNotificationUploadStarted")
    static let uploadSuccess = Notification.Name("NotificationUploadSuccess")
    static let kLoseInternet = Notification.Name("kLoseInternet")
    static let kConnectInternet = Notification.Name("kConnectInternet")
    static let kOutOfMemory = Notification.Name("kOutOfMemory")

    static let kNotificationDownloadStarted = Notification.Name("kNotificationDownloadStarted")
    static let kNotificationDownloadCompleted = Notification.Name("kNotificationDownloadCompleted")
    static let kNotificationRemovedDownloadItem = Notification.Name("kNotificationRemovedDownloadItem")
    
    static let kNotificationChromecastRequestDidComplete = Notification.Name("kNotificationChromecastRequestDidComplete")
    static let kNotificationChromecastRequestDidFail = Notification.Name("kNotificationChromecastRequestDidFail")
    static let kNotificationChromecastRequestDidStart = Notification.Name("kNotificationChromecastRequestDidStart")
    static let kNotificationChromecastRequestDidResume = Notification.Name("kNotificationChromecastRequestDidResume")
    static let kNotificationChromecastRequestDidEnd = Notification.Name("kNotificationChromecastRequestDidEnd")
    static let kNotificationChromecastRequestDidFailToStart = Notification.Name("kNotificationChromecastRequestDidFailToStart")
    static let kNotificationChromecastRequestDidFailToResume = Notification.Name("kNotificationChromecastRequestDidFailToResume")
}
