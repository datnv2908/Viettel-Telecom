//
//  NotificationViewController.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit
import FirebasePerformance

class NotificationViewController: BaseSimpleTableViewController<NotificationModel> {
    let service = AppService()
     var trace: Trace?
   var commentService = CommentServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       super.tableView.register(UINib(nibName: "NotifiCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "NotifiCommentTableViewCell")
        logScreen(GoogleAnalyticKeys.notifications.rawValue)
        trace = Performance.startTrace(name:"Danhsachthongbao")
    }
    
    override func setupView() {
        super.setupView()
        self.navigationItem.title = String.notification
        self.currentOffset = 0
        self.currentLimit = 0
        refreshData()
        
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: Constants.kLoginStatus,
                                          options: [.initial, .new, .old],
                                          context: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectInternet),
                                               name: .kConnectInternet,
                                               object: nil)
    }

    @objc func reconnectInternet() {
        if self.data.isEmpty {
            refreshData()
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.kLoginStatus {
            refreshData()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[NotificationModel]>>) -> Void) {
        if !DataManager.isLoggedIn() {
            return
        }
        service.cancelAllRequests()
//        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
        service.getNotifications { (result) in
            switch result {
            case .success(_):
                completion(result)
                NotificationCenter.default.post(name: .kShouldGetNotification, object: nil)
            case .failure(let error):
                self.handleError(error as NSError, automaticShowError: false, completion: { (handleResult) in
                    if handleResult.isSuccess {
                        self.getData(pager: pager, completion)
                    } else {
                        completion(result)
                    }
                })
            }
            self.trace?.stop()
        }
//      dispatchGroup.leave()
//      dispatchGroup.enter()
//      self.getDataNotifiComment()
//      self.hideHude()
//      dispatchGroup.leave()
      
    }
   //MARK: - Get Data TableView
   func getDataNotifiComment(videoID :String , comnentID : String, completion: @escaping ([CommentModelDisplay]?) -> Void) {
      self.showHud()
      commentService.getCommentForNotify(status: CommentStatus.waitApprove.getId(), idVideo: videoID, idComment: comnentID) { resurt in
         switch  resurt {
         case .success( let respond) :
            completion(respond.data)
            self.hideHude()
         case.failure(let err ) :
            completion(nil)
            self.hideHude()
            self.toast(err.localizedDescription)
         }
      }
   }
   
    
    override func convertToRowModel(_ item: NotificationModel) -> PBaseRowModel? {
        return NotificationRowModel(item)
    }
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = super.tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as? NotificationTableViewCell
      if let cell = cell as? NotificationTableViewCell {
         cell.delegate = self
         cell.bindingWithModel(self.viewModel.data[indexPath.row])
      }
      
      return cell ?? UITableViewCell()
   }
   
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableView.automaticDimension
   }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if !Singleton.sharedInstance.isConnectedInternet {
         showInternetConnectionError()
         return
      }
      if let model = self.viewModel.data[indexPath.row] as? NotificationRowModel{
         self.getDataNotifiComment(videoID: model.idVideo, comnentID: model.idComment) { model in
            if let model = model{
               if model.count > 0 {
                  let viewControler = ManagerCommentConfigurator.managerCotroller(listVideoComment: model, curentStatus: .waitApprove, fromNoti: true)
                  viewControler.transportData = {
                        self.refreshData()
                  }
                  viewControler.modalPresentationStyle = .fullScreen
                  self.present(viewControler, animated: true, completion: nil)
               }
            }
         }
              
         
      }
    }
    
    private func markNotificationAsReadIfNeeded(at indexPath: IndexPath) {
        let model = self.data[indexPath.row]
        if model.isRead {
            return
        } else {
            service.markNotificationAsRead(model.recordId, completion: { (result) in
                self.data[indexPath.row].isRead = true
                if var rowModel = self.viewModel.data[indexPath.row] as? NotificationRowModel {
                    rowModel.isRead = true
                    self.viewModel.data[indexPath.row] = rowModel
                    self.tableView?.reloadRows(at: [indexPath], with: .automatic)
                }
                NotificationCenter.default.post(name: .kShouldGetNotification, object: nil)
            })
        }
    }

    internal func updateNotificationStatus(at indexPath: IndexPath) {
        let model = self.data[indexPath.row]
        showHud()
        videoService.toggleFollowChannel(channelId: model.channelId, status: 1, notificationType: 0) { (result) in
            switch result {
            case .success(let message):
                self.toast(message as? String ?? "")
            case .failure(let error):
                weak var wself = self
                self.handleError(error as NSError, completion: { (result) in
                    if result.isSuccess {
                        wself?.updateNotificationStatus(at: indexPath)
                    }
                })
            }
            self.hideHude()
        }
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: Constants.kLoginStatus)
        service.cancelAllRequests()
    }
}

extension NotificationViewController: NotificationTableViewCellDelegate {
    func notificationTableViewCell(_ cell: NotificationTableViewCell, didSelectEditButton sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: cell) {
            let actionController = ActionSheetViewController()
            actionController.addSection(Section())
            weak var wself = self
            let model = self.data[indexPath.row]
            actionController.addAction(Action(ActionData(title: String.tat_thong_bao_kenh_nay,
                                                         image: UIImage()),
                                              style: .default,
                                              handler: { _ in
//                                                let dialog = DialogViewController(title: String.tat_thong_bao,
//                                                                                  message: String.ban_co_muon_tat_thong_bao_kenh_nay_khong,
//                                                                                  confirmTitle: String.okString,
//                                                                                  cancelTitle: String.cancel)
//                                                dialog.confirmDialog = { button in
//                                                    wself?.updateNotificationStatus(at: indexPath)
//                                                }
//                                                self.presentDialog(dialog, animated: true, completion: nil)
                                                
                                                self.showAlert(title: String.tat_thong_bao, message: String.ban_co_muon_tat_thong_bao_kenh_nay_khong, okTitle: String.okString, onOk: { [weak self] _ in
                                                    self?.updateNotificationStatus(at: indexPath)
                                                })
            }))
            present(actionController, animated: true, completion: nil)
        }
    }
}
