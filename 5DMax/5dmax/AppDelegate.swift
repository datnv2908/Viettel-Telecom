//
//  AppDelegate.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
import MMDrawerController
import UserNotifications
import FirebaseCore
import RealmSwift
import FirebaseMessaging
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var settingService: SettingService? = SettingService()
    var notificationServices: NotificationServices = NotificationServices()
    var rootViewController = RootViewController.initWithNib()
     let center = UNUserNotificationCenter.current()
    private var launchFromNotification = false
    private var notifyModel: NotifyModel?
    var service = LoginInteractor()
    var hasTopNotch: Bool {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        } else {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }

        return false
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // init drawer controller
//        if DataManager.boolForKey("isSecond") == false {
////            let lang_arr = DataManager.objectForKey("AppleLanguages") as! NSArray
////            if (lang_arr.count < 1) {
//                DataManager.save(object: ["es"], forKey: "AppleLanguages")
//                DataManager.save(boolValue: true, forKey: "isSecond")
////            } else {
////                let lang = ["es", "vi", "en"].filter({$0 == (lang_arr[0] as! String)})
////                if (lang.count < 1) {
////                    DataManager.save(object: ["es"], forKey: "AppleLanguages")
////                }
////            }
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(registerDeviceToken), name:NSNotification.Name(rawValue: Constants.kNotificationLoginSuccess), object: nil)
        
        DataManager.save(object: "", forKey: Constants.kMPSDetectLink)
        DataManager.save(boolValue: false, forKey: "BANNER_TET")
        let ifFinish = GoogleChromcastHelper.shareInstance.application(application,
                                                                       didFinishLaunchingWithOptions: launchOptions)
        showLoading()
        let fonts = Bundle.main.urls(forResourcesWithExtension: "otf", subdirectory: nil)
        fonts?.forEach({ url in
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        })
        // get setting data
        getSettingData()
        setupAppearance()
        self.window?.makeKeyAndVisible()
        //        FBSDKAppEvents.activateApp()
        //        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        center.delegate = self
        if #available(iOS 10.0, *) {
            
            center.requestAuthorization(options:[.badge, .alert, .sound]) { (_, _) in
                // Enable or disable features based on authorization.
            }
        } else {
            // Fallback on earlier versions
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
            UIApplication.shared.registerForRemoteNotifications()
        }
        application.registerForRemoteNotifications()
        
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            // Do what you want to happen when a remote notification is tapped.
            launchFromNotification = true
        }
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        migrationRealm()
        // ViewRightWebiOS Configuration
        ViewRightWeb.provisionDevice()
        self.registerDeviceToken()
        
        return ifFinish
    }
    func getSettingData() {
        settingService?.getSetting(completion: { (model: SettingModel?, err: NSError?) in
            if let setting = model {
                DataManager.saveSetting(setting)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NavigationAnimation"), object: nil)
                self.mpsDetectLink(setting.mpsDetectLink)
                DLog("Lưu cấu hình mặc định")
            } else if let message = err?.localizedDescription {
                DLog("tải dữ liệu setting bị lỗi " + message)
            }
        })
    }
    
    func mpsDetectLink(_ url: String) {
        settingService?.mpsDetectLink(url, completion: { (model: String?, err: NSError?) in
            if let mpsDetectLink_data = model {
                DataManager.save(object: mpsDetectLink_data, forKey: Constants.kMPSDetectLink)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:Constants.nMPSDetectLinkSuccess), object: nil)
                DLog("Lấy được cấu hình mpsDetectLink")
            } else if let message = err?.localizedDescription {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue:Constants.nMPSDetectLinkFaild), object: nil)
                DLog("Tải dữ liệu mpsDetectLink bị lỗi " + message)
            }
        })
    }

    func showLoading() {
        LoadingWireFrame.presentLoadingModule(fromWindow: window)
    }

    func showTutorial() {
        let viewcontroller = TutorialViewController.initWithNib()
        viewcontroller.delegate = rootViewController
        let navigation = BaseNavigationViewController(rootViewController: viewcontroller)
        self.window?.rootViewController = navigation
    }

  

    func doLogout() {
        let service = UserService()
        // call logout api
        // do logout eventhough logout not success
        if let model = DataManager.getCurrentMemberModel() {
            service.logout(token: model.accessToken, completion: { (_) in
                
//                let loginType = DataManager.getCurrentMemberModel()?.loginType
//                if loginType == GrantType.loginSocial.stringValue() {
//                    let fbLoginManager = LoginManager()
//                    fbLoginManager.logOut()
//                }

                DataManager.clearLoginSession()
                self.window?.rootViewController = self.rootViewController
                self.rootViewController.showHome()
            })
        } else {
//            let loginType = DataManager.getCurrentMemberModel()?.loginType
//            if loginType == GrantType.loginSocial.stringValue() {
//                let fbLoginManager = LoginManager()
//                fbLoginManager.logOut()
//            }

            DataManager.clearLoginSession()
            self.window?.rootViewController = rootViewController
            self.rootViewController.showHome()
        }
    }

    @objc func registerDeviceToken() {
        let deviceToken = DataManager.objectForKey(Constants.kDeviceToken) as? String ?? ""
        if !deviceToken.isEmpty {
            if DataManager.isLoggedIn() && !UserDefaults.standard.bool(forKey: Constants.kDidRegisterDeviceToken) {
                let service = UserService()
                service.registerClientId(clientId: deviceToken, completion: { (result) in
                    switch result {
                    case .success:
                        DataManager.save(boolValue: true, forKey: Constants.kDidRegisterDeviceToken)
                    case .failure(_):
                        break
                    }
                })
            } else if !UserDefaults.standard.bool(forKey: Constants.kDidRegisterDeviceTokenDefault) {
                let service = UserService()
                service.registerClientId(clientId: deviceToken, completion: { (result) in
                    switch result {
                    case .success:
                        DataManager.save(boolValue: true, forKey: Constants.kDidRegisterDeviceTokenDefault)
                    case .failure(_):
                        break
                    }
                })
            }
        }
    }

    func setupAppearance() {
        let appearance = UINavigationBar.appearance()
        appearance.backIndicatorImage = UIImage(named: "back")
        appearance.backIndicatorTransitionMaskImage = UIImage(named: "back")
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        DataManager.save(object: deviceTokenString, forKey: Constants.kDeviceToken)
        Messaging.messaging().apnsToken = deviceToken
//        registerDeviceToken()
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let model = NotifyModel(userInfo)
        if application.applicationState == .inactive && launchFromNotification {
            notifyModel = model
        } else {
            let model = NotifyModel(userInfo)
            NotificationCenter.default.post(name: .receiveRemoteNotification, object: model)
        }
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        let model = NotifyModel(userInfo)
        if application.applicationState == .inactive && launchFromNotification {
            notifyModel = model
        } else {
            NotificationCenter.default.post(name: .receiveRemoteNotification, object: model)
        }
    }
    
    func showHomePage() {
        self.window?.rootViewController = rootViewController
        
        if let user = DataManager.getCurrentMemberModel(), user.needChangePassword == true {
            let changePassVC = FirstChangePassViewController.initWithNib()
            let nav = BaseNavigationViewController.initWithDefaultStyle(rootViewController: changePassVC)
            self.rootViewController.present(nav, animated: true, completion: nil)
        }
    
        if let model = notifyModel {
            if launchFromNotification {
                launchFromNotification = false
                let fromController = (window?.rootViewController as! BaseViewController)
                if model.contentType == .collection {
                    let groupModel = GroupModel(groupId:model.partId, name: model.message)
                    let category = CategoryModel(group: groupModel)
                    let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: true, isCollection: true)
                    viewcontroller.isFromMenu = true
                    viewcontroller.modalPresentationStyle = .fullScreen
                    fromController.present(viewcontroller, animated: true, completion: nil)
                    
                }else if model.contentType == .category{
                    let groupModel = GroupModel(groupId:"category_group_\(model.partId)", name: model.message)
                    let category = CategoryModel(group: groupModel)
                    let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: true, isCollection: false)
                    viewcontroller.isFromMenu = true
                    viewcontroller.modalPresentationStyle = .fullScreen
                    fromController.present(viewcontroller, animated: true, completion: nil)
                }else{
                    FilmDetailWireFrame.presentFilmDetailModule(window?.rootViewController as! BaseViewController,
                                                                film: model.parentId, part: model.partId, noti: true, sendView: true)
                    
                }
                 
            }
            
        }
    }
    
    func migrationRealm() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Apply any necessary migration logic here.
                }
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.Configuration.defaultConfiguration.deleteRealmIfMigrationNeeded = true
        DLog("Realm fileURL: \(Realm.Configuration.defaultConfiguration.fileURL)")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let count = notificationServices.getUnreadNotificationCount()
        UIApplication.shared.applicationIconBadgeNumber = count
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kNotificationResignActive), object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        let fbURL = URL(string: "fb://")
//        let fbInstalled = application.canOpenURL(fbURL!)
//        if fbInstalled == true {
//            let isCanOpen = FBSDKApplicationDelegate.sharedInstance().application(application,
//                                                                                  open: fbURL,
//                                                                                  sourceApplication: sourceApplication,
//                                                                                  annotation: annotation)
//
//            return isCanOpen
//        }
//
//        return application.canOpenURL(url)
//    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return application.canOpenURL(url)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     
        if url.scheme == "congphim5dmax" {
            var filmid: String = ""
            var part: String?
            if let components = url.absoluteString.components(separatedBy: "/").last {
                let subComponents = components.components(separatedBy: "&")
                for item in subComponents {
                    let params = item.components(separatedBy: "=")
                    if let firstParams = params.first, let value = params.last, value.count > 0 {
                        if firstParams == "film_id" {
                            filmid = value
                        } else if firstParams == "part" {
                            part = value
                        }
                    }
                }
            }
            
            if filmid.count > 0, let vc = self.window?.rootViewController {
                FilmDetailWireFrame.presentFilmDetailModule(vc, film: filmid, part: part, noti: true, sendView: true)
            }
        }
        return true
    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return true
    }

    func SecAddSharedWebCredential(_ fqdn: CFString,
                                   _ account: CFString,
                                   _ password: CFString?,
                                   _ completionHandler: @escaping (CFError?) -> Void) {
        
    }
    
    func SecRequestSharedWebCredential(_ fqdn: CFString?,
                                       _ account: CFString?,
                                       _ completionHandler: @escaping (CFArray?, CFError?) -> Void) {
        
    }
    //Rotate to landscape
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let rootViewController =
            self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
            
            let setting = DataManager.getDefaultSetting()
            if (rootViewController.isKind(of: GameViewController.self)) {
                if (setting?.game_landscape != "0") {
                    return [.landscapeLeft, .landscapeRight]
                }
            } else {
                if rootViewController.responds(to: Selector("canRotate")) {
                    return [.landscapeLeft, .landscapeRight]
                }
            }
        }

        return [.portrait]
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
    //Mark  : FCM delegate,UNUserNotificationCenterDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        DataManager.save(object: fcmToken, forKey: Constants.kDeviceToken)
//        self.subscribeTopic(topic: "global")
        NotificationCenter.default.addObserver(self, selector: #selector(registerDeviceToken), name:NSNotification.Name(rawValue: Constants.kNotificationLoginSuccess), object: nil)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let respond = response.notification.request.content.userInfo
        let model = NotifyModel(respond)
        notifyModel = model
        NotificationCenter.default.post(name: .receiveRemoteNotification, object: model)

    }
    func subscribeTopic(topic : String){
        Messaging.messaging().subscribe(toTopic: topic) { error in
          print("Subscribed to \(topic) topic")
        }
    }
}
