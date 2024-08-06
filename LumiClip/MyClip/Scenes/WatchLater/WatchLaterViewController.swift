//
//  WatchLaterViewController.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FirebasePerformance

class WatchLaterViewController: BaseSimpleTableViewController<ContentModel> {
    let service = VideoServices()
    var trace: Trace?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trace = Performance.startTrace(name:"Xemsau")
    }

    override func setupView() {
        super.setupView()
        self.navigationItem.title = String.xem_sau
        tableView?.register(UINib(nibName: VideoSmallImageTableViewCell.nibName(), bundle: nil),
                            forCellReuseIdentifier: VideoSmallImageTableViewCell.nibName())
        tableView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        refreshData()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        service.getMoreContents(for: MoreContentType.later.rawValue, pager: pager) { (result) in
            switch result {
            case .success(_):
                completion(result)
                LoggingRecommend.viewWatchLater(noVideos: self.data.count)
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
    
    deinit {
        service.cancelAllRequests()
    }
    
    func deleteItem(id: String, at indexPath: IndexPath) {
        self.service.toggleWatchLater(id: id, status: 0, completion: { (result) in
            switch result {
            case .success(let response):
                self.toast(response.data)
                self.viewModel.data.remove(at: indexPath.row)
                self.data.remove(at: indexPath.row)
                self.reloadData()
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
        })
    }
    
    override func addToPlaylist(_ model: ContentModel) {
        videoService.getAllPlaylist { (result) -> (Void) in
            switch result {
            case .success(let response):
                
                let actionsheetController = ActionSheetViewController()
                let addPlaylistAction = Action(ActionData(title: String.tao_danh_sach_phat_moi, image: #imageLiteral(resourceName: "iconAddToPlaylist")),
                                               style: .default) { (action) in
                                                self.addNewPlaylist()
                }
                actionsheetController.addAction(addPlaylistAction)
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
                self.toast(error.localizedDescription)
            }
        }
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
