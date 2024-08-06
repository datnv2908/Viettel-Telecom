//
//  ListFollowsViewController.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MyChannelRelatedViewController: BaseSimpleTableViewController<ChannelModel>, MyFollowTableViewCellDelegate {
    let service = UserService()
    weak var parentVC: ChannelDetailsViewController?
   var channelModel: ChannelModel?
    @IBOutlet weak var imgAddChannel: UIImageView!
    @IBOutlet weak var addChannelLabel: UILabel!
    
    @IBOutlet weak var SearchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: MyFollowTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: MyFollowTableViewCell.nibName())
        // Do any additional setup after loading the view.
        addChannelLabel.text = String.them_kenh
      tableView.backgroundColor = UIColor.setViewColor()
    }
    
    override func setupView() {
        super.setupView()
        SearchView.backgroundColor = UIColor.setViewColor()
        imgAddChannel?.layer.borderColor = UIColor.colorFromHexa("eeeeee").cgColor
        imgAddChannel?.layer.borderWidth = 2.0
        imgAddChannel?.contentMode = .center
        self.currentLimit = 0
        self.currentOffset = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void) {
        service.getRelatedChannels(channelId:(channelModel?.id ?? parentVC?.viewModel.channelModel.id)!) { (result) in
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
        return FollowRowModel(item, true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? MyFollowTableViewCell {
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
    
    func followTableViewCell(_ cell: MyFollowTableViewCell, didTapOnFollow sender: UIButton) {
        guard let indexPath = tableView?.indexPath(for: cell) else {
            return
        }
        let model = self.data[indexPath.row]
        if DataManager.isLoggedIn() {
            removeRelatedChannel(model, at: indexPath.row)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.removeRelatedChannel(model, at: indexPath.row)
                }
            })            
        }
    }
    
    func removeRelatedChannel(_ model: ChannelModel, at index: Int) {
//        let dialogController = DialogViewController(title: String.UnFollowChannelTitle, message: String.ban_co_dong_y_xoa_kenh_lien_quan_nay_khong, confirmTitle: String.okString, cancelTitle: String.cancel)
//        weak var wself = self
//        dialogController.confirmDialog = {(sender) in
//            wself?.doRemoveChannel(model, at: index)
//        }
//        presentDialog(dialogController, animated: true, completion: nil)
        
        showAlert(title: String.UnFollowChannelTitle, message: String.ban_co_dong_y_xoa_kenh_lien_quan_nay_khong, okTitle: String.okString, onOk: { [weak self](action) in
            
            self?.doRemoveChannel(model, at: index)
        })
    }
    
    func doRemoveChannel(_ model: ChannelModel, at index: Int) {
        showHud()
        service.removeRelatedChannel(channelId: model.id,
                                     { (result) in
                                            self.hideHude()
                                            switch result {
                                            case .success(let message):
                                                self.toast(message as! String)
                                                self.refreshData()
                                            case .failure(let error):
                                                self.handleError(error as NSError, completion: { (result) in
                                                    if result.isSuccess {
                                                        self.doRemoveChannel(model, at: index)
                                                    }
                                                })
                                            }
        })
    }
    
    @IBAction func actionAddChannel(_ sender: Any) {
        let vc = AddChannelRelatedViewController.initWithNib()
        vc.parentVC = self.parentVC
        vc.channelModel = self.channelModel
        navigationController?.pushViewController(vc, animated: true)
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
