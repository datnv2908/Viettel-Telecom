//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import Foundation
import UIKit
import GoogleCast
import MessageUI
import FirebasePerformance
import ReachabilitySwift

enum VideoDetailSectionIndex: Int {
   case info = 0
   case related = 1
}

class VideoDetailPresenter: NSObject, MFMessageComposeViewControllerDelegate {
   weak var view: VideoDetailViewControllerInput?
   var viewModel: VideoDetailViewModel?
   var interactor: VideoDetailInteractorInput?
   var wireFrame: VideoDetailWireFrameInput?
   let service = AppService()
   let videoService = VideoServices()
   var isGettingData: Bool = false
   
   var kpiTimer: Timer?
   var bandwidthTimer: Timer?
   var bandwidthRangeCount: Double = 0
   var bandwidthTotalCount: Double = 0
   var bandwidthRange: Double = 0
   var bandwidthTotal: Double = 0
   
   var trace: Trace?
   
   internal func showContentDetails(_ model: ContentModel?, withinPlaylist: Bool) {
      sendWatchTime()
      viewModel?.changeItemWithinPlaylist = withinPlaylist
      viewModel?.contentModel = model
      view?.doReloadPlayer()
      view?.doReloadTableView()
      view?.doCloseSubComment()
      getData()
   }
   
   func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
      let titleDict = [NSAttributedString.Key.foregroundColor: UIColor.white,
                       NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
      UINavigationBar.appearance().titleTextAttributes = titleDict
      controller.dismiss(animated: true, completion: nil)
   }
   
   deinit {
      DLog("")
      NotificationCenter.default.removeObserver(self)
      kpiTimer?.invalidate()
      kpiTimer = nil
      
      bandwidthTimer?.invalidate()
      bandwidthTimer = nil
   }
}

// MARK: 
// MARK: VIEW
extension VideoDetailPresenter: VideoDetailViewControllerOutput {
   func viewDidLoad() {
      view?.doReloadPlayer()
      getData()
      let notificationCenter = NotificationCenter.default
      notificationCenter.addObserver(self,
                                     selector: #selector(appMovedToBackground(_:)),
                                     name: UIApplication.willResignActiveNotification,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(appMovedToForeground(_:)),
                                     name: UIApplication.didBecomeActiveNotification,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(pausePlayer(_:)),
                                     name: .kShouldPausePlayer,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(willExitPlayer(_:)),
                                     name: NSNotification.Name(rawValue: FWShouldExitPlayer),
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(checkDownloadStatus),
                                     name: .kNotificationDownloadCompleted,
                                     object: nil)
      notificationCenter.addObserver(self,
                                     selector: #selector(checkDownloadStatus),
                                     name: .kNotificationRemovedDownloadItem,
                                     object: nil)
      notificationCenter.addObserver(self, selector: #selector(chromecastRequestDidComplete),
                                     name: .kNotificationChromecastRequestDidComplete,
                                     object: nil)
      notificationCenter.addObserver(self, selector: #selector(chromecastDidStart),
                                     name: .kNotificationChromecastRequestDidStart,
                                     object: nil)
      notificationCenter.addObserver(self, selector: #selector(chromecastDidResume),
                                     name: .kNotificationChromecastRequestDidResume,
                                     object: nil)
      notificationCenter.addObserver(self, selector: #selector(chromecastDidEnd),
                                     name: .kNotificationChromecastRequestDidEnd,
                                     object: nil)
      notificationCenter.addObserver(self, selector: #selector(chromecastDidFailToStart),
                                     name: .kNotificationChromecastRequestDidFailToStart,
                                     object: nil)
      notificationCenter.addObserver(self, selector: #selector(chromecastDidFailToResume),
                                     name: .kNotificationChromecastRequestDidFailToResume,
                                     object: nil)
      
      self.viewModel?.kpiModel = KPIModel()
   }
   
   func viewWillAppear() {
      
   }
   
   func viewWillDisappear() {
      sendWatchTime()
      stopKPITimer()
      stopBandwidthTimer()
   }
   
   //MARK: -- Data manipulation
   func getData(with completion: ((Bool) -> Void)? = nil) {
      trace = Performance.startTrace(name:"ChiTietVideo")
      wireFrame?.doShowProgress()
      isGettingData = true
      stopKPITimer()
      interactor?.getData(videoId: (viewModel?.getVideoId())!,
                          playlistId: viewModel?.playlistModel?.id,
                          acceptLostData: Singleton.sharedInstance.isAcceptLossData,
                          completion: { (result) in
                            self.isGettingData = false
                            switch result {
                            case .success(let response):
                              self.viewModel?.detailModel = response.data
                              // Init KPI (*)
                              
                              //                                    print("Manhhx url link ", self.viewModel?.detailModel?.streams.urlStreaming)
                              
                              self.view?.doReloadTableView()
                              // show confirm popup if stream is not ready to play
                              if response.data.streams.errorCode != APIErrorCode.success {
                                 self.onPlayAttempt()
                                 // reload player
                                 self.view?.doReloadPlayer()
                              } else {
                                 LoggingRecommend.viewVideoDetail(channelId: (self.viewModel?.detailModel?.detail.owner.id)!, channelName: (self.viewModel?.detailModel?.detail.owner.name)!, videoId: (self.viewModel?.detailModel?.detail.id)!, videoName: (self.viewModel?.detailModel?.detail.name)!)
                                 self.initializeKPI()
                                 if self.view?.myPlayer?.isReadyToPlay == true {
                                    // if the video player is playing so that we will not count the buffering time
                                 } else {
                                    // count the buffering time
                                    self.viewModel?.kpiModel?.startBuffering()
                                 }
                                 self.onPlayAttempt()
                                 self.view?.myPlayer?.updatePlaybackControls(self.viewModel?.playerConfig)
                              }
                              
                              // get video comments
                              self.getComments()
                              // get data completed
                              completion?(true)
                            case .failure(let error):
                              self.view?.doReloadTableView(error as NSError)
                              completion?(false)
                            }
                            self.wireFrame?.doHideProgress()
                            self.trace?.stop()
                          })
   }
   
