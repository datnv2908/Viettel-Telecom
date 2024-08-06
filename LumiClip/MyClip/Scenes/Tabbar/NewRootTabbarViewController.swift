//
//  RootTabbarViewController.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit
import EasyNotificationBadge
import ReachabilitySwift
import SnapKit
import GoogleCast

enum TabbarIndex: Int {
    case home = 0
    case recommend
    case trending
    case follow
    case profile
}

class NewRootTabbarViewController: BaseViewController {
    let service = AppService()
    var tabController: AZTabBarController!
    lazy var homeVC = HomeViewController.initWithNib()
    lazy var recommendVC = HomePageViewController.initWithNib()
    lazy var trendingVC = PopularViewController.initWithNib()
    lazy var followVC = FollowViewController.initWithNib()
    lazy var profileVC = ProfileViewController.initWithNib()

    var playerManager: FWDraggableManager? = FWDraggableManager(configuration: FWSwipePlayerConfig())

    var noInternetPopup: NotifyPopupView = NotifyPopupView()
    var notifyPopup = NotifyPopupView()
    var notifyNumber = 0

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if shouldRotate {
                return .all
            } else {
                return .portrait
            }
        }
        set {
            
        }
    }
   
   override var preferredStatusBarStyle: UIStatusBarStyle{
//      if #available(iOS 13.0, *) {
//         if DataManager.getStatusBarStyle() == UIStatusBarStyle.darkContent.rawValue {
//               return UIStatusBarStyle.darkContent
//         }else{
//            return UIStatusBarStyle.lightContent
//         }
//      } else {
//         return UIStatusBarStyle.lightContent
//      }
      return UIStatusBarStyle.lightContent
   }
    override var prefersStatusBarHidden: Bool {
        set {
            
        }
        get {
            return false
        }
    }
    
    private var shouldRotate: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        homeNav.title = String.home
        
        recommendVC.delegate = self
        let recommendNav = BaseNavigationController(rootViewController: recommendVC)
        recommendNav.title = String.de_xuat
        
        trendingVC.delegate = self
        let trendingNav = BaseNavigationController(rootViewController: trendingVC)
        trendingNav.title = String.thinh_hanh
        
        followVC.delegate = self
        let followNav = BaseNavigationController(rootViewController: followVC)
        followNav.title = String.theo_doi
        
        profileVC.delegate = self
        let profileNav = BaseNavigationController(rootViewController: profileVC)
        profileNav.title = String.ca_nhan
        
        let icons: [UIImage] = [#imageLiteral(resourceName: "icHome"),#imageLiteral(resourceName: "icRecommend"), #imageLiteral(resourceName: "icTrending"), #imageLiteral(resourceName: "icTheoDoi"), #imageLiteral(resourceName: "icCaNhan")]
        let sIcons: [UIImage] = [#imageLiteral(resourceName: "icHomeActive"),#imageLiteral(resourceName: "icRecommendActive"), #imageLiteral(resourceName: "icTrendingActive"), #imageLiteral(resourceName: "icTheoDoiActive"), #imageLiteral(resourceName: "icCaNhanActive")]
        
        let titles = [String.trang_chu, String.de_xuat, String.thinh_hanh, String.theo_doi, String.ca_nhan]
        tabController = AZTabBarController.insert(into: self, withTabIcons: icons, andSelectedIcons: sIcons)
        tabController.delegate = self
        tabController.set(viewController: homeNav, atIndex: TabbarIndex.home.rawValue)
        tabController.set(viewController: recommendNav, atIndex: TabbarIndex.recommend.rawValue)
        tabController.set(viewController: trendingNav, atIndex: TabbarIndex.trending.rawValue)
        tabController.set(viewController: followNav, atIndex: TabbarIndex.follow.rawValue)
        tabController.set(viewController: profileNav, atIndex: TabbarIndex.profile.rawValue)
        tabController.tabbarTitles = titles
      
        tabController.selectedColor = UIColor.colorFromHexa(Constants.mainColorHex)
      if #available(iOS 13.0, *) {
//         tabController.defaultColor = UIColor.settitleColor()
         tabController.buttonsBackgroundColor = UIColor.setViewColor()
      } else {
         // Fallback on earlier versions
      }
       
        tabController.selectionIndicatorHeight = 0.0
//      tabController.separatorLineColor = UIColor.setViewColor()
        tabController.normalFont = SFUIDisplayFont.fontWithType(.regular, size: 11)
        tabController.selectedFont = SFUIDisplayFont.fontWithType(.regular, size: 11)
        setupViews()
        
//        tabController?.buttonsContainer.layer.shadowColor = UIColor.white.cgColor
//        tabController?.buttonsContainer.layer.shadowOffset = CGSize(width: 0, height: -8)
//        tabController?.buttonsContainer.layer.shadowRadius = 5
//        tabController?.buttonsContainer.layer.shadowOpacity = 1.0
//        tabController?.buttonsContainer.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(addShadow), name: NSNotification.Name(rawValue: "addShadow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeShadow), name: NSNotification.Name(rawValue: "removeShadow"), object: nil)
        
    }
    
    @objc func addShadow() {
        tabController?.buttonsContainer.layer.masksToBounds = false
    }
    
    @objc func removeShadow() {
        tabController?.buttonsContainer.layer.masksToBounds = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getStatusBar()
        setNeedsStatusBarAppearanceUpdate()
//        UIApplication.shared.setStatusBarStyle(.default, animated: false)
//        if let model = DataManager.getCurrentAccountSettingsModel() {
//            if(model.event == "20-10"){
//                UIApplication.shared.statusBarStyle = .default
//            }else if(model.event == "aff-cup"){
//                UIApplication.shared.statusBarStyle = .lightContent
//            }
//            else{
//                UIApplication.shared.statusBarStyle = .default
//            }
//        }else{
//            UIApplication.shared.statusBarStyle = .default
//        }
        getNotification()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setupViews() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleSwipePlayerViewStateChanged(_:)),
                                               name: NSNotification.Name(rawValue: FWSwipePlayerViewStateChange),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPlayerExit(_:)),
                                               name: NSNotification.Name(rawValue: FWDidExitPlayer),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onPlayerExitBySwipe(_:)),
                                               name: NSNotification.Name(rawValue: FWDidExitPlayerBySwipe),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shouldClosePlayer(_:)),
                                               name: .kShouldClosePlayer,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shouldGetNotification(_:)),
                                               name: .kShouldGetNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(uploadStarted(_:)),
                                               name: .kNotificationUploadStarted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showUploadSuccces(_:)),
                                               name: .uploadSuccess,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(downloadStarted(_:)),
                                               name: .kNotificationDownloadStarted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showDownloaddSuccces(_:)),
                                               name: .kNotificationDownloadCompleted,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(afterRemoveDownloadItem(_:)),
                                               name: .kNotificationRemovedDownloadItem,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showOutOfMemory(_:)),
                                               name: .kOutOfMemory,
                                               object: nil)
        ReachabilityManager.shared.addListener(listener: self)
        noInternetPopup.setupNotifyView(from: self)
        notifyPopup.setupNotifyView(from: self)
    }

    func getNotification() {
        if !DataManager.isLoggedIn() {
            return
        }
        service.getNotifications { (result) in
            switch result {
            case .success(let response):
                var count = 0
                for model in response.data {
                    if !model.isRead {
                        count += 1
                    }
                }
                var appearence = BadgeAppearance()
                appearence.distanceFromCenterY = -4
                appearence.distanceFromCenterX = 10
                self.notifyNumber = count
                self.updateNotifyNumber()
            case .failure(_):
                break
            }
        }
    }

    @objc func shouldGetNotification(_ notification: Notification) {
        if DataManager.isLoggedIn() {
             getNotification()
        }else{
            notifyNumber = 0;
            updateNotifyNumber()
        }
    }
    
    func updateNotifyNumber(){
       
        self.homeVC.updateNotifyNumber(notifyNumber)
        self.recommendVC.updateNotifyNumber(notifyNumber)
        self.trendingVC.updateNotifyNumber(notifyNumber)
        self.followVC.updateNotifyNumber(notifyNumber)
        self.profileVC.updateNotifyNumber(notifyNumber)
    }

    func showNoInternetPopup(_ animate: Bool = true) {
        weak var wself = self
        var actionTitle: String
        if visibleViewController() is DownloadViewController || !DownloadManager.haveDownloadedVideos(){
            actionTitle = ""
        } else {
            actionTitle = String.den_tai_xuong.uppercased()
        }
        noInternetPopup.update(with: String.khong_co_ket_noi, actionTitle: actionTitle, actionBlock: { (_) in
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            wself?.playerGoToMini()
            wself?.noInternetPopup.hide()
            wself?.gotoMyDownloads()
        })
        noInternetPopup.show(autoDismiss: true)
    }

    func hideNoInternetPopup() {
        noInternetPopup.hide()
        notifyPopup.update(with: String.da_thiet_lap_ket_noi, actionTitle: "") { (_) in

        }
        notifyPopup.show()
    }
    
    @objc func showOutOfMemory(_ notification: Notification) {
        alertWithTitle(String.thong_bao, message: String.bo_nho_khong_du_tai_video)
    }
    
    @objc func afterRemoveDownloadItem(_ notification: Notification) {
        notifyPopup.hide()
    }
    
    @objc func downloadStarted(_ notification: Notification) {
        weak var wself = self
        var actionTitle: String
        if playerManager?.isInFullMode == true {
            actionTitle = String.xem.uppercased()
        } else {
            if visibleViewController() is DownloadViewController {
                actionTitle = ""
            } else {
                actionTitle = String.xem.uppercased()
            }
        }
        notifyPopup.update(with: String.dang_tai_xuong, actionTitle: actionTitle) { (_) in
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            wself?.playerGoToMini()
            wself?.gotoMyDownloads()
        }
        notifyPopup.show(autoDismiss: false)
    }

    @objc func showDownloaddSuccces(_ notification: Notification) {
        weak var wself = self
        var actionTitle: String
        if visibleViewController() is DownloadViewController {
            actionTitle = ""
        } else {
            actionTitle = String.xem.uppercased()
        }
        notifyPopup.update(with: String.tai_xuong_thanh_cong, actionTitle: actionTitle) { (_) in
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            wself?.playerGoToMini()
            wself?.gotoMyDownloads()
        }
        notifyPopup.show()
    }

    @objc func uploadStarted(_ notification: Notification) {
        weak var wself = self
        var actionTitle: String
        if visibleViewController() is MyListViewController {
            actionTitle = ""
        } else {
            actionTitle = String.xem.uppercased()
        }
        notifyPopup.update(with: String.dang_tai_len, actionTitle: actionTitle) { (_) in
            wself?.gotoMyList()
        }
        notifyPopup.show(autoDismiss: false)
    }

    @objc func showUploadSuccces(_ notification: Notification) {
        weak var wself = self
        var actionTitle: String
        if visibleViewController() is MyListViewController {
            actionTitle = ""
        } else {
            actionTitle = String.xem.uppercased()
        }
        notifyPopup.update(with: String.tai_len_thanh_cong, actionTitle: actionTitle) { (_) in
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            wself?.playerGoToMini()
            wself?.gotoMyList()
        }
        notifyPopup.show()
        
        // show accept upload term condition if it's firsttime upload
        if(Singleton.sharedInstance.isHasVideo == 0){
            Singleton.sharedInstance.isHasVideo = 1
            if(Singleton.sharedInstance.userStatus != 1
                && Singleton.sharedInstance.userStatus != 2){
                let updateInforVC = ContractTermsConditionViewController(false)
                let nav = self.tabController.selectedViewController() as? BaseNavigationController
                nav?.pushViewController(updateInforVC, animated: true)
            }
        }
    }

    func showSelectVideoViewController() {
        if DataManager.isLoggedIn() {
            NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
            let selectVideoVC = SelectVideoViewController.initWithNib()
            let nav = BaseNavigationController(rootViewController: selectVideoVC)
            present(nav, animated: true, completion: nil)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                    let selectVideoVC = SelectVideoViewController.initWithNib()
                    let nav = BaseNavigationController(rootViewController: selectVideoVC)
                    self.present(nav, animated: true, completion: nil)
                }
            })
        }
    }
    
    func openTab(at index: TabbarIndex) {
        tabController.set(selectedIndex: index.rawValue, animated: true)
    }
    
    func playerGoToMini() {
        playerManager?.minimizePlayerView()
    }
    
    func openDetailsView(_ viewcontroller: VideoDetailViewController) {
        playerManager?.exit()
        playerManager = FWDraggableManager(configuration: FWSwipePlayerConfig())
        playerManager?.delegate = self
        playerManager?.setDetailViewController(viewcontroller)
        playerManager?.show(at: self)
    }
    
    @objc func handleSwipePlayerViewStateChanged(_ notify: NSNotification) {
        let canrotate = notify.userInfo?[FWPlayerCanRotate] as? Bool ?? false
        shouldRotate = canrotate
    }
    
    // Notify when player is closed by horizontal swipe
    @objc func onPlayerExit(_ notify: NSNotification) {
//        playerManager = nil
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }
    
    @objc func onPlayerExitBySwipe(_ notify: NSNotification) {
        VideosWatched.list.removeAll()
    }
    
    @objc func shouldClosePlayer(_ notify: NSNotification) {
        playerManager?.exit()
        playerManager = nil
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }

    //mark: -- device rotation functions
    override var shouldAutorotate: Bool {
        return shouldRotate
    }

    func gotoMyList() {
        if visibleViewController() is MyListViewController {
            return
        }
        self.tabController.set(selectedIndex: 4, animated: false)
        let nav = self.tabController.selectedViewController() as? BaseNavigationController
        let vc = MyListViewController.initWithNib()
        nav?.pushViewController(vc, animated: true)
    }

    func gotoMyDownloads() {
        if visibleViewController() is DownloadViewController {
            return
        }
        let nav = self.tabController.selectedViewController() as? BaseNavigationController
        let vc = DownloadViewController.initWithNib()
        nav?.pushViewController(vc, animated: true)
    }

    func visibleViewController() -> UIViewController? {
        return (tabController.selectedViewController() as? UINavigationController)?.topViewController
    }

    deinit {
        ReachabilityManager.shared.removeListener(listener: self)
        NotificationCenter.default.removeObserver(self)
    }
}

