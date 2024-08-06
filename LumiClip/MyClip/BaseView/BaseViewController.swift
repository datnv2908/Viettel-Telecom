//
//  BaseViewController.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

@objcMembers
class BaseViewController: UIViewController {
   
   let videoService = VideoServices()
   override func viewDidLoad() {
      super.viewDidLoad()
      setupView()
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UIViewController.attemptRotationToDeviceOrientation()
   }
   
   func setupView() {
      self.view.backgroundColor = UIColor.setViewColor()
   }
   
   override var prefersStatusBarHidden: Bool {
      return false
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   class func initWithDefautlStoryboardWithID(storyboardId: String!) -> Self {
      let className = String(describing: self)
      return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: storyboardId)
   }
   
   class func initWithNib() -> Self {
      let bundle = Bundle.main
      let fileManege = FileManager.default
      let nibName = String(describing: self)
      if let pathXib = Bundle.main.path(forResource: nibName, ofType: "nib") {
         if fileManege.fileExists(atPath: pathXib) {
            return initWithNibTemplate()
         }
      }
      if let pathStoryboard = bundle.path(forResource: nibName, ofType: "storyboardc") {
         if fileManege.fileExists(atPath: pathStoryboard) {
            return initWithDefautlStoryboard()
         }
      }
      return initWithNibTemplate()
   }
   
   func onDismiss() {
      let transition = CATransition()
      transition.duration = 0.3
      transition.type = CATransitionType.reveal
      transition.subtype = CATransitionSubtype.fromBottom
      navigationController?.view.layer.add(transition, forKey: kCATransition)
      navigationController?.popViewController(animated: false)
   }
   
   // MARK:
   // MARK:
   private class func initWithDefautlStoryboard() -> Self {
      var className = String(describing: self)
      if Constants.isIpad {
         if let pathXib = Bundle.main.path(forResource: "\(className)_\(Constants.iPad)",
                                           ofType: "storyboardc") {
            if FileManager.default.fileExists(atPath: pathXib) {
               className = "\(className)_\(Constants.iPad)"
            }
         }
      }
      let storyboardId = className
      return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: storyboardId)
   }
   
   private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
      let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
      return controller
   }
   
   func emptyView() -> UIView {
      let label           = UILabel()
      label.text          = String.noData
      label.textAlignment = .center
      label.font          = AppFont.font(size: 17)
      label.textColor     = UIColor.setDarkModeColor(color1: AppColor.imBlackColor(), color2: .white)
      return label
   }
   
   func offlineView() -> UIView {
      let bgView = Bundle.main.loadNibNamed("NoInternetView",
                                            owner: nil,
                                            options: nil)?.first as! NoInternetView
      if DownloadManager.shared.getAllDownloadedVideo().isEmpty {
         bgView.descriptionLabel.text = String.noDataVideoOffline
         bgView.goToDownloadButton.isHidden = true
      } else if self is DownloadViewController {
         bgView.goToDownloadButton.isHidden = true
      } else {
         bgView.descriptionLabel.text = String.xem_video_tai_xuong_trong_trang_ca_nhan
         bgView.goToDownloadButton.isHidden = false
      }
      bgView.delegate = self
      return bgView
   }
}

extension BaseViewController: NoInternetViewDelegate {
   @objc func onRetry(_ view: NoInternetView, sender: UIButton) {
      
   }
   
   func openDownloadedVideos(_ view: NoInternetView, sender: UIButton) {
      let vc = DownloadViewController.initWithNib()
      navigationController?.pushViewController(vc, animated: true)
   }
   
   func openDownloadedFromHome() {
      let vc = DownloadViewController.initWithNib()
      navigationController?.pushViewController(vc, animated: false)
   }
}