   private func getComments() {
      let pager = Pager(offset: Constants.kFirstOffset, limit: Constants.kDefaultLimit)
      interactor?.getListComment(type: .video, contentId: (viewModel?.getVideoId())!, pager: pager, completion: { (result) in
         switch result {
         case .success(let response):
            self.viewModel?.doUpdateWithListComment(models: response.data)
            (self.view as? VideoDetailViewController)?.reloadSubComment()
            self.view?.doReloadTableView()
         case .failure(let error):
            self.view?.doReloadTableView(error as NSError)
         }
      })
   }
   
   //MARK: -- KPI manipulation
   private func initializeKPI() {
      guard let model = viewModel?.detailModel else {
         return
      }
      service.KpiInit(video: model.detail.id, url: model.streams.urlStreaming) { (result) in
         switch result {
         case .success(let response):
            self.viewModel?.kpiToken = response.data
            if response.data.frequency > 0 {
               self.startKPITimer()
            }
         case .failure(_):
            break
         }
      }
   }
   
   private func startKPITimer() {
      guard let model = viewModel?.kpiToken else {
         return
      }
      weak var wself = self
      if #available(iOS 10.0, *) {
         //            kpiTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1),
         kpiTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(model.frequency),
                                         repeats: true,
                                         block: { (_) in
                                            wself?.sendKPIStatistic()
                                         })
         kpiTimer?.fire()
      } else {
         // Fallback on earlier versions
         kpiTimer = Timer.scheduledTimer(timeInterval: TimeInterval(model.frequency),
                                         target: self,
                                         selector: #selector(sendKPIStatistic),
                                         userInfo: nil, repeats: true)
      }
   }
   
   private func stopKPITimer() {
      kpiTimer?.invalidate()
      kpiTimer = nil
   }
   
   @objc private func sendKPIStatistic() {
      guard let model = viewModel?.kpiModel else {
         return
      }
      if model.isBuffering {
         model.stopBuffering()
         model.startBuffering()
      }
      if model.isPlaying {
         model.stopWatching()
         model.startWatching()
      }
      
      if(bandwidthRangeCount > 0){
         model.bandWidth = bandwidthRange/bandwidthRangeCount/1024
         model.bandWidthAvg = bandwidthTotal/bandwidthTotalCount/1024
      }
      
      if(bandwidthRange > 0){
         bandwidthRange = 0
         bandwidthRangeCount = 0
      }
      
      if model.isChanged { // only send statistic when there is changed
         service.KPITrace(model, completion: { (result) in
            switch result {
            case .success(_):
               DLog("")
            case .failure(let error):
               DLog(error.localizedDescription)
            }
         })
      }
   }
   
   @objc private func checkDownloadStatus() {
      viewModel?.checkDownloadStatus()
      view?.doReloadTableView()
   }
   
   //MARK: -- presenter methods
   func didSelectRow(at indexPath: IndexPath) {
      if indexPath.section == VideoDetailSectionIndex.info.rawValue {
         if indexPath.row == 1 {
            if !Singleton.sharedInstance.isConnectedInternet {
               (view as! UIViewController).showInternetConnectionError()
               return
            }
            let rowModel = viewModel?.sections[indexPath.section].rows[indexPath.row]
            if rowModel?.identifier == ChannelInfoTableViewCell.nibName() {
               self.wireFrame?.doShowChannelDetail(model: (viewModel?.detailModel?.detail.owner)!)
            }
         }
      } else if indexPath.section == VideoDetailSectionIndex.related.rawValue {
         // perform send watch time before move to other item
         sendWatchTime()
         // move to an other content
         let contentModel = viewModel?.detailModel?.relates.videos[indexPath.row]
         viewModel?.resetListPlayedVideos()
         showContentDetails(contentModel, withinPlaylist: false)
      }
   }
   
   func didSelectPlaylistItem(at indexPath: IndexPath) {
      // perform send watch time before move to other item
      sendWatchTime()
      // move to an other content
      let contentModel = viewModel?.detailModel?.playlist.videos[indexPath.row]
      viewModel?.resetListPlayedVideos()
      showContentDetails(contentModel, withinPlaylist: true)
   }
   
   func didSelectExpandButton() {
      viewModel?.isExpandDesc = !(viewModel?.isExpandDesc)!
      viewModel?.detailModel = viewModel?.detailModel
      view?.doReloadTableView()
   }
   
   func didSelectPostComment(comment: String) {
      if DataManager.isLoggedIn() {
         wireFrame?.doShowProgress()
         interactor?.postComment(type: "VOD" , parentId: (viewModel?.currentComment)! , contentID: (viewModel?.getVideoId())!, comment: comment, completion: { (result) in
            switch result {
            case .success:
               self.getComments()
            case .failure(let error):
               (self.view as? BaseViewController)?.handleError(error as NSError, completion: { (result) in
                  if result.isSuccess {
                     self.getData()
                  }
               })
            }
            self.wireFrame?.doHideProgress()
         })
         
         LoggingRecommend.commentVideoAction(videoId: (viewModel?.getVideoId())!, comment: comment)
      } else {
         doLogin(with: { (success) in
            if success {
               self.getData()
            }
         })
      }
   }
   
   func didSelectToggleLikeVideo(videoId: String, isSelectedLike: Bool) {
      guard let model = viewModel?.detailModel else {
         return
      }
      if DataManager.isLoggedIn() {
         var status: LikeStatus = .none
         if isSelectedLike {
            if model.detail.likeStatus == .like {
               status = .none
            } else {
               status = .like
            }
         } else {
            if model.detail.likeStatus == .dislike {
               status = .none
            } else {
               status = .dislike
            }
         }
         interactor?.toggleLikeVideo(videoId: model.detail.id, status: status, completion: { (result) in
            switch result {
            case .success(_):
               if(status != .none){
                  LoggingRecommend.likeVideoAction(videoId: model.detail.id, videoName: model.detail.name, type: isSelectedLike)
               }
               self.viewModel?.doUpdateWithToggleLikeVideo(isSelectLike: isSelectedLike)
               self.view?.doReloadTableView()
               break
            case .failure(let error):
               (self.view as? BaseViewController)?.handleError(error as NSError, completion: { (result) in
                  if result.isSuccess {
                     self.getData()
                  }
               })
            }
         })
      } else {
         doLogin(with: { (success) in
            if success {
               self.getData()
            }
         })
      }
   }
   
   func didSelectToggleLikeComment(at indexPath: IndexPath) {
      if DataManager.isLoggedIn() {
         let comment = viewModel?.sections[indexPath.section].rows[indexPath.row]
         self.viewModel?.doUpdateWithToggleLikeComment(at: indexPath)
         self.view?.doReloadTableView()
         interactor?.toggleLikeComment(type: "VOD", contentID: (viewModel?.getVideoId())!, commentId: (comment?.objectID)!, completion: { (result) in
            switch result {
            case .success(_):
               break
            case .failure(let error):
               (self.view as? BaseViewController)?.handleError(error as NSError, completion: { (result) in
                  if result.isSuccess {
                     self.getData()
                  }
               })
            }
         })
      } else {
         doLogin(with: { (success) in
            if success {
               self.getData()
            }
         })
      }
   }
   func didSelectToggleDisLikeComment(at indexPath: IndexPath) {
      if DataManager.isLoggedIn() {
         let comment = viewModel?.sections[indexPath.section].rows[indexPath.row]
         self.viewModel?.doUpdateWithToggleDisLikeComment(at: indexPath)
         self.view?.doReloadTableView()
         interactor?.toggleDisLikeComment(type: "VOD", contentID: (viewModel?.getVideoId())!, commentId: (comment?.objectID)!, completion: { (result) in
            switch result {
            case .success(_):
               break
            case .failure(let error):
               (self.view as? BaseViewController)?.handleError(error as NSError, completion: { (result) in
                  if result.isSuccess {
                     self.getData()
                  }
               })
            }
         })
      } else {
         doLogin(with: { (success) in
            if success {
               self.getData()
            }
         })
      }
   }
   func didSelectToggleFollowChannel(channelId: String) {
      if DataManager.isLoggedIn() {
         guard let model = viewModel?.detailModel else {
            return
         }
         if (viewModel?.isFollowChannel)! {
            //                let dialog = DialogViewController(title: String.UnFollowChannelTitle,
            //                                                  message: String.init(format: String.UnFollowChannelDesc, model.detail.owner.name),
            //                                                  confirmTitle: String.confirm,
            //                                                  cancelTitle: String.cancel)
            //                dialog.confirmDialog = {(sender) in
            //                    self.toggleFollowChannel()
            //                }
            //                (view as! VideoDetailViewController).presentDialog(dialog, animated: true, completion: nil)
            
            (view as! VideoDetailViewController).showAlert(title: String.UnFollowChannelTitle, message: String.init(format: String.UnFollowChannelDesc, model.detail.owner.name), okTitle: String.confirm, onOk: { (action) in
               self.toggleFollowChannel()
            })
         } else {
            toggleFollowChannel()
         }
         
      } else {
         doLogin(with: { (success) in
            if success {
               self.getData()
            }
         })
      }
   }
   
   func toggleFollowChannel() {
      guard let model = viewModel?.detailModel else {
         return
      }
      var status = 0
      if (viewModel?.isFollowChannel)! {
         status = 0
      } else {
         status = 1
      }
      interactor?.toggleFollowChannel(channelId: model.detail.owner.id,
                                      status: status,
                                      notificationType: 2,
                                      completion: { (result) in
                                        switch result {
                                        case .success(let message):
                                          self.viewModel?.isFollowChannel = !(self.viewModel?.isFollowChannel)!
                                          LoggingRecommend.followChannelAction(channelId: model.detail.owner.id, channelName: model.detail.owner.name, followType: (self.viewModel?.isFollowChannel)!)
                                          
                                          if (self.viewModel?.isFollowChannel)! {
                                             self.viewModel?.followCount += 1
                                             model.detail.owner.isFollow = true
                                             model.detail.owner.num_follow = (self.viewModel?.followCount)!
                                             
                                             self.interactor?.getSuggestionsChannel(
                                                completion: {
                                                   (result) in
                                                   switch result {
                                                   case .success(let response):
                                                      //                                                                print("Manhhx Channel size " , response.data.count)
                                                      if(response.data.count > 0){
                                                         self.viewModel?.isShowSuggestions = true
                                                         self.viewModel?.listSuggestionChannel = response.data
                                                         self.view?.doReloadTableView()
                                                      }
                                                      break
                                                   case .failure( _):
                                                      break;
                                                   }
                                                })
                                             
                                          } else {
                                             self.viewModel?.followCount -= 1
                                             status = 0
                                             model.detail.owner.isFollow = false
                                             model.detail.owner.num_follow = (self.viewModel?.followCount)!
                                          }
                                          self.view?.doReloadTableView()
                                          if let value = message as? String {
                                             self.wireFrame?.doShowToast(message: value)
                                          }
                                          break
                                        case .failure(let error):
                                          (self.view as? BaseViewController)?.handleError(error as NSError, completion: { (result) in
                                             if result.isSuccess {
                                                self.getData()
                                             }
                                          })
                                        }
                                      })
   }
   func didSelectFollowSuggestionChannel(channelId: String, channelName: String) {
      interactor?.toggleFollowChannel(channelId: channelId,
                                      status: 1,
                                      notificationType: 2,
                                      completion: { (result) in
                                        switch result {
                                        case .success(let _):
                                          LoggingRecommend.followChannelAction(channelId: channelId, channelName: channelName, followType: true)
                                          self.interactor?.getSuggestionsChannel(
                                             completion: {
                                                (result) in
                                                switch result {
                                                case .success(let response):
                                                   (self.view as? VideoDetailViewController)?.toast(response.message)
                                                   if(response.data.count > 0){
                                                      self.viewModel?.isShowSuggestions = true
                                                      self.viewModel?.listSuggestionChannel = response.data
                                                      self.view?.doReloadTableView()
                                                      
                                                   }
                                                   break
                                                case .failure( _):
                                                   break;
                                                }
                                             })
                                          break
                                        case .failure(let error):
                                          (self.view as? BaseViewController)?.handleError(error as NSError, completion: { (result) in
                                             if result.isSuccess {
                                                self.getData()
                                             }
                                          })
                                        }
                                      })
   }
   
   func didSelectShare() {
      if let model = viewModel?.detailModel {
         wireFrame?.doShareWithLink(model.detail.linkSocial)
         LoggingRecommend.shareVideoAction(videoId: model.detail.id, videoName: model.detail.name)
      }
   }
   
   func didSelectWatchLater() {
      guard let contentID = viewModel?.detailModel?.detail.id else {
         return
      }
      (view as? BaseViewController)?.addToPlaylist(ContentModel(id: contentID))
   }
   
   func didSelectActionButton(at indexPath: IndexPath) {
      if let model = self.viewModel?.detailModel?.relates.videos[indexPath.row] {
         (view as? BaseViewController)?.showMoreAction(for: model)
      }
   }
   
   func didSelectPlaylistActionButton(at indexPath: IndexPath) {
      if let model = self.viewModel?.detailModel?.playlist.videos[indexPath.row] {
         (view as? BaseViewController)?.showMoreAction(for: model)
      }
   }
   
   func didSelectEditComment(id: String, comment: String) {
      (view as? VideoDetailViewController)?.showActionComment(id, comment: comment)
   }
   
   func doShowSubComment(at indexPath: IndexPath) {
   }
   
   func doDeleteComment(id: String) {
      //        let dialog = DialogViewController(title: "",
      //                                          message: String.ban_co_xoa_binh_luan_nay_khong,
      //                                          confirmTitle: String.okString,
      //                                          cancelTitle: String.refuse)
      //        dialog.confirmDialog = { button in
      //            self.interactor?.deleteComment(commentId: id, completion: { (result) in
      //                switch result {
      //                case .success(let response):
      //                    self.wireFrame?.doShowToast(message: response.message)
      //                    self.getComments()
      //                    break
      //                case .failure(_):
      //                    break
      //                }
      //            })
      //        }
      //        (view as? UIViewController)?.presentDialog(dialog, animated: true, completion: nil)
      
      (view as! UIViewController).showAlert(title: "", message: String.ban_co_xoa_binh_luan_nay_khong, okTitle: String.okString, onOk: { (action) in
         self.interactor?.deleteComment(commentId: id, completion: { (result) in
            switch result {
            case .success(let response):
               self.wireFrame?.doShowToast(message: response.message)
               self.getComments()
               break
            case .failure(_):
               break
            }
         })
      }, cancelTitle: String.refuse)
   }
   
   func doUpdateComment(id: String, comment: String) {
      interactor?.updateComment(commentId: id, comment: comment, completion: { (result) in
         switch result {
         case .success(_):
            self.getComments()
            self.viewModel?.isUpdateComment = false
         case .failure:
            break
         }
      })
   }
   
   func toggleShowPlaylistItems() {
      viewModel?.isExpandPlaylist = !(viewModel?.isExpandPlaylist)!
      view?.doReloadPlaylistView()
   }
   
   func onToggleAutoPlay() {
      _ = DataManager.toggleAutoPlayNextVideo()
      viewModel?.reloadSections()
      view?.doReloadTableView()
   }
   
   //mark: -- player delegate
   func onPlayAttempt() {
      if isGettingData {
         return
      }
      guard let model = viewModel?.detailModel, let viewcontroller = view as? UIViewController else {
         return
      }
      
      if let videodID = self.viewModel?.getVideoId() {
         let isDownloaded = DownloadManager.shared.isDownloaded(video: videodID)
         if isDownloaded {
            self.view?.myPlayer?.play()
            return
         }
      }
      
      let errorCode = model.streams.errorCode
      switch errorCode {
      case .success:
         if URL(string: model.streams.urlStreaming) != nil {
            if GCKCastContext.sharedInstance().castState == .connected {
               if GoogleChromcastHelper.shareInstance.currentCastingVideo() ?? "" == model.detail.id {
                  // playing the same video => don't replay from start
               } else {
                  let time = view?.myPlayer?.currentTime ?? 0.0
                  GoogleChromcastHelper.shareInstance.playVideoWithChromeCast(model, position: time)
               }
               viewModel?.updatePlayerConfigIfNeeded()
               view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
            } else {
               self.view?.myPlayer?.togglePlayPause()
            }
         } else {
            //                wireFrame?.showAlert(view, nil, String.badUrl)
         }
      case .fail: // show popup if have
         if DataManager.isLoggedIn() {
            showConfirmPopUp(model.streams.popup)
         }else{
            let modelPopUp = model.streams.popup
            let alertView = UIAlertController(title: nil, message: "",
                                              preferredStyle: UIAlertController.Style.alert)
            var message = modelPopUp.confirm
            if modelPopUp.acceptLossData {
                message = message.appending("<br><br>\(modelPopUp.confirmAcceptLostData)")
            }
            alertView.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor : UIColor.settitleColor()]), forKey: "attributedMessage")
