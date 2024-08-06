//
//  WatchRecentlyViewController.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FirebasePerformance

class WatchRecentlyViewController: BaseSimpleTableViewController<ContentModel> {
    let service = VideoServices()
    var trace: Trace?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         trace = Performance.startTrace(name:"Xemganday")
    }

    override func setupView() {
        super.setupView()
        setUpNavigationItem()
        tableView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        refreshData()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = String.xem_gan_day
    }
        
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        service.getMoreContents(for: MoreContentType.history.rawValue, pager: pager) { (result) in
            switch result {
            case .success(_):
                completion(result)
            case .failure(let error):
                self.handleError(error as NSError, completion: { (handleResult) in
                    if handleResult.isSuccess {
                        self.getData(pager: pager, completion)
                    } else {
                        completion(result)
                    }
                })
            }
            
            self.trace?.stop()

            if self.data.count > 0 {
                // delete button
                LoggingRecommend.viewHistory(noVideos: self.data.count)
                
                let deleteButton = UIButton(type: .custom)
                deleteButton.setImage(#imageLiteral(resourceName: "iconRemoveDark").withRenderingMode(.alwaysTemplate), for: .normal)
                deleteButton.frame = CGRect(x: 7, y: 6, width: 34, height: 28)
                deleteButton.addTarget(self, action: #selector(self.onClickDeleteButton), for: .allTouchEvents)
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteButton)
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    override func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        return VideoRowModel(video: item, identifier: VideoSmallImageTableViewCell.nibName())
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let cell = cell as? VideoSmallImageTableViewCell {
            cell.delegate = self
        }
        
        return cell
    }
    
    @objc func onClickDeleteButton(){
//        let dialog = DialogViewController(title: String.xoa_xem_gan_day,
//                                          message: String.confirmClearHistory,
//                                          confirmTitle: String.dong_y,
//                                          cancelTitle: String.cancelPackage)
//        dialog.confirmDialog = {(sender) in
//            var ids = ""
//
//            for item in self.data {
//                if item == self.data[0] {
//                    ids = item.id
//                } else {
//                    ids += "," + item.id
//                }
//            }
//            self.service.clearVideoHistory(ids: ids, completion: { (result) in
//                switch result {
//                case .success(let message):
//                    if let value = message as? String {
//                        self.toast(value)
//                    }
//                    self.viewModel.data.removeAll()
//                    self.data.removeAll()
//                    self.reloadData()
//                    self.navigationItem.rightBarButtonItem = nil
//                case .failure(let error):
//                    self.toast(error.localizedDescription)
//                }
//            })
//        }
//        presentDialog(dialog, animated: true, completion: nil)
        
        self.showAlert(title: String.xoa_xem_gan_day, message: String.confirmClearHistory, okTitle: String.dong_y, onOk: { _ in
            var ids = ""
            
            for item in self.data {
                if item == self.data[0] {
                    ids = item.id
                } else {
                    ids += "," + item.id
                }
            }
            self.service.clearVideoHistory(ids: ids, completion: { (result) in
                switch result {
                case .success(let message):
                    if let value = message as? String {
                        self.toast(value)
                    }
                    self.viewModel.data.removeAll()
                    self.data.removeAll()
                    self.reloadData()
                    self.navigationItem.rightBarButtonItem = nil
                case .failure(let error):
                    self.toast(error.localizedDescription)
                }
            })
        }, cancelTitle: String.cancelPackage)
    }
    
    deinit {
        service.cancelAllRequests()
    }

    func deleteItem(id: String, at indexPath: IndexPath) {
        self.service.clearVideoHistory(ids: id, completion: { (result) in
            switch result {
            case .success(let message):
                if let value = message as? String {
                    self.toast(value)
                }
                self.viewModel.data.remove(at: indexPath.row)
                self.data.remove(at: indexPath.row)
                self.reloadData()
                if self.viewModel.data.count == 0 {
                    self.navigationItem.rightBarButtonItem = nil
                }
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            
        })
    }
    
    override func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let path = tableView?.indexPath(for: cell) {
            let model = self.data[path.row]
            let actionsheetController = ActionSheetViewController()
            actionsheetController.addSection(Section())
            let addToPlaylistAction = Action(ActionData(title: String.them_vao_danh_sach_phat, image: #imageLiteral(resourceName: "iconAddToPlaylist")),
                                             style: .default) { (action) in
                                                self.addToPlaylist(model)
            }
            let shareAction = Action(ActionData(title: String.chia_se, image: #imageLiteral(resourceName: "iconShare")),
                                     style: .default) { (action) in
                                        self.share(model)
            }
            let deleteAction = Action(ActionData(title: String.xoa_khoi_danh_sach, image: #imageLiteral(resourceName: "iconRemoveGray")),
                                      style: .default) { (action) in
                                        self.deleteItem(id: model.id, at: path)
            }
            
            actionsheetController.addAction(addToPlaylistAction)
            
//            if DownloadManager.shared.isDownloaded(video: model.id) {
//                let downloadAction = Action(ActionData(title: String.xoa_noi_dung_khoi_thu_muc_tai_xuong, image: #imageLiteral(resourceName: "iconRemoveGray")),
//                                            style: .default) { (action) in
//                                                self.downloadVideo(model)
//                }
//                actionsheetController.addAction(downloadAction)
//            } else {
//                let downloadAction = Action(ActionData(title: String.tai_xuong, image: #imageLiteral(resourceName: "iconDownload")),
//                                            style: .default) { (action) in
//                                                self.downloadVideo(model)
//                }
//                actionsheetController.addAction(downloadAction)
//            }
            
            actionsheetController.addAction(shareAction)
            actionsheetController.addAction(deleteAction)
            present(actionsheetController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.data[indexPath.row]
        showVideoDetails(model)
    }
}

