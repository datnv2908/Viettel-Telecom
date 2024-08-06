//
//  WatchRecentlyViewController.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PlaylistDetailsViewController: BaseSimpleTableViewController<ContentModel> {
    let service = VideoServices()
    var playlist: PlaylistModel
    var channel: ChannelModel
    var publicPlaylist: Bool = true
    init(playlist model: PlaylistModel, channel channelModel: ChannelModel) {
        playlist = model
        channel = channelModel
        super.init(nibName: "PlaylistDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let model = DataManager.getCurrentMemberModel() {
            if model.userId == channel.id {
                publicPlaylist = false
            } else {
                publicPlaylist = true
            }
        } else {
            publicPlaylist = true
        }
    }
    
    override func setupView() {
        super.setupView()
        setUpNavigationItem()
        tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0)
        tableView?.estimatedSectionHeaderHeight = 138
        tableView?.sectionHeaderHeight = UITableView.automaticDimension
        tableView?.register(UINib(nibName: PlaylistHeaderView.nibName(), bundle: nil),
                            forHeaderFooterViewReuseIdentifier: PlaylistHeaderView.nibName())
        refreshData()
    }
    
    func setUpNavigationItem() {
        navigationItem.title = String.danh_sach_phat
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        let category = "\(MoreContentType.playlist.rawValue)\(playlist.id)"
        service.getMoreContents(for: category, pager: pager) { (result) in
            switch result {
            case .success(_):
                completion(result)
                if self.playlist.numberVideo < self.data.count {
                    self.playlist.numberVideo = self.data.count
                }
                LoggingRecommend.viewPlaylistDetail(playlistId: self.playlist.id, playlistName: self.playlist.name, noVideos: self.playlist.numberVideo)
            case .failure(let error):
                self.handleError(error as NSError, completion: { (handleResult) in
                    if handleResult.isSuccess {
                        self.getData(pager: pager, completion)
                    } else {
                        completion(result)
                    }
                })
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
    
    deinit {
        service.cancelAllRequests()
    }
    
    func deleteItem(id: String, at indexPath: IndexPath) {
        self.service.toggleVideoToPlaylist(playlistId: playlist.id, videoId: id, status: 0) { (result) in
            switch result {
            case .success(let response):
                self.toast(response.data)
                self.viewModel.data.remove(at: indexPath.row)
                self.data.remove(at: indexPath.row)
                self.playlist.numberVideo -= 1
                self.reloadData()
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
        }
        
        LoggingRecommend.removeVideoFromPlaylist(channelId: channel.id, channelName: channel.name, videoId: id, playlistId: playlist.id)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PlaylistHeaderView.dequeueReuseHeaderWithNib(in: tableView,
                                                                reuseIdentifier: PlaylistHeaderView.nibName())
        view.delegate = self
        view.titleLabel?.text = playlist.name
        view.ownerNameLabel.text = channel.name
        view.editButton.isHidden = publicPlaylist
        view.removeButton.isHidden = publicPlaylist
        view.videoCountLabel.text = String.init(format: "%d %@", playlist.numberVideo, playlist.numberVideo > 1 ? String.videos : String.video)
        return view
    }
    
    override func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let path = tableView?.indexPath(for: cell) {
            let model = self.data[path.row]
            let actionsheetController = ActionSheetViewController()
            actionsheetController.addSection(Section())
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
//            actionsheetController.addAction(watchLaterAction)
            
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
            
            let deleteAction = Action(ActionData(title: String.xoa_khoi_danh_sach, image: #imageLiteral(resourceName: "iconRemoveGray")),
                                      style: .default) { (action) in
                                        self.deleteItem(id: model.id, at: path)
            }
            
            actionsheetController.addAction(shareAction)
            if self.publicPlaylist {
                actionsheetController.addAction(addToPlaylistAction)
            } else {
                actionsheetController.addAction(deleteAction)
            }
            present(actionsheetController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        let model = self.data[indexPath.row]
        _ = DataManager.toggleSufferingPlaylist(false)
        showVideoPlaylistDetails(model, from: playlist)
    }

    func editPlaylist(_ model: PlaylistModel) {
        let viewcontroller = UpdatePlaylistViewController(model)
        viewcontroller.delegate = self
        navigationController?.pushViewController(viewcontroller, animated: true)
    }

    func deletePlaylist(_ model: PlaylistModel) {
        let service = UserService()
        service.removePlaylist(id: model.id, completion: { (result) in
            switch result {
            case .success(let response):
                self.navigationController?.toast(response.data)
                _ = self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.handleError(error as NSError, completion: { (result) in
                    if result.isSuccess {
                        self.deletePlaylist(model)
                    }
                })
            }
        })
        
        LoggingRecommend.deletePlaylistAction(playlistId: model.id, playlistName: model.name)
    }
}

extension PlaylistDetailsViewController: PlaylistHeaderViewDelegate {
    func onSuffer(_ view: PlaylistHeaderView) {
        if data.isEmpty {
            return
        }
        _ = DataManager.toggleSufferingPlaylist(true)
        let index = (0...data.count - 1).random
        showVideoPlaylistDetails(data[index], from: playlist)
    }

    func onEdit(_ view: PlaylistHeaderView) {
        editPlaylist(playlist)
    }

    func onRemove(_ view: PlaylistHeaderView) {
//        let dialog = DialogViewController(title: String.removePlaylist,
//                                          message: String.confirmRemovePlaylist,
//                                          confirmTitle: String.okString,
//                                          cancelTitle: String.cancel)
//        dialog.confirmDialog = { button in
//            self.deletePlaylist(self.playlist)
//        }
//        self.presentDialog(dialog, animated: true, completion: nil)
        
        self.showAlert(title: String.removePlaylist, message: String.confirmRemovePlaylist, okTitle: String.okString, onOk: { _ in
            self.deletePlaylist(self.playlist)
        })
    }

    func onPlayAll(_ view: PlaylistHeaderView) {
        if data.isEmpty {
            return
        }
        _ = DataManager.toggleSufferingPlaylist(false)
        showVideoPlaylistDetails(nil, from: playlist)
    }
}

extension PlaylistDetailsViewController: UpdatePlaylistViewControllerDelegate {
    func didUpdate(_ model: PlaylistModel) {
        playlist = model
        reloadData()
    }
}