//            alertView.setValue(modelPopUp.attributedConfirmMessage(message), forKey: "attributedMessage")
            let cancelAction = UIAlertAction(title: String.cancel, style: .cancel) { (_) in
                // do n
            }
            let loginButton = UIAlertAction(title: String.login, style: .default) { _ in
               DataManager.clearLoginSession()
               viewcontroller.performLogin(animated: true) { (result) in
                  if result.isSuccess {
                    self.showContentDetails(self.viewModel?.contentModel,
                                            withinPlaylist: self.viewModel?.changeItemWithinPlaylist ?? false)
                  }
               }
            }
            alertView.addAction(cancelAction)
            alertView.addAction(loginButton)
            let fromViewController = view as! VideoDetailViewController
            fromViewController.present(alertView, animated: true, completion: nil)
         }
      case .requireLogin: // show login
         //            let dialog = DialogViewController(title: String.login,
         //                                              message: model.streams.message,
         //                                              confirmTitle: String.login,
         //                                              cancelTitle: String.cancel)
         //            dialog.confirmDialog = { button in
         //                DataManager.clearLoginSession()
         //                viewcontroller.performLogin(completion: { (result) in
         //                    if result.isSuccess {
         //                        // do reload player & table view
         //                        self.showContentDetails(self.viewModel?.contentModel,
         //                                                withinPlaylist: self.viewModel?.changeItemWithinPlaylist ?? false)
         //                    }
         //                })
         //            }
         //            viewcontroller.presentDialog(dialog, animated: true, completion: nil)
         
         viewcontroller.showAlert(title: String.login, message: model.streams.message, okTitle: String.login, onOk: { (action) in
            DataManager.clearLoginSession()
            viewcontroller.performLogin(completion: { (result) in
               if result.isSuccess {
                  // do reload player & table view
                  self.showContentDetails(self.viewModel?.contentModel,
                                          withinPlaylist: self.viewModel?.changeItemWithinPlaylist ?? false)
               }
            })
         })
      case .refreshToken:
         let service = UserService()
         weak var wself = self
         service.authorize(type: .refreshToken, username: nil, password: nil, captcha: nil, accessToken: nil, completion: { (result) -> (Void) in
            switch result {
            case .success(_):
               wself?.getData()
            case .failure(let error):
               (self.view as! BaseViewController).handleError(error as NSError, completion: { (completionBlock) in
                  if completionBlock.isSuccess {
                     self.getData()
                  } else {
                     self.wireFrame?.doShowToast(message: error.localizedDescription)
                  }
               })
            }
         })
      default:
         break
      }
   }
   
   func onPlayerLevelAvaiable(_ levels: [QualityModel]) {
      let reachability = Reachability()!
      if reachability.isReachableViaWiFi && UserDefaults.standard.bool(forKey: Constants.kDefaultOnlyPlayHD) {
         self.view?.didSelectQuality(levels.last ?? QualityModel.defaultModel())
      }else {
         if let preferQuality = UserDefaults.standard.object(forKey: Constants.kDefaultQuality) as? String {
            for item in levels {
               if item.name == preferQuality {
                  self.view?.didSelectQuality(item)
                  break
               }
            }
         }
      }
   }
   
   func onQualitySettings(for currentPlayer: MyCustomPlayer?) {
      guard let player = currentPlayer else {
         return
      }
      let fromViewController = view as! UIViewController
      let actionsheetController = ActionSheetViewController()
      for item in player.levels {
         if let item = item as? QualityModel {
            let actionData = item.isSelected ? ActionData(title: item.name, image: #imageLiteral(resourceName: "tick")) : ActionData(title: item.name)
            let qualityAction = Action(actionData, style: .default) { (action) in
               self.view?.didSelectQuality(item)
            }
            actionsheetController.addAction(qualityAction)
         }
      }
      fromViewController.present(actionsheetController, animated: true, completion: nil)
   }
   
   func onSpeedSettings() {
      let values: [PlaybackRate] = [PlaybackRate.lowSpeed, PlaybackRate.standardSpeed, PlaybackRate.mediumSpeed, PlaybackRate.highSpeed]
      let fromViewController = view as! UIViewController
      let actionsheetController = ActionSheetViewController()
      for item in values {
         let actionData = viewModel?.playerConfig.playbackRate == item.rawValue ? ActionData(title: item.title(), image: #imageLiteral(resourceName: "tick")) : ActionData(title: item.title())
         let action = Action(actionData, style: .default) { (action) in
            self.viewModel?.playerConfig.playbackRate = item.rawValue
            self.view?.doChangePlaybackRate(item.rawValue)
         }
         actionsheetController.addAction(action)
      }
      fromViewController.present(actionsheetController, animated: true, completion: nil)
   }
   
   func onReportContent() {
      if DataManager.isLoggedIn() {
         performReport()
      } else {
         let fromViewController = view as! UIViewController
         fromViewController.performLogin(completion: { (result) in
            if result.isSuccess {
               self.performReport()
            }
         })
      }
   }
   
   func onDownloadVideo() {
      DLog("onDownloadVideo")
      guard let videoId = viewModel?.getVideoId() else {
         return
      }
      if DownloadManager.shared.isDownloading(video: videoId) {
         // don't do anything when downloading
         //return
         //            let dialogController = DialogViewController(title: String.video_dang_tai_xuong,
         //                                                        message: String.xoa_khoi_danh_sach_video_tai_xuong,
         //                                                        confirmTitle: String.dong_y,
         //                                                        cancelTitle: String.huy)
         //            dialogController.confirmDialog = {(_) in
         //                let downloadingIndex = DownloadManager.shared.indexOf(downloadingVideo: videoId)
         //                DownloadManager.shared.cancelDownload(DownloadManager.shared.downloadingVideos[downloadingIndex!])
         //                NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem, object: nil)
         //
         //                self.viewModel?.checkDownloadStatus()
         //                self.view?.doReloadTableView()
         //            }
         //            (view as? BaseViewController)?.presentDialog(dialogController,
         //                                                         animated: true,
         //                                                         completion: nil)
         
         (view as? BaseViewController)?.showAlert(title: String.video_dang_tai_xuong, message: String.xoa_khoi_danh_sach_video_tai_xuong, okTitle: String.dong_y, onOk: { (action) in
            
            let downloadingIndex = DownloadManager.shared.indexOf(downloadingVideo: videoId)
            DownloadManager.shared.cancelDownload(DownloadManager.shared.downloadingVideos[downloadingIndex!])
            NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem, object: nil)
            
            self.viewModel?.checkDownloadStatus()
            self.view?.doReloadTableView()
         })
      } else if DownloadManager.shared.isDownloaded(video: videoId) {
         //            let dialogController = DialogViewController(title: String.xoa_khoi_danh_sach_video_tai_xuong,
         //                                                        message: String.video_nay_se_khong_co_san_de_xem_ngoai_tuyen,
         //                                                        confirmTitle: String.xoa.uppercased(),
         //                                                        cancelTitle: String.huy.uppercased())
         //            dialogController.confirmDialog = {(_) in
         //                DownloadManager.shared.deleteVideo(videoId)
         //                NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem,
         //                                                object: nil)
         //                self.viewModel?.checkDownloadStatus()
         //                self.view?.doReloadTableView()
         //            }
         //            (view as? BaseViewController)?.presentDialog(dialogController,
         //                                                         animated: true,
         //                                                         completion: nil)
         
         (view as? BaseViewController)?.showAlert(title: String.xoa_khoi_danh_sach_video_tai_xuong, message: String.video_nay_se_khong_co_san_de_xem_ngoai_tuyen, okTitle: String.xoa, onOk: { (action) in
            
            DownloadManager.shared.deleteVideo(videoId)
            NotificationCenter.default.post(name: .kNotificationRemovedDownloadItem,
                                            object: nil)
            self.viewModel?.checkDownloadStatus()
            self.view?.doReloadTableView()
         })
      } else {
         if DataManager.isLoggedIn() {
            videoService.getDownloadLink(videoId) { (result) in
               switch result {
               case .success(let response):
                  if let video = self.viewModel?.detailModel?.detail {
                     if response.data.errorCode == APIErrorCode.success {
                        DownloadManager.shared.downloadVideo(link: response.data.urlStreaming,
                                                             video: video)
                        NotificationCenter.default.post(name: .kNotificationDownloadStarted,
                                                        object: nil)
                        self.viewModel?.checkDownloadStatus()
                        self.view?.doReloadTableView()
                     } else {
                        self.wireFrame?.doShowToast(message: response.data.message)
                     }
                  }
               case .failure(let error):
                  self.wireFrame?.doShowToast(message: error.localizedDescription)
               }
            }
            LoggingRecommend.downloadVideoAction(videoId: (viewModel?.contentModel!.id)!, videoName: (viewModel?.contentModel!.name)!)
         } else {
            doLogin(with: { (success) in
            })
         }
      }
   }
   
   private func performReport() {
      if let settings = DataManager.getCurrentAccountSettingsModel() {
         let fromViewController = view as! UIViewController
         let actionsheetController = ActionSheetViewController()
         for item in settings.feedBacks {
            let action = Action(ActionData(title: item.content), style: .default, handler: { (action) in
               self.sendReport(item)
            })
            actionsheetController.addAction(action)
         }
         fromViewController.present(actionsheetController, animated: true, completion: nil)
      }
   }
   
   private func sendReport(_ model: FeedBackModel) {
      let fromViewController = view as! UIViewController
      service.sendFeedBack(error: model.id, content: model.content, objectId: (viewModel?.getVideoId())!, type: .video) { (result) in
         switch result {
         case .success(let response):
            fromViewController.view.toast(response.data)
         case .failure(let error):
            fromViewController.view.toast(error.localizedDescription)
         }
      }
   }
   
   func onComplete() {
      onNext()
   }
   
   func onCompleCountdown() {
      //reload to get stream URL
      getData()
   }
   
   func onPrevious() {
      if viewModel?.isShowingVideoPlaylist() == true {
         let previousId = viewModel?.previousVideoId() ?? ""
         if !previousId.isEmpty {
            viewModel?.willBackToVideo(previousId)
            showContentDetails(ContentModel(id: previousId), withinPlaylist: true)
         }
      } else {
         let previousId = viewModel?.previousVideoId() ?? ""
         if !previousId.isEmpty {
            VideosWatched.list.removeLast()
            showContentDetails(ContentModel(id: previousId), withinPlaylist: false)
         }
      }
   }
   
   func onNext() {
      if viewModel?.isShowingVideoPlaylist() == true {
         let nextId = viewModel?.nextVideoId() ?? ""
         if !nextId.isEmpty {
            viewModel?.willNextToVideo(nextId)
            showContentDetails(ContentModel(id: nextId), withinPlaylist: true)
         }
      } else {
         let shouldPlayNextVideo = DataManager.isAutoPlayNextVideo()
         let nextId = viewModel?.nextVideoId() ?? ""
         if shouldPlayNextVideo && !nextId.isEmpty {
            showContentDetails(ContentModel(id: nextId), withinPlaylist: false)
         }
      }
      LoggingRecommend.videoPlayNextAction(videoId: (viewModel?.getVideoId())!)
   }
   
   func onPlay() {
      viewModel?.kpiModel?.startWatching()
   }
   
   func onSetupError(_ error: NSError) {
      wireFrame?.doShowToast(message: error.localizedDescription)
   }
   
   func onPause() {
      viewModel?.kpiModel?.pauseTimes += 1
      viewModel?.kpiModel?.stopWatching()
      LoggingRecommend.videoPauseAction(videoId: (viewModel?.getVideoId())!)
   }
   
   func onSeeked() {
      viewModel?.kpiModel?.seekTimes += 1
   }
   
   func onBuffering() {
      viewModel?.kpiModel?.waitTimes += 1
      viewModel?.kpiModel?.startBuffering()
   }
   
   func onFinishBuffering() {
      viewModel?.kpiModel?.stopBuffering()
   }
   
   func onReady(_ setupTime: Int) {
      startBandWidthCount()
   }
   
   func startBandWidthCount(){
      weak var wself = self
      if #available(iOS 10.0, *) {
         bandwidthTimer = Timer.scheduledTimer(withTimeInterval: 1,
                                               repeats: true,
                                               block: { (_) in
                                                wself?.countBandWidth()
                                               })
         bandwidthTimer?.fire()
      } else {
         // Fallback on earlier versions
         bandwidthTimer = Timer.scheduledTimer(timeInterval: 1,
                                               target: self,
                                               selector: #selector(countBandWidth),
                                               userInfo: nil, repeats: true)
      }
   }
   
   @objc func countBandWidth(){
      let accesslog = (self.view as? VideoDetailViewController)?.myPlayer?.getCurPlayerItem().accessLog()
      if(accesslog != nil){
         var events = accesslog?.events
         if(events != nil && (events?.count)! > 0){
            let event = events![(events?.count)! - 1] as AVPlayerItemAccessLogEvent
            if(event.observedBitrate > 0){
               bandwidthRange = bandwidthRange + event.observedBitrate
               bandwidthTotal = bandwidthTotal + event.observedBitrate
               bandwidthRangeCount = bandwidthRangeCount + 1
               bandwidthTotalCount = bandwidthTotalCount + 1
            }
         }
      }
   }
   
   func stopBandwidthTimer(){
      bandwidthTimer?.invalidate()
      bandwidthTimer = nil
   }
   
   //MARK: -- private functions
   private func showConfirmPopUp(_ model: PopupModel) {
      let alertView = UIAlertController(title: nil, message: "",
                                            preferredStyle: UIAlertController.Style.alert)
          var message = model.confirm
          if let user = DataManager.getCurrentMemberModel() {
             message = "\(String.helloStr) \(user.msisdn) \n \(model.confirm)"
          }
          if model.acceptLossData {
              message = message.appending("\n\(model.confirmAcceptLostData)")
          }
            alertView.setValue(NSAttributedString(string: message, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor : UIColor.settitleColor()]), forKey: "attributedMessage")
