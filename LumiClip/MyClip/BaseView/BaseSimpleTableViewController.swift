//
//  BaseSimpleTableViewController.swift
//  MyClip
//
//  Created by Huy Nguyen on 6/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SVPullToRefresh

class BaseSimpleTableViewController<T: NSObject>: BaseViewController, UITableViewDataSource, UITableViewDelegate, VideoTableViewCellDelegate, VideoSmallTableViewCellDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var refreshControl = UIRefreshControl()
    var currentOffset = Constants.kFirstOffset
    var currentLimit = Constants.kDefaultLimit
    fileprivate var isFirstTime: Bool = true
    public var viewModel: SimpleTableViewModelProtocol = SimpleTableViewModel()
    public var data = [T]()
    var isConfirmSms: String = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.tableView.backgroundColor = UIColor.setViewColor()
      self.view.backgroundColor = UIColor.setViewColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func setupView() {
        addRefreshControl()
        addScrollToLoadMore()
        registerNib()
    }

    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.black
        tableView?.addSubview(refreshControl)
    }

    func addScrollToLoadMore() {
        weak var wself = self
        tableView?.addInfiniteScrolling(actionHandler: {
            wself?.getNextPage()
        })
        tableView?.showsInfiniteScrolling = false
    }

    func registerNib() {
        self.tableView?.delegate = self
        for rowModel in viewModel.data {
            if Bundle.main.path(forResource: rowModel.identifier, ofType: "nib") != nil {
                tableView?.register(UINib(nibName: rowModel.identifier, bundle: nil),
                                    forCellReuseIdentifier: rowModel.identifier)
            }
        }
    }

    override func onRetry(_ view: NoInternetView, sender: UIButton) {
        refreshData()
    }

    @objc func refreshData() {
        if !Singleton.sharedInstance.isConnectedInternet {
            let error = NSError(domain: "", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
            reloadData(error)
            self.hideHude()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView?.infiniteScrollingView.stopAnimating()
            return
        }
        
        if isFirstTime {
            showHud()
        }
        let pager = Pager(offset: Constants.kFirstOffset, limit: currentLimit)
        getData(pager: pager) { (_ result: Result<APIResponse<[T]>>) in
            self.isFirstTime = false
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
                if self.currentOffset == 0 && self.currentLimit == 0 {
                    // offset and limit = zero when this view is not needed to have paging feature
                    // infinite Scrolling will not be appeared
                } else {
                    if self.data.count < Constants.kDefaultLimit {
                        self.tableView?.showsInfiniteScrolling = false
                    } else {
                        self.tableView?.showsInfiniteScrolling = true
                    }
                    self.currentOffset = Constants.kFirstOffset
                }
                self.reloadData()
            
                self.isConfirmSms = response.isConfirmSms
                
                if (self.tableView?.indexPathsForVisibleRows != nil
                    && (self.tableView?.indexPathsForVisibleRows?.count)! > 0) {
                    self.doDisplayAnimation(NSIndexPath(row: 0, section: 0) as IndexPath)
                }
                break
            case .failure(let error as NSError):
                if error.code == NSURLErrorNotConnectedToInternet ||
                    error.code == NSURLErrorNetworkConnectionLost {
                    self.reloadData(error)
                } else {
                    self.toast(error.localizedDescription)
                    break
                }
            default:
                break
            }
            
            self.hideHude()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView?.infiniteScrollingView.stopAnimating()
        }
    }

    func getNextPage() {
        let pager = Pager(offset: currentOffset + currentLimit, limit: currentLimit)
        getData(pager: pager) { (_ result: Result<APIResponse<[T]>>) in
            switch result {
            case .success(let response):
                var rowModels = [PBaseRowModel]()
                for item in response.data {
                    if let rowModel = self.convertToRowModel(item) {
                        rowModels.append(rowModel)
                    }
                }
               
                  if response.data.count  == 0{
                     self.tableView.backgroundView = self.emptyView()
                  }
               
               
                self.viewModel.data.append(contentsOf: rowModels)
                self.data.append(contentsOf: response.data)
                if self.currentOffset == 0 && self.currentLimit == 0 {

                } else {
                    if response.data.count < self.currentLimit {
                        self.tableView?.showsInfiniteScrolling = false
                    } else {
                        self.tableView?.showsInfiniteScrolling = true
                    }
                    self.currentOffset = pager.offset // update the current page
                }
                self.reloadData()
                break
            case .failure(let error as NSError):
                if error.code == NSURLErrorNotConnectedToInternet ||
                    error.code == NSURLErrorNetworkConnectionLost {
                    self.reloadData(error)
                } else {
                    self.toast(error.localizedDescription)
                    break
                }
            default:
                break
            }
            self.hideHude()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.tableView?.infiniteScrollingView.stopAnimating()
        }
    }

    func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[T]>>) -> Void) {
        //mark: should be override in subclasses
        fatalError("Must override in subclasses")
    }

    func convertToRowModel(_ item: T) -> PBaseRowModel? {
        fatalError("Must override in subclasses")
    }

    func reloadData(_ error: NSError? = nil) {
        registerNib()
        if let error = error {
            if error.code == NSURLErrorNotConnectedToInternet ||
                error.code == NSURLErrorNetworkConnectionLost {
                self.data.removeAll()
                self.viewModel.data.removeAll()
                tableView?.backgroundView = offlineView()
            } else {
                tableView?.backgroundView = emptyView()
            }
        } else if data.isEmpty {
            tableView?.backgroundView = emptyView()
        } else {
            tableView?.backgroundView = nil
        }
        tableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = viewModel.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier,
                                                 for: indexPath) as! BaseTableViewCell
        if let cell = cell as? VideoTableViewCell {
            cell.delegate = self
        }
        if let cell = cell as? VideoSmallImageTableViewCell {
            cell.delegate = self
        }
      if let cell = cell as? NotificationTableViewCell {
         
      }
        cell.bindingWithModel(rowModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func videoTableViewCell(_ cell: VideoTableViewCell, didTapOnAction sender: UIButton) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if let indexPath = tableView?.indexPath(for: cell), let model = self.data[indexPath.row] as? ContentModel {
            showMoreAction(for: model)
        }
    }
    
    func videoTableViewCell(_ cell: VideoTableViewCell, didTapOnChannel sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: cell), let model = self.data[indexPath.row] as? ContentModel {
         showChannelDetails(ChannelModel(id: model.userId, name: model.userName, desc: model.desc,numFollow: 0,numVideo: 0, viewCount: 0), isMyChannel: false)
        }
    }
    
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: cell), let model = self.data[indexPath.row] as? ContentModel {
            showMoreAction(for: model)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView?.indexPathsForVisibleRows != nil
            && (self.tableView?.indexPathsForVisibleRows?.count)! > 0) {
            let indexPath = self.tableView?.indexPathsForVisibleRows![(self.tableView?.indexPathsForVisibleRows?.count)! / 2]
            self.doDisplayAnimation(indexPath!)
        }
    }
    
    func doDisplayAnimation(_ indexPath: IndexPath){
        let cell = tableView?.cellForRow(at: indexPath)
        if let cell = cell as? VideoTableViewCell {
            cell.displayAnimationPicture(viewModel.data[indexPath.row])
        }
        
        for i in 0...(tableView?.numberOfSections)!-1
        {
            for j in 0...(tableView?.numberOfRows(inSection: i))!-1
            {
                if(indexPath != NSIndexPath(row: j, section: i) as IndexPath){
                    let cell = tableView?.cellForRow(at: NSIndexPath(row: j, section: i) as IndexPath)
                    if let cell = cell as? VideoTableViewCell {
                        cell.hideAnimationPicture(viewModel.data[j])
                    }
                }
                
            }
        }
    }
}
