//
//  ChannelHomeViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FirebasePerformance

class ChannelDetailsHomeViewController: BaseViewController {
    
    weak var parentVC: ChannelDetailsViewController?
    @IBOutlet weak var tableView: UITableView!
    
    let service = VideoServices()
    let userService = UserService()
    internal var viewModel: ChannelDetailsHomeViewModel
    var trace: Trace?
    init(_ channelModel: ChannelModel) {
        viewModel = ChannelDetailsHomeViewModel(channelModel)
        super.init(nibName: "ChannelDetailsHomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        trace = Performance.startTrace(name:"Chitietkenh_trangchu")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupView() {
        super.setupView()
        tableView?.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 94
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: VideoSmallImageTableViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: VideoSmallImageTableViewCell.nibName())
        tableView.register(UINib(nibName: WatchMoreTableViewCell.nibName(), bundle: nil),
                           forCellReuseIdentifier: WatchMoreTableViewCell.nibName())
        tableView.register(UINib(nibName: ChannelDetailsHeaderView.nibName(), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: ChannelDetailsHeaderView.nibName())
        tableView.register(UINib(nibName: ChannelDetailVideoGroupHeaderView.nibName(), bundle: nil),
                           forHeaderFooterViewReuseIdentifier: ChannelDetailVideoGroupHeaderView.nibName())
        getChannelDetails()
    }
    
    func getChannelDetails() {
        showHud()
        userService.getChannelDetails(viewModel.channelModel.id) { (result) in
            switch result {
            case .success(let response):
                self.viewModel.channelDetails = response.data
                self.parentVC?.navigationItem.title = response.data.name
                self.parentVC?.channelDetail = response.data
                self.tableView.reloadData()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
            self.trace?.stop()
        }
    }
    
    internal func performToggleFollow(_ model: ChannelDetailsModel) {
        //showHud()
        service.toggleFollowChannel(channelId: model.id,
                                         status: model.isFollow ? 0: 1,
                                         notificationType: 2,
                                         completion: { (result) in
                                            self.hideHude()
                                            switch result {
                                            case .success(let message):
                                                if let channelDetails = self.viewModel.channelDetails {
                                                    if channelDetails.isFollow {
                                                        channelDetails.numFollow -= 1
                                                        channelDetails.notificationType = .none
                                                    } else {
                                                        channelDetails.numFollow += 1
                                                        channelDetails.notificationType = .always
                                                    }
                                                    channelDetails.isFollow = !channelDetails.isFollow
                                                    self.viewModel.channelDetails = channelDetails
                                                }
                                                //self.toast(message as! String)
                                                self.tableView.reloadData()
                                            case .failure(let error):
                                                self.handleError(error as NSError, completion: { (result) in
                                                    if result.isSuccess {
                                                        self.performToggleFollow(model)
                                                    }
                                                })
                                            }
        })
    }
    
    func toggleFollowConfirm(_ model: ChannelDetailsModel) {
        if model.isFollow {
//            let dialogController = DialogViewController(title: String.UnFollowChannelTitle, message: String.init(format: String.UnFollowChannelDesc, model.name), confirmTitle: String.okString, cancelTitle: String.cancel)
//            weak var wself = self
//            dialogController.confirmDialog = {(sender) in
//                wself?.performToggleFollow(model)
//            }
//            presentDialog(dialogController, animated: true, completion: nil)
            
            showAlert(title: String.UnFollowChannelTitle, message: String.init(format: String.UnFollowChannelDesc, model.name), okTitle: String.okString, onOk: { [weak self] (action) in
                
                self?.performToggleFollow(model)
            })
        } else {
            performToggleFollow(model)
        }
    }
    
    internal func toggleNotification(_ model: ChannelDetailsModel) {
        var type: ChannelNotificationType
        if model.notificationType == .always || model.notificationType == .sometimes {
            type = .none
        } else {
            type = .always
        }
        var status = model.isFollow ? 1: 0
        showHud()
        service.toggleFollowChannel(channelId: model.id, status: status, notificationType: type.rawValue) { (result) in
            switch result {
            case.success(let message):
                self.toast(message as? String ?? "")
                var detail = self.viewModel.channelDetails
                detail?.notificationType = type
                self.viewModel.channelDetails = detail
                self.tableView.reloadData()
            case .failure(let error):
                weak var wself = self
                self.handleError(error as NSError, completion: { (completionBlockResult) in
                    if completionBlockResult.isSuccess {
                        wself?.toggleNotification(model)
                    }
                })
            }
            self.hideHude()
        }
    }
    
    deinit {
        service.cancelAllRequests()
        userService.cancelAllRequests()
    }
}

extension ChannelDetailsHomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = viewModel.sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier,
                                                 for: indexPath) as! BaseTableViewCell
        if let cell = cell as? VideoSmallImageTableViewCell {
            cell.bindingWithModel(rowModel)
            cell.delegate = self
        }
        if let cell = cell as? WatchMoreTableViewCell {
            if self.viewModel.sections[indexPath.section].header.title
                == self.viewModel.channelDetails?.mostViewVideo.name {
                cell.identifier = self.viewModel.channelDetails?.mostViewVideo.id
            } else if self.viewModel.sections[indexPath.section].header.title
                == self.viewModel.channelDetails?.newestVideo.name {
                cell.identifier = self.viewModel.channelDetails?.newestVideo.id                
            }
            cell.setupBtn(numVideo: (self.viewModel.channelDetails?.numVideo)!)
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      if let identifier = viewModel.sections[section].header.identifier {
          let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as! BaseTableHeaderView
          if headerView is ChannelDetailsHeaderView {
              (headerView as! ChannelDetailsHeaderView).delegate = self
              if let viewModelDetail = viewModel.channelDetails {
              (headerView as! ChannelDetailsHeaderView).getData(myChannel: viewModel.channelModel.isMyChannel,viewModel: viewModelDetail )
              }
          }
          headerView.bindingWithModel(viewModel.sections[section].header, section: section)
          return headerView
      } else {
          return nil
      }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

extension ChannelDetailsHomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let content = viewModel.contentModel(at: indexPath) {
            showVideoDetails(content)
        }
    }
}