//          alertView.setValue(model.attributedConfirmMessage(message), forKey: "attributedMessage")
          let cancelAction = UIAlertAction(title: String.Skip, style: .cancel) { (_) in
              // do nothing
          }
          weak var weakSelf = self
          var optionCount = 0
          if model.isRegisterSub {
              let registerPackageAction = UIAlertAction(title: String.registerPackage, style: .default) { (_) in
                if model.exceedMaxFreeWatchingTimes {
                   self.registerPackage()
                }else{
                   weakSelf?.showRegisterPackgerPopup(model)
                }
              }
              alertView.addAction(registerPackageAction)
              optionCount += 1
          }
          if model.isBuyVideo {
              let buyRetailAction = UIAlertAction(title: String.buyRetail, style: .default) { (_) in
                  weakSelf?.showBuyRetailPopup(model)
              }
              alertView.addAction(buyRetailAction)
              optionCount += 1
          }
          if model.acceptLossData {
              let continueWatchAction = UIAlertAction(title: String.continueWatch, style: .default, handler: { (_) in
                  Singleton.sharedInstance.isAcceptLossData = true
                  weakSelf?.getData()
              })
              alertView.addAction(continueWatchAction)
              optionCount += 1
          }
          if optionCount == 0 {
              return
          }
          alertView.addAction(cancelAction)
          
          if(model.isRegisterFast == 1){
              weak var weakSelf = self
              let fromViewController = view as! VideoDetailViewController
              fromViewController.logEventInAppPurchase(packageId:model.packageId)
              fromViewController.present(alertView, animated: true, completion: nil)
              
          }else{
              let fromViewController = view as! VideoDetailViewController
              fromViewController.present(alertView, animated: true, completion: nil)
          }
   }
   func registerPackage(){
      if DataManager.isLoggedIn() {
         let fromViewController = view as! VideoDetailViewController
          fromViewController.showPackage()
      }else{
         guard let model = viewModel?.detailModel, let viewcontroller = view as? UIViewController else {
             return
         }
         DataManager.clearLoginSession()
         viewcontroller.performLogin(completion: { (result) in
             if result.isSuccess {
                 // do reload player & table view
                 self.showContentDetails(self.viewModel?.contentModel,
                                         withinPlaylist: self.viewModel?.changeItemWithinPlaylist ?? false)
             }
         })
      }
   }
   private func showPopUpRegisterPackage(_ model: PopupModel){
      if DataManager.isLoggedIn() {
         let fromViewController = view as! VideoDetailViewController
         fromViewController.showPackage()
      }else{
         let fromViewController = view as! VideoDetailViewController
         fromViewController.performLogin(completion: { (result) in
            if result.isSuccess {
               let fromViewController = fromViewController
               fromViewController.showPackage()
            }
         })
      }
   }
   private func showRegisterPackgerPopup(_ model: PopupModel) {
      if(model.isConfirmSms == "1"){
         weak var weakSelf = self
         weakSelf?.interactor?.registPackage(model.packageId, contentId:model.contentId, completion: { (result) in
            weakSelf?.didRegistPackage(result)
         })
         let fromViewController = view as! VideoDetailViewController
         fromViewController.logEventInAppPurchase(packageId:model.packageId)
      }else{
         let fromViewController = view as! VideoDetailViewController
         let alertView = UIAlertController(title: nil, message: "",
                                           preferredStyle: UIAlertController.Style.alert)
         alertView.setValue(model.attributedConfirmMessage(model.confirmRegisterSub), forKey: "attributedMessage")
         let cancelAction = UIAlertAction(title: String.Skip, style: .cancel) { (_) in
            // do nothing
         }
         weak var weakSelf = self
         let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
            weakSelf?.interactor?.registPackage(model.packageId, contentId:model.contentId, completion: { (result) in
               weakSelf?.didRegistPackage(result)
            })
            fromViewController.logEventInAppPurchase(packageId:model.packageId)
         }
         alertView.addAction(cancelAction)
         alertView.addAction(okAction)
         fromViewController.present(alertView, animated: true, completion: nil)
      }
      
      
      //      let packageVC = ServicePackageViewController.initWithNib()
      //      fromViewController.navigationController?.pushViewController(packageVC, animated: true)
      
   }
   
   private func showBuyRetailPopup(_ model: PopupModel) {
      guard let detailModel = viewModel?.detailModel else {
         return
      }
      let fromViewController = view as! VideoDetailViewController
      let alertView = UIAlertController(title: nil, message: "",
                                        preferredStyle: UIAlertController.Style.alert)
      alertView.setValue(model.attributedConfirmMessage(model.confirmBuyVideo), forKey: "attributedMessage")
      let cancelAction = UIAlertAction(title: String.Skip, style: .cancel) { (_) in
         // do nothing
      }
      weak var weakSelf = self
      let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
         weakSelf?.interactor?.buyRetail(detailModel.detail.id, type: ContentType.video, completion: { (result) in
            weakSelf?.didRegistPackage(result)
         })
      }
      alertView.addAction(cancelAction)
      alertView.addAction(okAction)
      fromViewController.present(alertView, animated: true, completion: nil)
   }
   
   private func showAcceptLostDataPopup(_ model: PopupModel) {
      let fromViewController = view as! VideoDetailViewController
      let alertView = UIAlertController(title: nil, message: "",
                                        preferredStyle: UIAlertController.Style.alert)
      alertView.setValue(model.attributedConfirmMessage(model.confirmAcceptLostData), forKey: "attributedMessage")
      let cancelAction = UIAlertAction(title: String.Skip, style: .cancel) { (_) in
         // do nothing
      }
      weak var weakSelf = self
      let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
         Singleton.sharedInstance.isAcceptLossData = true
         weakSelf?.getData()
      }
      alertView.addAction(cancelAction)
      alertView.addAction(okAction)
      fromViewController.present(alertView, animated: true, completion: nil)
   }
   
   @objc func appMovedToBackground(_ notify: Notification) {
      sendWatchTime()
      if view?.myPlayer?.isReadyToPlay == true {
         view?.myPlayer?.pause()
      }
   }
   
   @objc func appMovedToForeground(_ notify: Notification) {
      if view?.myPlayer?.isReadyToPlay == true {
         view?.myPlayer?.play()
      }
      // re-calculate Show times because: NSTimer is not running when app is move to background
      viewModel?.updateShowTime()
      if viewModel?.playerConfig.shouldShowCountdown == true {
         view?.doReloadPlayer()
      }
   }
   
   func sendWatchTime() {
      guard let model = viewModel?.detailModel else {
         return
      }
      // print("Manhhx watched time " , view?.myPlayer?.currentTime)
      guard let _ = view?.myPlayer else {
         return
      }
      
      var time = 0.0
      if view?.myPlayer?.playerState != PLAYER_STATE_FINISHED {
         time = view?.myPlayer?.currentTime ?? 0.0
      }
      videoService.sendWatchTime(id: model.detail.id, time: time, type: .video) { (result) in
      }
   }
   
   @objc func pausePlayer(_ notify: Notification) {
      if view?.myPlayer?.isReadyToPlay == true {
         view?.myPlayer?.pause()
      }
   }
   
   @objc func willExitPlayer(_ notify: Notification) {
      sendWatchTime()
   }
   
   func didSelectRetryButton() {
      getData()
   }
   
   func didSelectRelatedVideo(at index: Int) {
      self.didSelectRow(at: IndexPath(item: index, section: VideoDetailSectionIndex.related.rawValue))
   }
   
   internal func doLogin(with completion: @escaping (Bool) -> Void ) {
      (view as? UIViewController)?.performLogin(completion: { (result) in
         if result.isSuccess {
            completion(true)
         } else {
            completion(false)
         }
      })
   }
   
   func onChangePlayingStrategy() {
      viewModel?.updatePlayerConfigIfNeeded()
      view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
   }
   
   @objc func chromecastRequestDidComplete() {
      viewModel?.updatePlayerConfigIfNeeded()
      view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
   }
   
   @objc func chromecastDidStart() {
      guard let model = viewModel?.detailModel else {
         return
      }
      let errorCode = model.streams.errorCode
      if errorCode == .success &&
            URL(string: model.streams.urlStreaming) != nil &&
            GCKCastContext.sharedInstance().castState == .connected {
         
         if GoogleChromcastHelper.shareInstance.currentCastingVideo() ?? "" == model.detail.id {
            // playing the same video => don't replay from start
         } else {
            let time = view?.myPlayer?.currentTime ?? 0.0
            GoogleChromcastHelper.shareInstance.playVideoWithChromeCast(model, position: time)
         }
         view?.myPlayer?.pause()
         viewModel?.updatePlayerConfigIfNeeded()
         view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
      }
   }
   
   @objc func chromecastDidResume() {
      viewModel?.updatePlayerConfigIfNeeded()
      view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
   }
   
   @objc func chromecastDidEnd() {
      viewModel?.updatePlayerConfigIfNeeded()
      view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
   }
   
   @objc func chromecastDidFailToStart() {
      viewModel?.updatePlayerConfigIfNeeded()
      view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
   }
   
   @objc func chromecastDidFailToResume() {
      viewModel?.updatePlayerConfigIfNeeded()
      view?.myPlayer?.updatePlaybackControls(viewModel?.playerConfig)
   }
}

