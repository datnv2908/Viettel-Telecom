//
//  GoogleChromcastHelper.swift
//  GoogleChromcast
//
//  Created by Hoang on 3/29/17.
//  Copyright © 2017 Hoang. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleCast

let kPrefPreloadTime = "preload_time_sec"
let kPrefEnableAnalyticsLogging = "enable_analytics_logging"
let kPrefEnableSDKLogging = "enable_sdk_logging"
let kPrefAppVersion = "app_version"
let kPrefSDKVersion = "sdk_version"
let kPrefReceiverAppID = "receiver_app_id"
let kPrefCustomReceiverSelectedValue = "use_custom_receiver_app_id"
let kPrefCustomReceiverAppID = "custom_receiver_app_id"
let kPrefEnableMediaNotifications = "enable_media_notifications"

let kApplicationID: String? = nil
let appDelegate = (UIApplication.shared.delegate as? AppDelegate)

@objcMembers
class GoogleChromcastHelper: NSObject {

    fileprivate var enableSDKLogging = false
    fileprivate var mediaNotificationsEnabled = false
    fileprivate var firstUserDefaultsSync = false
    fileprivate var useCastContainerViewController = false
    var isCastControlBarsEnabled: Bool {
        get {
            let window = appDelegate?.window
            if useCastContainerViewController {

                let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                return castContainerVC!.miniMediaControlsItemEnabled
            } else {

                return false
//                let rootContainerVC = (window?.rootViewController as? RootContainerViewController)
//                return rootContainerVC!.miniMediaControlsViewEnabled
            }
        }

        set(notificationsEnabled) {

            let window = appDelegate?.window
            if useCastContainerViewController {
                var castContainerVC: GCKUICastContainerViewController?
                castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
                castContainerVC?.miniMediaControlsItemEnabled = notificationsEnabled
            } else {
//                var rootContainerVC: RootContainerViewController?
//                rootContainerVC = (window?.rootViewController as? RootContainerViewController)
//                rootContainerVC?.miniMediaControlsViewEnabled = notificationsEnabled
            }
        }
    }

    static var shareInstance: GoogleChromcastHelper = {
        let instance = GoogleChromcastHelper()
        return instance
    }()
    
    open var castSession: GCKSession?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        var window = appDelegate?.window
        populateRegistrationDomain()
        // Don't try to go on without a valid application ID - SDK will fail an
        // assert and app will crash.
        guard let applicationID = applicationIDFromUserDefaults(), applicationID != "" else {
            return true
        }

        // We are forcing a custom container view controller, but the Cast Container
        // is also available
        useCastContainerViewController = false
        let options = GCKCastOptions(receiverApplicationID: applicationID)
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = true
        GCKCastContext.sharedInstance().defaultExpandedMediaControlsViewController.setButtonType(.none, at: 0)
        GCKCastContext.sharedInstance().defaultExpandedMediaControlsViewController.setButtonType(.none, at: 3)
        window?.clipsToBounds = true
        setupCastLogging()

        // Set playback category mode to allow playing audio on the video files even
        // when the ringer mute switch is on.
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch _ {
        }