extension ChannelDetailsHomeViewController: ChannelDetailsHeaderViewDelegate {
    func channelDetailsHeaderView(_ view: ChannelDetailsHeaderView, toggleFollow sender: UIButton) {
        guard let model = viewModel.channelDetails else {
            return
        }
        if DataManager.isLoggedIn() {
            toggleFollowConfirm(model)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.toggleFollowConfirm(model)
                }
            })
        }
    }
   func channelDetailsHeaderView(_ view: ChannelDetailsHeaderView, toggleEdit sender: UIButton) {
       showHud()
       userService.getDetailChannelAndUserEdit(id: viewModel.channelModel.id, type: .channel) { (result) in
           switch result {
           case .success(let response) :
               let model = EditMyChannelViewModel(model: response.data)
               let editChannel = EditMyChannelViewController2(model: model)
               editChannel.channelID = model.id
               editChannel.channelViewModel = model
               self.navigationController?.pushViewController(editChannel, animated: true)
               self.hideHude()
               break
           case .failure(let err ) :
               self.toast(err.localizedDescription)
               self.hideHude()
               break
           }
       }
   }
    func channelDetailsHeaderView(_ view: ChannelDetailsHeaderView, toggleBell sender: UIButton) {
        guard let model = viewModel.channelDetails else {
            return
        }
        if DataManager.isLoggedIn() {
            self.toggleNotification(model)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.toggleNotification(model)
                }
            })
        }
    }
}

extension ChannelDetailsHomeViewController: VideoSmallTableViewCellDelegate {
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView.indexPath(for: cell), let content = viewModel.contentModel(at: indexPath) {
            showMoreAction(for: content)
        }
    }
}

extension ChannelDetailsHomeViewController: WatchMoreTableViewCellDelegate {
    func watchMoreTableViewCell(_ cell: WatchMoreTableViewCell, didSelectLoadMore sender: UIButton) {
        if cell.identifier != nil {
            self.parentVC?.didSelectWatchMore(id: cell.identifier!)
        }
    }
}