extension NewRootTabbarViewController: AZTabBarDelegate {
    func tabBar(_ tabBar: AZTabBarController, shouldOpenTab index: Int) -> Bool {
        if DataManager.isLoggedIn() {
            return true
        } else {
            if !Singleton.sharedInstance.isConnectedInternet {
                showInternetConnectionError()
                return false
            }
            if index == TabbarIndex.profile.rawValue
                || index == TabbarIndex.follow.rawValue {
                performLogin(animated: true, completion: { (result) in
                    if result.isSuccess {
                        self.tabController.set(selectedIndex: index, animated: false)
                    }
                })
                return false
            } else {
                return true
            }
        }
    }
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int) {
    }
    
//    lazy var homeVC = HomeViewController.initWithNib()
//    lazy var recommendVC = HomePageViewController.initWithNib()
//    lazy var trendingVC = PopularViewController.initWithNib()
//    lazy var followVC = FollowViewController.initWithNib()
//    lazy var profileVC = ProfileViewController.initWithNib()
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int, previousIndex: Int) {
        if previousIndex == index {
            if let nav = tabBar.selectedViewController() as? BaseNavigationController {
                nav.popToRootViewController(animated: true)
                if let viewcontroller = nav.viewControllers.first as? HomeViewController {
                    if(viewcontroller.isViewLoaded && (viewcontroller.view.window != nil)){
                        viewcontroller.goToTop()
                    }
                    viewcontroller.backToMyClipPage()
                }
                
                if let viewcontroller = nav.viewControllers.first as? HomePageViewController {
                    if(viewcontroller.isViewLoaded && (viewcontroller.view.window != nil)){
                        viewcontroller.goToTop()
                    }
                }
                
                if let viewcontroller = nav.viewControllers.first as? PopularViewController {
                    if(viewcontroller.isViewLoaded && (viewcontroller.view.window != nil)){
                        viewcontroller.goToTop()
                    }
                }
                
                if let viewcontroller = nav.viewControllers.first as? FollowViewController {
                    if(viewcontroller.isViewLoaded && (viewcontroller.view.window != nil)){
                        viewcontroller.goToTop()
                    }
                }
                
            }
        }else{
            updateNotifyNumber();
        }
//      self.getStatusBar()
    }
}

extension NewRootTabbarViewController: NetworkStatusListener {
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        switch status {
        case .notReachable:
            DispatchQueue.main.async(execute: {
                self.showNoInternetPopup()
            })
        case .reachableViaWiFi:
            DispatchQueue.main.async(execute: {
                self.hideNoInternetPopup()
            })
        case .reachableViaWWAN:
            DispatchQueue.main.async(execute: {
                self.hideNoInternetPopup()
            })
        }
    }
}

extension NewRootTabbarViewController: FWDraggableManagerDelegate {
    func player(_ player: MyCustomPlayer!, finishedVerticalSwipe isSmall: Bool) {
        // close mini player when connecting to Chromecast
        if GCKCastContext.sharedInstance().castState == .connected && isSmall && tabController.miniChromecastPlayerVC.active {
            NotificationCenter.default.post(name: .kShouldClosePlayer, object: nil)
        } else {
            // don't do any thing
        }
    }
}

extension NewRootTabbarViewController: BaseHomeSimpleTableViewDelegate {
    func initHeaderFinish() {
        updateNotifyNumber()
    }
}
