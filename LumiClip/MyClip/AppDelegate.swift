//
//  AppDelegate.swift
//  MyClip
//
//  Created by Huy Nguyen on 8/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
//import HockeySDK
import SVProgressHUD
import UserNotifications
import ReachabilitySwift
import Alamofire
import RealmSwift
import Countly
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate ,UNUserNotificationCenterDelegate{
    let service = UserService()
    let appService = AppService()
    var window: UIWindow?
    var rootTabbarController = NewRootTabbarViewController()
    private var launchFromNotification = false
    private var notifyModel: RemoteNotificationModel?
    let reachabilityManager = NetworkReachabilityManager()
    let center = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config: CountlyConfig = CountlyConfig()
        config.appKey = "c3490867509a155f599247196090a42a2a524e38"
        config.host = "http://logging.uclip.la"
        Countly.sharedInstance().start(with: config)
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
        // init GoogleChromeCast helper
        let ifFinish = GoogleChromcastHelper.shareInstance.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight))
        showLoading()
        window?.makeKeyAndVisible()
        center.delegate = self
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        setupAppearance()
        migrateRealm()
        
        // comment start do 20 - 10 event

//        BITHockeyManager.shared().configure(withIdentifier: "d4d40ef730f344c097fc264f0948317d")
//        // Do some additional configuration if needed here
//        BITHockeyManager.shared().start()
//        BITHockeyManager.shared().authenticator.authenticateInstallation()
      self.setUpStatusBar()
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (_, _) in
                // Enable or disable features based on authorization.
                DispatchQueue.main.async(execute: {
                    application.registerForRemoteNotifications()
                })
            }
        } else {
            // Fallback on earlier versions
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            // Do what you want to happen when a remote notification is tapped.
            launchFromNotification = true
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
        return ifFinish
    }
   func setUpStatusBar (){
      if #available(iOS 13.0, *) {
//       q
         if DataManager.getStatusbarVaule() {
            UIApplication.shared.statusBarStyle =  .darkContent
            window?.overrideUserInterfaceStyle = .light
         }else{
            UIApplication.shared.statusBarStyle =  .lightContent
            window?.overrideUserInterfaceStyle = .dark
         }
      } else {
         UIApplication.shared.statusBarStyle =  .lightContent
        
         
      }
   }
    func migrateRealm() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 0,
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 0) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        print("Realm fileURL: \(Realm.Configuration.defaultConfiguration.fileURL)")
    }

    func showLoading() {
        LoadingWireFrame.presentLoadingModule(fromWindow: window)
    }

    func showHomePage() {
        let windowSence = UIWindow(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight))
        rootTabbarController = NewRootTabbarViewController()
        rootTabbarController.view.layoutIfNeeded()
        self.window = windowSence
        windowSence.rootViewController = rootTabbarController
         window?.makeKeyAndVisible()
        self.setUpStatusBar()
        if let model = notifyModel, launchFromNotification == true {
            // show detail view
            launchFromNotification = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.showRemoteNotificationDetails(model)
            })
        }
    }
    
    func showTutorial() {
        let vc = TutorialViewController.initWithNib()
        self.window?.rootViewController = vc
    }
    
    func setupAppearance() {
        let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.blackTitleColor(),
                         NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
        UINavigationBar.appearance().titleTextAttributes = titleDict
        UINavigationBar.appearance().tintColor = AppColor.blackTitleColor()
        UINavigationBar.appearance().barTintColor =  UIColor.white
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = #imageLiteral(resourceName: "iconBack")
        appearance.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "iconBack")
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.bold, size: 13), NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90()], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.bold, size: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray], for: .disabled)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.bold, size: 13), NSAttributedString.Key.foregroundColor: AppColor.babyBlueColor()], for: .highlighted)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.regular, size: 11)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90(), NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.regular, size: 11)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90(), NSAttributedString.Key.font: SFUIDisplayFont.fontWithType(.regular, size: 11)], for: .highlighted)
    }        
    
    func application(_ application: UIApplication,
                     didRegister notificationSettings: UIUserNotificationSettings) {
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceToken: \(deviceTokenString)")
        Messaging.messaging().apnsToken = deviceToken
        
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        DataManager.save(object: fcmToken, forKey: Constants.kDeviceToken)
    }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let model = RemoteNotificationModel(userInfo)
        if application.applicationState == .inactive && launchFromNotification {
            notifyModel = model
        } else if application.applicationState == .background {
            showRemoteNotificationDetails(model)
        } else {
            showRemoteNotificationPopup(model)
        }
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let model = RemoteNotificationModel(userInfo)
        if application.applicationState == .inactive && launchFromNotification {
            notifyModel = model
        } else if application.applicationState == .background {
            showRemoteNotificationDetails(model)
        } else {
            showRemoteNotificationPopup(model)
        }
    }
    
    func showRemoteNotificationPopup(_ model: RemoteNotificationModel) {
        guard let tabController = window?.rootViewController as? NewRootTabbarViewController else {
            return
        }
        if model.notificationType == .none {
            return
        }
//        let dialogController = DialogViewController(title: String.notification.uppercased(),
//                                                    message: model.message,
//                                                    confirmTitle: "XEM NGAY",
//                                                    cancelTitle: String.ignore.uppercased())
//        dialogController.confirmDialog = {(_ ) in
//            self.showRemoteNotificationDetails(model)
//        }
        
        var isShow = true
        if let nav = tabController.tabController.selectedViewController() as? BaseNavigationController {
            if let _ = nav.viewControllers.first as? UploadViewController {
                isShow = false
            }
            let topVC = topViewControllerWithRootViewController(rootViewController: nav)
            if #available(iOS 10.0, *) {
                if let _ = topVC as? SearchVoiceViewController {
                    isShow = false
                }
            }
        }
        if isShow {
            let viewcontroller = window?.rootViewController
//            viewcontroller?.present(dialogController, animated: true, completion: nil)
            
            viewcontroller?.showAlert(title: String.notification, message: model.message, okTitle: "Show", onOk: { (action) in
                
                self.showRemoteNotificationDetails(model)
            }, cancelTitle: String.ignore)
        }
        NotificationCenter.default.post(name: .kShouldGetNotification, object: nil)
    }
    
    func showRemoteNotificationDetails(_ model: RemoteNotificationModel) {
        guard let tabController = window?.rootViewController as? NewRootTabbarViewController else {
            return
        }
        switch model.notificationType {
        case .video:
            DispatchQueue.main.async(execute: {
                tabController.showVideoDetails(ContentModel(id: model.id))
            })
        case.channel:
            DispatchQueue.main.async(execute: {
               tabController.showChannelDetails(ChannelModel(id: model.id,numFollow: 0,numVideo: 0, viewCount: 0), isMyChannel: false)
            })
        case .link:
            DispatchQueue.main.async(execute: {
                let viewcontroller = WebViewViewController(model.id)
                let nav = BaseNavigationController(rootViewController: viewcontroller)
                tabController.present(nav, animated: true, completion: nil)
            })
        case .playlist:
            DispatchQueue.main.async(execute: {
                _ = DataManager.toggleSufferingPlaylist(false)
                tabController.showVideoPlaylistDetails(nil, from: PlaylistModel(with: model.id))
            })
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Stops monitoring network reachability status changes
        AppEvents.activateApp()
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Singleton.sharedInstance.isAcceptLossData = false
    
        let avgApiCallTime = Singleton.sharedInstance.totalAPICallDuration/Double(Singleton.sharedInstance.totalAPICallTimes)
        
        appService.ReportBySession(Singleton.sharedInstance.totalAPIError, Singleton.sharedInstance.totalAPISuccess, avgApiCallTime) { (result) in
        }
        
        Singleton.sharedInstance.totalAPISuccess = 0
        Singleton.sharedInstance.totalAPIError = 0
        Singleton.sharedInstance.totalAPICallTimes = 0
        Singleton.sharedInstance.totalAPICallDuration = 0.0
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // check internet
        ReachabilityManager.shared.startMonitoring()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        // handle deeplink: open application from shared link
        if url.absoluteString.contains("com.viettel.mclip") {
            // open app from shared link
            if let components = URLComponents(string: url.absoluteString), let items = components.queryItems {
                var videoId: String = ""
                var playlistId: String = ""
                for item in items where item.name == "id" {
                    videoId = item.value ?? ""
                }
                for item in items where item.name == "playlist_id" {
                    playlistId = item.value ?? ""
                }
                guard let tabController = window?.rootViewController as? NewRootTabbarViewController else {
                    return false
                }
                tabController.showVideoDetails(ContentModel(id: videoId))
            }
            return true
        }

//        let openFromFacebook = FBSDKApplicationDelegate.sharedInstance().application(application,
//                                                                                     open: url,
//                                                                                     sourceApplication: sourceApplication,
//                                                                                     annotation: annotation)
        let openFromGoogle = GIDSignIn.sharedInstance()?.handle(url as URL?) ?? false
//        return openFromFacebook || openFromGoogle
        return openFromGoogle
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let openFromFacebook = ApplicationDelegate.shared.application(app, open: url, options: options)
        return openFromFacebook
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return application.canOpenURL(url)
    }

    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
        if rootViewController == nil {
            return nil
        }

        if rootViewController.isKind(of: UITabBarController.self) {
            return topViewControllerWithRootViewController(rootViewController: (
                rootViewController as! UITabBarController).selectedViewController)
        } else if rootViewController.isKind(of: UINavigationController.self) {
            return topViewControllerWithRootViewController(rootViewController: (
                rootViewController as! UINavigationController).visibleViewController)
        } else if rootViewController.presentedViewController != nil {
            return topViewControllerWithRootViewController(
                rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
    func exitApp() {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        sleep(1)
        exit(0)
    }
    // Notification Delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert,.badge,.sound])
       }
       func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
             let respond = response.notification.request.content.userInfo
           let model = RemoteNotificationModel(respond)
               showRemoteNotificationPopup(model)
       }
}
