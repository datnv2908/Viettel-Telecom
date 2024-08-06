//
//  UIViewControllerExtension.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit
import Toast
import SVProgressHUD
import FirebaseAnalytics
import Countly 

extension UIViewController {
    class func initWithNibTemplate<T>() -> T {
        var nibName = String(describing: self)
        if Constants.isIpad {
            if let pathXib = Bundle.main.path(forResource: "\(nibName)_\(Constants.iPad)", ofType: "nib") {
                if FileManager.default.fileExists(atPath: pathXib) {
                    nibName = "\(nibName)_\(Constants.iPad)"
                }
            }
        }        
        let viewcontroller = self.init(nibName: nibName, bundle: Bundle.main)
        return viewcontroller as! T
    }

    func alertWithTitle(_ title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.dong_y, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func alertView(_ title: String?, message: String?) {
        let alertView = UIAlertView(title: title,
                                    message: message,
                                    delegate: nil,
                                    cancelButtonTitle: String.okString)
        alertView.show()
    }
    func showAlert(title: String?, message: String?, okTitle: String?, onOk: ((UIAlertAction) -> Void)?, cancelTitle: String = String.huy, isHtmlMessage: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if isHtmlMessage == true {
            alert.setValue(NSAttributedString(html: message!), forKey: "attributedMessage")
        }
        
        if okTitle != nil {
            alert.addAction(UIAlertAction(title: String.okString, style: .default, handler: onOk))
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func showHud(in containerView: UIView? = nil, with offset: CGFloat = 0, style: ProgressHudStyle = .custom) {
        if style == .custom {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.8))
            SVProgressHUD.setForegroundColor(UIColor.white)
            SVProgressHUD.setRingThickness(3)
            SVProgressHUD.setRingNoTextRadius(18)
        } else {
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setBackgroundColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.8))
            SVProgressHUD.setForegroundColor(UIColor.white)
            SVProgressHUD.setRingThickness(3)
            SVProgressHUD.setRingNoTextRadius(18)
        }
        SVProgressHUD.setContainerView(containerView)
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: offset))
        SVProgressHUD.show()
    }
    
    func hideHude() {
        SVProgressHUD.dismiss()
    }

    func openLogin() {
        let viewcontroller = LoginConfigurator.viewController()
        let nav = BaseNavigationController(rootViewController: viewcontroller)
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
    }
    
    func call(_ phoneNumber: String) {
        let url = URL(string:"tel://\(phoneNumber)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        } else {
            toast(String.thiet_bi_khong_the_thuc_hien_cuoc_goi)
        }
    }

    func toast(_ message: String) {
        view.toast(message)
    }

    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showVideoDetails(_ model: ContentModel, from playlist: PlaylistModel? = nil) {
        let viewcontroller = VideoDetailConfigurator.videoViewController(with: model)
            Constants.appDelegate.rootTabbarController.openDetailsView(viewcontroller)
        LoggingRecommend.videoClickAction(videoId: model.id, videoName: model.name)
    }

    func showVideoPlaylistDetails(_ model: ContentModel?, from playlist: PlaylistModel) {
        let viewcontroller = VideoDetailConfigurator.playlistViewController(with: model , and: playlist)
        Constants.appDelegate.rootTabbarController.openDetailsView(viewcontroller)
    }

    func showLocalVideoDetails(_ model: DownloadModel) {
        let viewcontroller = VideoDetailConfigurator.detailViewController(with: model)
        Constants.appDelegate.rootTabbarController.openDetailsView(viewcontroller)
    }

   func showChannelDetails(_ model: ChannelModel,isMyChannel : Bool) {
       // minimize player view if needed
       let tabbarController = Constants.appDelegate.rootTabbarController
       tabbarController.playerManager?.minimizePlayerView()
       let viewcontroller = ChannelDetailsViewController(model,isMyChannel: isMyChannel)

       (tabbarController.tabController.selectedViewController() as? BaseNavigationController)?.pushViewController(viewcontroller, animated: true)
   }
   func showPackage()  {
      let packageVC = ServicePackageViewController.initWithNib()
      let tabbarController = Constants.appDelegate.rootTabbarController
      tabbarController.playerManager?.minimizePlayerView()
      (tabbarController.tabController.selectedViewController() as? BaseNavigationController)?.pushViewController(packageVC, animated: true)
   }
    
    func presentDialog( _ dialog: DialogViewController, animated: Bool, completion: (() -> Void)?) {
        Constants.appDelegate.rootTabbarController.present(dialog, animated: animated, completion: completion)
    }
    
    func presentDialogEvent(_ dialog: DialogPictureViewController, animated: Bool, completion: (() -> Void)?) {
        Constants.appDelegate.rootTabbarController.present(dialog, animated: animated, completion: completion)
    }
    
    func handleError(_ error: NSError, automaticShowError: Bool = true, completion: @escaping CompletionBlock) {
        switch error.code {
        case APIErrorCode.requireLogin.rawValue:
            performLogin(completion: completion)
        case APIErrorCode.needMapAccount.rawValue:
            let viewcontroller = LinkAccountViewController.initWithNib()
            viewcontroller.completionBlock = {(result) in
                completion(result)
            }
            let nav = BaseNavigationController(rootViewController: viewcontroller)
            self.present(nav, animated: true, completion: nil)
        case APIErrorCode.refreshTokenFail.rawValue:
            self.showAlert(title: String.login, message: error.localizedDescription, okTitle: String.login, onOk: { _ in
                self.performLogin(completion: completion)
            })
//            let dialog = DialogViewController(title: String.login,
//                                              message: error.localizedDescription,
//                                              confirmTitle: String.login,
//                                              cancelTitle: String.cancel)
//            dialog.confirmDialog = { button in
//                self.performLogin(completion: completion)
//            }
//            self.presentDialog(dialog, animated: true, completion: nil)
        default:
            if automaticShowError {
                self.toast(error.localizedDescription)
            }
            completion(CompletionBlockResult(isCancelled: false, isSuccess: false, with: nil, error: error))
        }
    }
    
    func performLogin(animated: Bool = false, completion: @escaping CompletionBlock) {
        let loginManager = LoginManager()
        loginManager.login(from: self, animated: animated, handler: { (result, error) in
            completion(result)
        })
    }
    
    func isPlayingVideo() -> Bool {
        if let _ = (self.tabBarController as? RootTabbarViewController)?.playerManager {
            return true
        } else {
            return false
        }
    }

    func showInternetConnectionError() {
        Constants.appDelegate.rootTabbarController.showNoInternetPopup()
    }

    func logScreen(_ name: String) {
        logEvent(AnalyticsEventViewItem, params: [AnalyticsParameterItemName: name])
    }

    func logEvent(_ event: String, params: [String: Any]?) {
        Analytics.logEvent(event, parameters: params)
    }
    
    func logEventInAppPurchase(packageId: String){
        Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: [
            "packageId": packageId])
    }
   func getStatusBar(){
      if #available(iOS 13.0, *) {
         let appDelegate = UIApplication.shared.windows.first
         if let model = DataManager.getCurrentMemberModel() {
            if model.themeUser == 1 {
               UIApplication.shared.statusBarStyle =  .lightContent
               appDelegate?.overrideUserInterfaceStyle = .dark
               DataManager.saveStatusBarStyle(styleBarStatus: UIStatusBarStyle.lightContent.rawValue)
               
            }else{
               UIApplication.shared.statusBarStyle =  .darkContent
               appDelegate?.overrideUserInterfaceStyle = .light
               DataManager.saveStatusBarStyle(styleBarStatus: UIStatusBarStyle.darkContent.rawValue)
            }
            return
         }
            if DataManager.getStatusbarVaule() {
               UIApplication.shared.statusBarStyle =  .darkContent
               appDelegate?.overrideUserInterfaceStyle = .light
            }else{
               appDelegate?.overrideUserInterfaceStyle = .dark
               UIApplication.shared.statusBarStyle =  .lightContent
              
                            
            }
         
      }
   }
}
