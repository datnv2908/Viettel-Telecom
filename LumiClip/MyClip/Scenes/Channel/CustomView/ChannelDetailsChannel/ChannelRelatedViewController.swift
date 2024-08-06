//
//  ListFollowsViewController.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelRelatedViewController: BaseSimpleTableViewController<ChannelModel>, FollowTableViewCellDelegate {
    let service = UserService()
    weak var parentVC: ChannelDetailsViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: FollowTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: FollowTableViewCell.nibName())
        // Do any additional setup after loading the view.
    }
    
    override func setupView() {
        super.setupView()
        self.currentLimit = 0
        self.currentOffset = 0
        refreshData()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void) {
        service.getRelatedChannels(channelId:(parentVC?.viewModel.channelModel.id)!) { (result) in
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
        }
    }
    
    override func convertToRowModel(_ item: ChannelModel) -> PBaseRowModel? {
        return FollowRowModel(item, false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? FollowTableViewCell {
            cell.delegate = self
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
      let channelVC = ChannelDetailsViewController(self.data[indexPath.row], isMyChannel: false)
        navigationController?.pushViewController(channelVC, animated: true)
    }
    
    func followTableViewCell(_ cell: FollowTableViewCell, didTapOnFollow sender: UIButton) {
        guard let indexPath = tableView?.indexPath(for: cell) else {
            return
        }
        let model = self.data[indexPath.row]
        if DataManager.isLoggedIn() {
            toggleFollowConfirm(model, at: indexPath.row)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.toggleFollowConfirm(model, at: indexPath.row)
                }
            })            
        }
    }
    
    func toggleFollowConfirm(_ model: ChannelModel, at index: Int) {
        if model.isFollow {
//            let dialogController = DialogViewController(title: String.UnFollowChannelTitle, message: String.init(format: String.UnFollowChannelDesc, model.name), confirmTitle: String.okString, cancelTitle: String.cancel)
//            weak var wself = self
//            dialogController.confirmDialog = {(sender) in
//                wself?.toggleFollow(model, at: index)
//            }
//            presentDialog(dialogController, animated: true, completion: nil)
            
            showAlert(title: String.UnFollowChannelTitle, message: String.ban_co_dong_y_xoa_kenh_lien_quan_nay_khong, okTitle: String.init(format: String.UnFollowChannelDesc, model.name), onOk: { [weak self](action) in
                
                self?.toggleFollow(model, at: index)
            })
        } else {
            toggleFollow(model, at: index)
        }
    }
    
    func toggleFollow(_ model: ChannelModel, at index: Int) {
        showHud()
        videoService.toggleFollowChannel(channelId: model.id,
                                         status: model.isFollow ? 0: 1,
                                         notificationType: 2,
                                         completion: { (result) in
                                            self.hideHude()
                                            switch result {
                                            case .success(let message):
                                                for (i, _) in self.data.enumerated() where i == index {
                                                    self.data[i].isFollow = !self.data[i].isFollow
                                                    if self.data[i].isFollow {
                                                        self.data[i].num_follow += 1
                                                    } else {
                                                        self.data[i].num_follow -= 1
                                                    }
                                                    break
                                                }
                                                self.toast(message as! String)
                                                self.reloadView()
                                            case .failure(let error):
                                                self.handleError(error as NSError, completion: { (result) in
                                                    if result.isSuccess {
                                                        self.toggleFollow(model, at: index)
                                                    }
                                                })
                                            }
        })
    }
    
    func reloadView() {
        var rows = [PBaseRowModel]()
        for item in data {
            rows.append(convertToRowModel(item)!)
        }
        viewModel.data = rows
        tableView?.reloadData()
    }
    
    deinit {
        DLog("")
    }
}