        if useCastContainerViewController {
            let appStoryboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationController = appStoryboard.instantiateViewController(withIdentifier: "MainNavigation")
                as? UINavigationController else { return false }
            let castContainerVC = GCKCastContext.sharedInstance().createCastContainerController(
                for: navigationController)
                as GCKUICastContainerViewController
            castContainerVC.miniMediaControlsItemEnabled = true
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = castContainerVC
            window?.makeKeyAndVisible()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(syncWithUserDefaults),
                                               name: UserDefaults.didChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentExpandedMediaControls),
                                               name: NSNotification.Name.gckExpandedMediaControlsTriggered, object: nil)
        firstUserDefaultsSync = true
        syncWithUserDefaults()
       UIApplication.shared.statusBarStyle = .lightContent
        GCKCastContext.sharedInstance().sessionManager.add(self)
        GCKCastContext.sharedInstance().imagePicker = self
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.gckExpandedMediaControlsTriggered,
                                                  object: nil)
    }

    func setupCastLogging() {
        let logFilter = GCKLoggerFilter()
        let classesToLog = ["GCKDeviceScanner", "GCKDeviceProvider", "GCKDiscoveryManager", "GCKCastChannel",
                            "GCKMediaControlChannel", "GCKUICastButton", "GCKUIMediaController", "NSMutableDictionary"]
        logFilter.setLoggingLevel(.verbose, forClasses: classesToLog)
        GCKLogger.sharedInstance().filter = logFilter
        GCKLogger.sharedInstance().delegate = self
    }

    @objc func presentExpandedMediaControls() {

        let window = appDelegate?.window
        // Segue directly to the ExpandedViewController.
        var navigationController: UINavigationController?
        if useCastContainerViewController {
            let castContainerVC = (window?.rootViewController as? GCKUICastContainerViewController)
            navigationController = (castContainerVC?.contentViewController as? UINavigationController)
        }

        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }

    // MARK: 
    // MARK: PLAY Video from position (seconds)
    func playVideoWithChromeCast(_ model: VideoDetailModel, position: Double = 0) {
        let mediaInfor = generatorMediaInfor(model)
        loadMedia(mediaInfor, appending: false, startTime: position)
        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
    }

    private func generatorMediaInfor(_ model: VideoDetailModel) -> GCKMediaInformation {
        let metadata = GCKMediaMetadata(metadataType: .movie)
        metadata.setString(model.detail.name, forKey: kGCKMetadataKeyTitle)
        metadata.setString(model.detail.desc, forKey: kGCKMetadataKeySubtitle)
        let kMediaKeyPosterURL = "posterUrl"
        let posterImage = model.detail.coverImage
        let posterURL = URL(string: posterImage)
        metadata.setString(posterImage, forKey: kMediaKeyPosterURL)
        metadata.addImage(GCKImage(url: posterURL!,
                                   width: Int(Constants.screenWidth), height: Int(Constants.screenHeight)))
        metadata.setString(model.detail.id, forKey: Constants.kVideoId)

        let mediaTracks: [GCKMediaTrack]? = [GCKMediaTrack]()
        let urlStr = model.streams.urlStreaming
        let mimeType = "videos/mp4"
        let trackStyle: GCKMediaTextTrackStyle = GCKMediaTextTrackStyle.createDefault()

        let mediaInfor = GCKMediaInformation(contentID: urlStr,
                                             streamType: .buffered,
                                             contentType: mimeType,
                                             metadata: metadata,
                                             streamDuration: TimeInterval(0),
                                             mediaTracks: mediaTracks,
                                             textTrackStyle: trackStyle,
                                             customData: nil)

        return mediaInfor
    }

    private func loadMedia(_ mediaInfor: GCKMediaInformation, appending: Bool, startTime: TimeInterval) {
        if let remoteMediaClient =
            GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient {
            let builder = GCKMediaQueueItemBuilder()
            builder.mediaInformation = mediaInfor
            builder.autoplay = true
            builder.startTime = startTime
            let item = builder.build()
            if ((remoteMediaClient.mediaStatus) != nil) && appending {
                let request = remoteMediaClient.queueInsert(item, beforeItemWithID: kGCKMediaQueueInvalidItemID)
                request.delegate = self
            } else {
                let repeatMode = remoteMediaClient.mediaStatus?.queueRepeatMode ?? .off
                let request = remoteMediaClient.queueLoad([item], start: 0,
                                                          playPosition: startTime,
                                                          repeatMode: repeatMode,
                                                          customData: nil)
                request.delegate = self
            }
        }
    }
    
    func currentCastingVideo() -> String? {
        if GCKCastContext.sharedInstance().castState == .connected {
            if let remoteMediaClient = GCKCastContext.sharedInstance().sessionManager.currentCastSession?.remoteMediaClient,
                let videoId = remoteMediaClient.mediaStatus?.currentQueueItem?.mediaInformation.metadata?.object(forKey: Constants.kVideoId) as? String {
                return videoId
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

extension GoogleChromcastHelper: GCKRequestDelegate {

    func requestDidComplete(_ request: GCKRequest) {
        DLog("request \(Int(request.requestID)) completed")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidComplete, object: nil)
    }

    func request(_ request: GCKRequest, didFailWithError error: GCKError) {
        DLog("request \(Int(request.requestID)) failed with error \(error)")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidFail, object: nil)
    }
}

extension GoogleChromcastHelper: GCKLoggerDelegate {
    func logMessage(_ message: String, fromFunction function: String) {
        if enableSDKLogging {
            // Send SDK's log messages directly to the console.
            DLog("\(function)  \(message)")
        }
    }
}

extension GoogleChromcastHelper: GCKSessionManagerListener {

    func sessionManager(_ sessionManager: GCKSessionManager, didStart session: GCKSession) {
        DLog("MediaViewController: sessionManager didStartSession \(session.connectionState)")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidStart, object: nil)
        castSession = session
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didResumeSession session: GCKSession) {
        DLog("MediaViewController: sessionManager didResumeSession \(session.connectionState)")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidResume, object: nil)
        castSession = session
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didEnd session: GCKSession, withError error: Error?) {
        DLog("The Casting session has ended.\n\(String(describing: error?.localizedDescription))")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidEnd, object: nil)
        castSession = nil
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didFailToStartSessionWithError error: Error?) {
        DLog("Failed to start a session.")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidFailToStart, object: nil)
        castSession = nil
    }

    func sessionManager(_ sessionManager: GCKSessionManager, didFailToResumeSession session: GCKSession,
                        withError error: Error?) {
        DLog("The Casting session could not be resumed.")
        NotificationCenter.default.post(name: .kNotificationChromecastRequestDidFailToResume, object: nil)
        castSession = nil
    }
}

