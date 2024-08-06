//
//  PlaylistViewController.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FirebasePerformance

class PlaylistViewController: BaseSimpleTableViewController<PlaylistModel> {
    let service = UserService()
    weak var parentVC: ChannelDetailsViewController?
    var trace: Trace?
    override func viewDidLoad() {
        super.viewDidLoad()
        trace = Performance.startTrace(name:"Danhsachphat")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func setupView() {
        super.setupView()
        self.navigationItem.title = String.danh_sach_phat
        let addBtn = UIButton(type: .custom)
        addBtn.setImage(#imageLiteral(resourceName: "iconPlusGray").withRenderingMode(.alwaysTemplate), for: .normal)
        addBtn.addTarget(self, action: #selector(onClickAddBtn), for: .touchUpInside)
        addBtn.frame = CGRect(x: 7, y: 6, width: 34, height: 28)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
        tableView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        self.currentOffset = 0
        self.currentLimit = 0
    }
    
    @objc func onClickAddBtn() {
        super.addNewPlaylist()        
    }
    
    override func getData(pager: Pager,
                          _ completion: @escaping (Result<APIResponse<[PlaylistModel]>>) -> Void) {
        service.getAllPlaylist(completion: { result in
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
        })
    }
    
    override func convertToRowModel(_ item: PlaylistModel) -> PBaseRowModel? {
        return PlaylistRowModel(item)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cell = cell as? PlaylistTableViewCell {
            cell.delegate = self
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.data[indexPath.row]
        if let user = DataManager.getCurrentMemberModel() {
            let channelModel = ChannelModel(id: user.userId, name: user.getName(), desc: "",numFollow: 0,numVideo: 0, viewCount: 0)
            let viewcontroller = PlaylistDetailsViewController(playlist: model, channel: channelModel)
            navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    func editPlaylist(_ model: PlaylistModel) {
        let viewcontroller = UpdatePlaylistViewController(model)
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func deletePlaylist(_ model: PlaylistModel, at indexPath: IndexPath) {
        self.service.removePlaylist(id: model.id, completion: { (result) in
            switch result {
            case .success(let response):
                self.toast(response.data)
                self.data.remove(at: indexPath.row)
                self.viewModel.data.remove(at: indexPath.row)
                self.tableView?.reloadData()
            case .failure(let error):
                self.handleError(error as NSError, completion: { (result) in
                    if result.isSuccess {
                        self.deletePlaylist(model, at: indexPath)
                    }
                })
            }
        })
        LoggingRecommend.deletePlaylistAction(playlistId: model.id, playlistName: model.name)
    }
    
    deinit {
        service.cancelAllRequests()
    }
}

extension PlaylistViewController : PlaylistTableViewCellDelegate {
    func playlistTableViewCell(_ cell: PlaylistTableViewCell, didTapOnEdit sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: cell) {
            let actionController = ActionSheetViewController()
            actionController.addAction(Action(ActionData(title: String.xoa, image: #imageLiteral(resourceName: "iconRemoveGray")),
                                              style: .default,
                                              handler: { (action) in
                                                //confirm remove
//                                                let dialog = DialogViewController(title: String.removePlaylist,
//                                                                                  message: String.confirmRemovePlaylist,
//                                                                                  confirmTitle: String.okString,
//                                                                                  cancelTitle: String.cancel)
//                                                dialog.confirmDialog = { button in
//                                                    self.deletePlaylist(self.data[indexPath.row], at: indexPath)
//                                                }
//                                                self.presentDialog(dialog, animated: true, completion: nil)
                                                
                                                self.showAlert(title: String.removePlaylist, message: String.confirmRemovePlaylist, okTitle: String.okString, onOk: { _ in
                                                    self.deletePlaylist(self.data[indexPath.row], at: indexPath)
                                                })
                
            }))
            
            actionController.addAction(Action(ActionData(title: String.chinh_sua,
                                                         image: #imageLiteral(resourceName: "iconPencil")), style: .default, handler: { (action) in
                                                            self.editPlaylist(self.data[indexPath.row])
            }))
            present(actionController, animated: true, completion: nil)
        }
    }
}
