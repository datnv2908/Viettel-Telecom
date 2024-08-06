//
//  ListFollowsViewController.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AddChannelRelatedViewController: BaseSimpleTableViewController<ChannelModel>, AddChannelTableViewCellDelegate, UITextFieldDelegate {
    let service = UserService()
    weak var parentVC: ChannelDetailsViewController?
   var channelModel: ChannelModel?
    @IBOutlet weak var tfSearchBox: UITextField!
   @IBOutlet weak var searchBgView: UIView!
   override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: AddChannelTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: AddChannelTableViewCell.nibName())
        
        self.tfSearchBox.delegate = self
        self.searchBgView.backgroundColor = UIColor.setViewColor()
      self.tfSearchBox.attributedPlaceholder = NSAttributedString(
         string: "\(String.tim_kiem)...",
         attributes: [NSAttributedString.Key.foregroundColor: UIColor.settitleColor()]
     )
    }
    
    func textFieldShouldReturn(_ tfSearchBox: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func setupView() {
        super.setupView()
        self.currentLimit = 0
        self.currentOffset = 0
        navigationItem.title = String.them_kenh
        refreshData()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ChannelModel]>>) -> Void) {
      if let user = DataManager.getCurrentMemberModel() {
         service.getHotChannelByAcc(channelId:(user.userId)) { (result) in
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
    
    }
    
    override func convertToRowModel(_ item: ChannelModel) -> PBaseRowModel? {
        var model = FollowRowModel(item, true)
        model.identifier = AddChannelTableViewCell.nibName()
        return model
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AddChannelTableViewCell {
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
    
    func followTableViewCell(_ cell: AddChannelTableViewCell, didTapOnFollow sender: UIButton) {
        guard let indexPath = tableView?.indexPath(for: cell) else {
            return
        }
        let model = self.data[indexPath.row]
        if DataManager.isLoggedIn() {
            addRelatedChannel(model, at: indexPath.row)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.addRelatedChannel(model, at: indexPath.row)
                }
            })            
        }
    }
    
    func addRelatedChannel(_ model: ChannelModel, at index: Int) {
        self.doAddChannel(model, at: index)
    }
    
    func doAddChannel(_ model: ChannelModel, at index: Int) {
        showHud()
        service.addRelatedChannel(channelId: model.id,
                                     { (result) in
                                            self.hideHude()
                                            switch result {
                                            case .success(let message):
                                                self.toast(message as! String)
                                                self.refreshData()
                                            case .failure(let error):
                                                self.handleError(error as NSError, completion: { (result) in
                                                    if result.isSuccess {
                                                        self.doAddChannel(model, at: index)
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
    
    
    
    @IBAction func onSearchEnter(_ sender: Any) {
        let query = tfSearchBox.text
        if((query?.count)! == 1){
            return
        }else if((query?.count)! == 0 ){
            refreshData()
        }else{
            doSearchSuggestion(substring: query!)
        }
    }
    
    func doSearchSuggestion(substring: String) {
        service.searchChannelRelatedSuggestion(queryContent:substring) { (result) in
            switch result {
            case .success(let response):
                var rowModels = [PBaseRowModel]()
                for item in response.data {
                    if let rowModel = self.convertToRowModel(item) {
                        rowModels.append(rowModel)
                    }
                }
                self.viewModel.data = rowModels
                self.data = response.data
                self.reloadData()
            case .failure(_):
                break;
            }
        }
    }

    
    deinit {
        DLog("")
    }
}