// MARK: - GCKUIImagePicker
extension GoogleChromcastHelper: GCKUIImagePicker {
    func getImageWith(_ imageHints: GCKUIImageHints, from metadata: GCKMediaMetadata) -> GCKImage? {
        let images = metadata.images
        guard !images().isEmpty else { return nil }
        if images().count > 1 && imageHints.imageType == .background {
            return images()[1] as? GCKImage
        } else {
            return images()[0] as? GCKImage
        }
    }
}

// MARK: - Working with default values
extension GoogleChromcastHelper {

    func showAlert(withTitle title: String, message: String) {
        // todo: Pull this out into a class that either shows an AlertVeiw or a AlertController
        let alert = UIAlertView(title: title, message: message, delegate: nil,
                                cancelButtonTitle: "OK", otherButtonTitles: "")
        alert.show()
    }

    func populateRegistrationDomain() {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        var appDefaults = [String: Any]()
        if let settingsBundleURL = Bundle.main.url(forResource: "Settings", withExtension: "bundle") {
            loadDefaults(&appDefaults, fromSettingsPage: "Root", inSettingsBundleAt: settingsBundleURL)
        }
        let userDefaults = UserDefaults.standard
        userDefaults.register(defaults: appDefaults)
        userDefaults.setValue(appVersion, forKey: kPrefAppVersion)
        userDefaults.setValue(kGCKFrameworkVersion, forKey: kPrefSDKVersion)
        userDefaults.synchronize()
    }

    func loadDefaults(_ appDefaults: inout [String: Any], fromSettingsPage plistName: String,
                      inSettingsBundleAt settingsBundleURL: URL) {
        let plistFileName = plistName.appending(".plist")
        let settingsDict = NSDictionary(contentsOf: settingsBundleURL.appendingPathComponent(plistFileName))
        if let prefSpecifierArray = settingsDict?["PreferenceSpecifiers"] as? [[AnyHashable:Any]] {
            for prefItem in prefSpecifierArray {
                let prefItemType = prefItem["Type"] as? String
                let prefItemKey = prefItem["Key"] as? String
                let prefItemDefaultValue = prefItem["DefaultValue"] as? String
                if prefItemType == "PSChildPaneSpecifier" {
                    if let prefItemFile = prefItem["File"]  as? String {
                        loadDefaults(&appDefaults, fromSettingsPage: prefItemFile,
                                     inSettingsBundleAt: settingsBundleURL)
                    }
                } else if let prefItemKey = prefItemKey, let prefItemDefaultValue = prefItemDefaultValue {
                    appDefaults[prefItemKey] = prefItemDefaultValue
                }
            }
        }
    }

    func applicationIDFromUserDefaults() -> String? {
        let userDefaults = UserDefaults.standard
        var prefApplicationID = userDefaults.string(forKey: kPrefReceiverAppID)
        if prefApplicationID == kPrefCustomReceiverSelectedValue {
            prefApplicationID = userDefaults.string(forKey: kPrefCustomReceiverAppID)
        }
        if let prefApplicationID = prefApplicationID {
            let appIdRegex = try? NSRegularExpression(pattern: "\\b[0-9A-F]{8}\\b", options: [])
            let rangeToCheck = NSRange(location: 0, length: (prefApplicationID.count))
            let numberOfMatches = appIdRegex?.numberOfMatches(in: prefApplicationID,
                                                              options: [],
                                                              range: rangeToCheck)
            if numberOfMatches == 0 {
                let message: String = "\"\(prefApplicationID)\" is not a valid application ID\n" +
                "Please fix the app settings (should be 8 hex digits, in CAPS)"
                showAlert(withTitle: "Invalid Receiver Application ID", message: message)
                return nil
            }
        } else {
            let message: String = "You don't seem to have an application ID.\n" +
            "Please fix the app settings."
            showAlert(withTitle: "Invalid Receiver Application ID", message: message)
            return nil
        }
        return prefApplicationID
    }

    @objc func syncWithUserDefaults() {

    }
}