extension BaseViewController {
   func showMoreAction(for model: ContentModel) {
      let actionsheetController = ActionSheetViewController()
      let watchLaterAction = Action(ActionData(title: String.them_vao_xem_sau, image: #imageLiteral(resourceName: "iconLater")),
                                    style: .default) { (action) in
         self.addToWatchLater(model)
      }
      let addToPlaylistAction = Action(ActionData(title: String.them_vao_danh_sach_phat, image: #imageLiteral(resourceName: "iconAddToPlaylist")),
                                       style: .default) { (action) in
         self.addToPlaylist(model)
      }
      let shareAction = Action(ActionData(title: String.chia_se, image: #imageLiteral(resourceName: "iconShare")),
                               style: .default) { (action) in
         self.share(model)
      }
      actionsheetController.addAction(watchLaterAction)
      actionsheetController.addAction(addToPlaylistAction)
      
      //        if DownloadManager.shared.isDownloaded(video: model.id) {
      //            let downloadAction = Action(ActionData(title: String.xoa_noi_dung_khoi_thu_muc_tai_xuong, image: #imageLiteral(resourceName: "iconRemoveGray")),
      //                                        style: .default) { (action) in
      //                                            self.downloadVideo(model)
      //            }
      //            actionsheetController.addAction(downloadAction)
      //        } else {
      //            let downloadAction = Action(ActionData(title: String.tai_xuong, image: #imageLiteral(resourceName: "iconDownload")),
      //                                        style: .default) { (action) in
      //                                            self.downloadVideo(model)
      //            }
      //            actionsheetController.addAction(downloadAction)
      //        }
      
      actionsheetController.addAction(shareAction)
      present(actionsheetController, animated: true, completion: nil)
   }
   
   @objc func addToPlaylist(_ model: ContentModel) {
      if DataManager.isLoggedIn() {
         videoService.getAllPlaylist { (result) -> (Void) in
            switch result {
            case .success(let response):
               let actionsheetController = ActionSheetViewController()
               
               let addPlaylistAction = Action(ActionData(title: String.tao_danh_sach_phat_moi, image: #imageLiteral(resourceName: "iconAddToPlaylist")),
                                              style: .default) { (action) in
                  self.addNewPlaylist(with: model)
               }
               actionsheetController.addAction(addPlaylistAction)
               
               //                    let addWatchLateAction = Action(ActionData(title: String.xem_sau, image: #imageLiteral(resourceName: "iconLater") ),
               //                                                    style: .default) { (action) in
               //                                                        self.addToWatchLater(model)
               //                    }
               //                    actionsheetController.addAction(addWatchLateAction)
               
               for item in response.data {
                  let playlistAction = Action(ActionData(title: item.name, image: #imageLiteral(resourceName: "iconPlayPlaylist")),
                                              style: .default) { (action) in
                     self.addToPlaylist(item, video: model)
                  }
                  actionsheetController.addAction(playlistAction)
               }
               actionsheetController.collectionView.contentInset = UIEdgeInsets(top: Constants.screenHeight/2, left: 0, bottom: 0, right: 0)
               self.present(actionsheetController, animated: true, completion: nil)
            case .failure(let error):
               self.handleError(error as NSError, completion: { (result) in
                  if result.isSuccess {
                     self.addToPlaylist(model)
                  }
               })
            }
         }
      } else {
         performLogin(completion: { (result) in
            if result.isSuccess {
               self.addToPlaylist(model)
            }
         })
      }
   }
   
   func addToWatchLater(_ model: ContentModel) {
      if DataManager.isLoggedIn() {
         videoService.toggleWatchLater(id: model.id, status: 1) { (result) in
            switch result {
            case .success(let response):
               self.toast(response.data)
            case .failure(let error):
               self.handleError(error as NSError, completion: { (result) in
                  if result.isSuccess {
                     self.addToWatchLater(model)
                  }
               })
            }
         }
      } else {
         performLogin(completion: { (result) in
            if result.isSuccess {
               self.addToWatchLater(model)
            }
         })
      }
      
   }
   
   func addToPlaylist(_ playlistModel: PlaylistModel, video content: ContentModel) {
      videoService.toggleVideoToPlaylist(playlistId: playlistModel.id, videoId: content.id, status: 1) { (result) in
         switch result {
         case .success(let response):
            self.toast(response.message)
         case .failure(let error):
            self.handleError(error as NSError, completion: { (result) in
               if result.isSuccess {
                  self.addToPlaylist(playlistModel, video: content)
               }
            })
         }
      }
      LoggingRecommend.addPlaylistAction(channelId: content.userId, channelName: content.userName, videoId: content.id, playlistId: playlistModel.id)
   }
   
   func addNewPlaylist(with model: ContentModel? = nil) {
      let viewcontroller = AddPlaylistViewController.initWithNib()
      weak var wself = self
      viewcontroller.completionBlock = {(result) in
         if let content = model, let playlist = result.userInfo?["model"] as? PlaylistModel {
            wself?.addToPlaylist(playlist, video: content)
         } else {
            if !result.isCancelled && result.isSuccess {
               if let message = result.userInfo?[NSLocalizedDescriptionKey] as? String {
                  wself?.toast(message)
               }
            }
         }
      }
      let nav = BaseNavigationController(rootViewController: viewcontroller)
      present(nav, animated: true, completion: nil)
   }
   
   func downloadVideo(_ model: ContentModel) {
      DLog("onDownloadVideo")
      let videoId = model.id
      if DownloadManager.shared.isDownloading(video: videoId) {
         // don't do anything when downloading
         return
      } else if DownloadManager.shared.isDownloaded(video: videoId) {
         //            let dialogController = DialogViewController(title: "\(String.xoa_khoi_danh_sach_video_tai_xuong)?",
         //                                                        message: String.video_nay_se_khong_co_san_de_xem_ngoai_tuyen,
         //                                                        confirmTitle: String.xoa.uppercased(),
         //                                                        cancelTitle: String.huy.uppercased())
         //            dialogController.confirmDialog = {(_) in
         //                DownloadManager.shared.deleteVideo(videoId)
         //                NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem,
         //                                                object: nil)
         //            }
         //            self.presentDialog(dialogController,
         //                                                         animated: true,
         //                                                         completion: nil)
         
         self.showAlert(title: String.xoa_khoi_danh_sach_video_tai_xuong, message: String.video_nay_se_khong_co_san_de_xem_ngoai_tuyen, okTitle: String.xoa, onOk: { _ in
            DownloadManager.shared.deleteVideo(videoId)
            NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem,
                                            object: nil)
         })
      } else {
         if DataManager.isLoggedIn() {
            showHud()
            videoService.getDownloadLink(videoId) { (result) in
               self.hideHude()
               switch result {
               case .success(let response):
                  if response.data.errorCode == APIErrorCode.success {
                     let video = DetailModel(from: model)
                     DownloadManager.shared.downloadVideo(link: response.data.urlStreaming,
                                                          video: video)
                     NotificationCenter.default.post(name: .kNotificationDownloadStarted,
                                                     object: nil)
                  } else {
                     self.toast(response.data.message)
                  }
               case .failure(let error):
                  self.toast(error.localizedDescription)
               }
            }
            
            LoggingRecommend.downloadVideoAction(videoId: model.id, videoName: model.name)
         } else {
            doLogin(with: { (success) in
            })
         }
      }
   }
   
   func share(_ model: ContentModel) {
      shareWithLink(model.linkSocial)
   }
   
   func shareWithLink(_ link: String) {
      if let url = URL(string: link) {
         let controller = UIActivityViewController(activityItems: [url],
                                                   applicationActivities: nil)
         if let wPPC = controller.popoverPresentationController {
            wPPC.sourceView = self.view
         }
         self.present(controller, animated: true, completion: nil)
      } else {
         toast(String.linkToShareNotAvailable)
      }
   }
   
   internal func doLogin(with completion: @escaping (Bool) -> Void ) {
      self.performLogin(completion: { (result) in
         if result.isSuccess {
            completion(true)
         } else {
            completion(false)
         }
      })
   }
}
