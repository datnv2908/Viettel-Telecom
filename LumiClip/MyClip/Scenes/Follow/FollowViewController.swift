//
//  FollowViewController.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit
import GoogleCast
import MIBadgeButton_Swift

class FollowViewController: BaseFollowSimpleTableViewController<ContentModel>, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var seeAllButton: UIButton!
    
    @IBOutlet weak var seprateView: UIView!
    var followViewModel = FollowViewModel()
    internal let service = VideoServices()
    internal let userService = UserService()
    internal var followedChannels = [ChannelModel]()
    var playerManager: FWDraggableManager?
    override var viewModel: SimpleTableViewModelProtocol {
        get {
            return followViewModel
        }
        set {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logScreen(GoogleAnalyticKeys.follow.rawValue)
        LoggingRecommend.viewFollowPage()
        seeAllButton.setTitle(String.xem_tat_ca, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupView() {
        super.setupView()
        //initNavigationItem()
        seprateView.backgroundColor = UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("DFDFDF"), color2: .black)
        seeAllButton.backgroundColor = UIColor.setViewColor()
        collectionView.backgroundColor = UIColor.setViewColor()
        tableView?.register(UINib(nibName: VideoTableViewCell.nibName(), bundle: nil),
                            forCellReuseIdentifier: VideoTableViewCell.nibName())
        tableView?.tableFooterView = UIView(frame: .zero)
        collectionView.register(UINib(nibName: "ChannelFollowCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: ChannelFollowCollectionViewCell.nibName())
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reloadFollowView(_:)),
                                               name: .kNotificationShouldReloadFollow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reconnectInternet),
                                               name: .kConnectInternet,
                                               object: nil)
        refreshData()
        getFollowedChannels()
    }

    @objc func reconnectInternet() {
        if self.data.isEmpty {
            refreshData()
            getFollowedChannels()
        }
    }

    @objc func reloadFollowView(_ notify: Notification) {
        refreshData()
        getFollowedChannels()
    }
    
    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        service.getMoreContents(for: MoreContentType.follow.rawValue, pager: pager) { (result) in
            switch result {
            case .success(_):
                completion(result)
            case .failure(let error):
                let err = error as NSError
                if err.code == NSURLErrorNotConnectedToInternet ||
                    err.code == NSURLErrorNetworkConnectionLost {
                    self.followedChannels.removeAll()
                    self.followViewModel.channelFollows.removeAll()
                    self.reloadData()
                }
                self.handleError(error as NSError, automaticShowError: false, completion: { (handleResult) in
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
        return VideoRowModel(video: item)
    }
    
    func reloadData() {
        if followViewModel.channelFollows.isEmpty {
            seeAllButton.isHidden = true
            collectionViewHeight.constant = 0
        } else {
            seeAllButton.isHidden = false
            collectionViewHeight.constant = 64
        }
        collectionView.reloadData()
    }
    
    func getFollowedChannels() {
        var includeHot = 0
        if DataManager.isLoggedIn() {
            includeHot = 0
        } else {
            includeHot = 1
        }
        userService.getFollowedChannels(pager: Pager(offset: 0, limit: 10), includeHot: includeHot) { (result) in
            switch result {
            case .success(let response):
                self.followedChannels = response.data
                self.followViewModel.update(channels: response.data, isAddEmty: false)
                self.reloadData()
            case .failure:
                self.reloadData()
                break
            }
        }
    }
    
    @IBAction func onClickViewAllButton(_ sender: Any) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        let vc = ListFollowsViewController.initWithNib()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        let model = self.data[indexPath.row]
        showVideoDetails(model)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followViewModel.channelFollows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = followViewModel.channelFollows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier, for: indexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
      let viewcontroller = ChannelDetailsViewController(followedChannels[indexPath.item], isMyChannel: false)
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func goToTop(){
        
        if (viewModel.data.count == 0)
        {
            return
        }
        
        let indexPath = NSIndexPath.init(row: 0, section: 0)
        self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
}