// MARK:
// MARK: INTERACTOR
extension VideoDetailPresenter: VideoDetailInteractorOutput {
   func didRegistPackage(_ result: Result<APIResponse<String>>) {
      switch result {
      case .success(let response):
         if(response.isConfirmSms == "1"){
            let fromViewController = view as! VideoDetailViewController
            let title: String
            let confirmTitle: String
            
            title = String.register
            confirmTitle = String.okString.uppercased()
            //                let dialog = DialogViewController(title: title,
            //                                                  message: response.data,
            //                                                  confirmTitle: confirmTitle,
            //                                                  cancelTitle: String.cancelPackage,
            //                                                  isHtmlMessage: true)
            //
            //                dialog.confirmDialog = {(sender) in
            //                    if MFMessageComposeViewController.canSendText() == true {
            //                        let recipients:[String] = [response.number]
            //                        let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90(),
            //                                         NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
            //                        UINavigationBar.appearance().titleTextAttributes = titleDict
            //                        let messageController = MFMessageComposeViewController()
            //                        messageController.messageComposeDelegate  = self
            //                        messageController.recipients = recipients
            //                        messageController.body = response.content
            //                        fromViewController.present(messageController, animated: true, completion: nil)
            //                    } else {
            //                        //handle text messaging not available
            //                        fromViewController.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
            //                    }
            //                }
            //                fromViewController.presentDialog(dialog, animated: true, completion: nil)
            
            fromViewController.showAlert(title: title, message: response.data, okTitle: confirmTitle, onOk: { (action) in
               
               if MFMessageComposeViewController.canSendText() == true {
                  let recipients:[String] = [response.number]
                  let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90(),
                                   NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
                  UINavigationBar.appearance().titleTextAttributes = titleDict
                  let messageController = MFMessageComposeViewController()
                  messageController.messageComposeDelegate  = self
                  messageController.recipients = recipients
                  messageController.body = response.content
                  fromViewController.present(messageController, animated: true, completion: nil)
               } else {
                  //handle text messaging not available
                  fromViewController.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
               }
            }, cancelTitle: String.cancelPackage)
         }else{
            getData()
         }
      case .failure(let error):
         (view as? UIViewController)?.handleError(error as NSError, completion: { (result) in
            if result.isSuccess {
               self.getData()
            }
         })
      }
   }
}

// MARK: 
// MARK: WIRE FRAME
extension VideoDetailPresenter: VideoDetailWireFrameOutput {
   
}
