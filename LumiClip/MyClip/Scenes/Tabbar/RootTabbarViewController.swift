//
//  RootTabbarViewController.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit

class RootTabbarViewController: UITabBarController {
    lazy var homeVC = HomeViewController.initWithNib()
    lazy var notificationVC = NotificationViewController.initWithNib()
    lazy var uploadVC = UploadViewController.initWithNib()
    lazy var followVC = FollowViewController.initWithNib()
    lazy var profileVC = ProfileViewController.initWithNib()

    var playerManager: FWDraggableManager? = FWDraggableManager(configuration: FWSwipePlayerConfig())
    
    func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        if shouldRotate {
            return .all
        } else {
            return .portrait
        }
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
        tabBar.isTranslucent = false        
        // Do any additional setup after loading the view.
        let homeNav = BaseNavigationController(rootViewController: homeVC)
        homeNav.navigationBar.isHidden = true
        let homeItem = UITabBarItem(title: String.home,
                                    image: #imageLiteral(resourceName: "icHome"),
                                    selectedImage: #imageLiteral(resourceName: "icHomeActive"))
        homeNav.tabBarItem = homeItem
        
//        let notificationNav = BaseNavigationController(rootViewController: notificationVC)
//        let notificationItem = UITabBarItem(title: "Thông báo",
//                                            image: #imageLiteral(resourceName: "iconNotification").withRenderingMode(.alwaysOriginal),
//                                            selectedImage: #imageLiteral(resourceName: "iconNotificationActive"))
//        notificationItem.setTitleTextAttributes(normalAttributes, for: .normal)
//        notificationItem.setTitleTextAttributes(selectedAttributes, for: .selected)
//        notificationNav.tabBarItem = notificationItem
        
        let uploadNav = BaseNavigationController(rootViewController: uploadVC)
        let uploadItem = UITabBarItem(title: String.daang_tai,
                                      image: #imageLiteral(resourceName: "icDangTai"),
                                      selectedImage: #imageLiteral(resourceName: "icDangTaiActive"))
        uploadNav.tabBarItem = uploadItem
        
        let followNav = BaseNavigationController(rootViewController: followVC)
        let followItem = UITabBarItem(title: String.theo_doi,
                                      image: #imageLiteral(resourceName: "icTheoDoi"),
                                      selectedImage: #imageLiteral(resourceName: "icTheoDoiActive"))
        followNav.tabBarItem = followItem
        
        let profileNav = BaseNavigationController(rootViewController: profileVC)
        let profileItem = UITabBarItem(title: String.ca_nhan,
                                       image: #imageLiteral(resourceName: "icCaNhan"),
                                       selectedImage: #imageLiteral(resourceName: "icCaNhanActive"))
        profileNav.tabBarItem = profileItem
        
        self.viewControllers = [homeNav, uploadNav, followNav, profileNav]
        self.delegate = self
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
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
    }
    
    func openDetailsView(_ viewcontroller: VideoDetailViewController) {
        playerManager?.exit()
        if playerManager == nil {
            playerManager = FWDraggableManager(configuration: FWSwipePlayerConfig())
        }
        playerManager?.setDetailViewController(viewcontroller)
        playerManager?.show(at: self)
    }
    
    @objc func handleSwipePlayerViewStateChanged(_ notify: NSNotification) {
        let canrotate = notify.userInfo?[FWPlayerCanRotate] as? Bool ?? false
        shouldRotate = canrotate
    }
    
    // Notify when player is closed by horizontal swipe
    @objc func onPlayerExit(_ notify: NSNotification) {
        playerManager = nil
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension RootTabbarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let nav = viewController as? UINavigationController,
            let viewcontroller = nav.viewControllers.first as? UploadViewController {
            if !DataManager.isLoggedIn() {
                let viewcontroller = LoginConfigurator.viewController()
                let nav = BaseNavigationController(rootViewController: viewcontroller)
                nav.modalPresentationStyle = .overCurrentContext
                present(nav, animated: true, completion: nil)
                return false
            } else {
                return true
            }
        }
        return true
    }
}
