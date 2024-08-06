//
//  HomeMyChannelVC.swift
//  UClip
//
//  Created by Toan on 5/19/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeMyChannelVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, PlaylistTableViewCellDelegate {
    
    @IBOutlet weak var homeMutilChanneltb: UITableView!
    internal var channels : ChannelDetailsModel!
    fileprivate var refreshControl = UIRefreshControl()
    let service = VideoServices()
    let serviceChannel = AppService()
    let serviceUser = UserService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        homeMutilChanneltb?.showsInfiniteScrolling = false
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        homeMutilChanneltb.addSubview(refreshControl)
       if self.channels.channels.count == 0 {
         self.homeMutilChanneltb.backgroundView = self.emptyView()
      }
        self.homeMutilChanneltb.backgroundColor = UIColor.setViewColor()
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
        }
        self.showHud()
        let userID = DataManager.getCurrentMemberModel()?.userId
      serviceChannel.getMutilChannelDetails(userID!,getActiveChannel: .isChannelActive) { [weak self ](result) in
            switch result {
            case .success(let  response) :
                let model = response.data
                self?.channels = ChannelDetailsModel(model)
                self?.hideHude()
                break
            case .failure(let err) :
                self?.toast(err.localizedDescription)
                self?.hideHude()
                break
                
            }
        }
        refreshControl.endRefreshing()
        reloadData()
    }
    override func setupView() {
        
        
    }
    func reloadData(){
        homeMutilChanneltb.delegate = self
        homeMutilChanneltb.dataSource = self
        homeMutilChanneltb.register(UINib(nibName: PlaylistTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: PlaylistTableViewCell.nibName())
        homeMutilChanneltb.register(UINib(nibName: "headerUserChannelView", bundle: nil), forHeaderFooterViewReuseIdentifier: "headerUserChannelView")
        homeMutilChanneltb.tableFooterView = UIView()
        homeMutilChanneltb.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  homeMutilChanneltb.dequeueReusableHeaderFooterView(withIdentifier: "headerUserChannelView") as! headerUserChannelView
        if let channelInfor = channels {
            header.delegate = self
            header.blindingData(userInfo: channelInfor)
        }
     
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistTableViewCell.nibName()) as! PlaylistTableViewCell
        let rowModel = PlaylistRowModel(channels.channels[indexPath.row])
        cell.isChannel = true
        cell.bindingWithModel(rowModel)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showChannelDetails(ChannelModel(id: channels.channels[indexPath.row].objectID, name: channels.channels[indexPath.row].title, desc: channels.channels[indexPath.row].desc,numFollow: Int(channels.channels[indexPath.row].followCount) ?? 0 ,numVideo: channels.channels[indexPath.row].videoCount, viewCount: channels.channels[indexPath.row].viewCount ), isMyChannel: true)
    }
    
    func playlistTableViewCell(_ cell: PlaylistTableViewCell, didTapOnEdit sender: UIButton) {
        if let indexPath = homeMutilChanneltb?.indexPath(for: cell) {
            let actionController = ActionSheetViewController()
            actionController.addAction(Action(ActionData(title: String.chinh_sua,
                                                         image: #imageLiteral(resourceName: "iconPencil")), style: .default, handler: { (action) in
                                                            self.editChannel(model: self.channels.channels[indexPath.row] )
                                                         }))
            present(actionController, animated: true, completion: nil)
        }
    }
    func editChannel(model : MutilChannelModel){
        self.showHud()
        self.serviceUser.getDetailChannelAndUserEdit(id: model.objectID, type: .channel) { (result) in
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
}
extension HomeMyChannelVC : headerUserDelegate{
    func onCrateChannel() {
        let vc = CreateChannelVc.initWithNib()
        vc.channelCurrent = channels.channels.count
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
