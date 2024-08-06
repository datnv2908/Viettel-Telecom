//
//  RootViewController.swift
//  5dmax
//
//  Created by Hoang on 3/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import MMDrawerController
import GoogleCast
import SnapKit

class RootViewController: BaseViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!

    var drawerController = DrawerContainerViewController()
    var miniChromecastPlayerVC: GCKUIMiniMediaControlsViewController!
    var castContainerVC: GCKUICastContainerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(drawerController)
        topView.addSubview(drawerController.view)
        drawerController.view.snp.remakeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }
        drawerController.didMove(toParent: self)

        let castContext = GCKCastContext.sharedInstance()
        miniChromecastPlayerVC = castContext.createMiniMediaControlsViewController()
        miniChromecastPlayerVC.delegate = self
        miniChromecastPlayerVC.view.backgroundColor = AppColor.blackTwo()

        let btnPlay = miniChromecastPlayerVC.customButton(at: UInt(GCKUIMediaButtonType.playPauseToggle.rawValue))
        btnPlay?.setTitleColor(UIColor.white, for: .normal)
        btnPlay?.tintColor = UIColor.white

        self.addChild(miniChromecastPlayerVC)
        miniChromecastPlayerVC.view.frame = bottomView.bounds
        bottomView.addSubview(miniChromecastPlayerVC.view)
        miniChromecastPlayerVC.didMove(toParent: self)
        miniChromecastPlayerVC.view.snp.remakeConstraints { (make: ConstraintMaker) in
            make.edges.equalToSuperview()
        }

        updateMiniPlayer()
        setUpMiniPlayer()
    }

    func setUpMiniPlayer() {

        if #available(iOS 9.0, *) {

        } else {
            // Fallback on earlier versions
        }
    }

    /*
    func castDeviceDidChange(_ notification: Notification) {
        if GCKCastContext.sharedInstance().castState != .noDevicesAvailable {
            // You can present the instructions on how to use Google Cast on
            // the first time the user uses you app
            GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce()
        }
    }
    
    func deviceOrientationDidChange(_ notification: Notification) {
        
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateMiniPlayer() {

        if GCKCastContext.sharedInstance().castState == .connected {
            if miniChromecastPlayerVC.active {
                bottomView.snp.remakeConstraints({ (make: ConstraintMaker) in
                    make.height.equalTo(60.0)
                })

            } else {
                bottomView.snp.remakeConstraints({ (make: ConstraintMaker) in
                    make.height.equalTo(0.0)
                })
            }
        } else {
            bottomView.snp.remakeConstraints({ (make: ConstraintMaker) in
                make.height.equalTo(0.0)
            })
        }
    }

    func showHome() {
        drawerController.showHome()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.gckCastStateDidChange,
                                                  object: GCKCastContext.sharedInstance())

    }
}

extension RootViewController: GCKUIMiniMediaControlsViewControllerDelegate {

    func miniMediaControlsViewController(_ miniMediaControlsViewController: GCKUIMiniMediaControlsViewController,
                                         shouldAppear: Bool) {
        updateMiniPlayer()
    }
}

extension RootViewController: PopupPromotionViewDelegate {
    func registerPromotionAppFinish(message : String) {
        if(self.drawerController.centerViewController != nil){
            self.drawerController.centerViewController.toast(message)
        }else{
            self.toast(message)
        }
    }
}

