//
//  BaseMainSimpleTableViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/3/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import GoogleCast
import FirebasePerformance

class BaseMainSimpleTableViewController<NSObject>: BaseViewController, UITableViewDataSource, UITableViewDelegate, VideoTableViewCellDelegate, VideoSmallTableViewCellDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate{
    
    @IBOutlet weak var tableView: UITableView?
    fileprivate var refreshControl = UIRefreshControl()
    var currentOffset = Constants.kFirstOffset
    var currentLimit = Constants.kDefaultLimit
    fileprivate var isFirstTime: Bool = true
    public var viewModel: SimpleTableViewModelProtocol = SimpleTableViewModel()
    public var data = [ContentModel]()
    var isConfirmSms: String = "0"
    let appService = AppService()
    
    internal let userService = UserService()
   internal var hotCategories = [CategoryModel]()
   var headerView: UICollectionView?
   var mainHeader: UIView?
   var notifyNumber: Int = 0
   var freeCatgoryView : UIView?
   var titleImage  : UIImageView?
   var titleLb : UILabel?
   var trace: Trace?
   override var preferredStatusBarStyle: UIStatusBarStyle {
      if #available(iOS 13.0, *) {
         if DataManager.getStatusbarVaule() {
            return UIStatusBarStyle.lightContent
           
         }else{
            return UIStatusBarStyle.darkContent
         }
      }else{
         return UIStatusBarStyle.lightContent
      }

   }
   override func viewDidLoad() {
      super.viewDidLoad()
        trace = Performance.startTrace(name: "TrangChu")!
        trace?.start()
      tableView?.showsHorizontalScrollIndicator = false
      tableView?.showsVerticalScrollIndicator = false
      tableView?.backgroundColor = UIColor.setViewColor()
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
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.getStatusBar()
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
        
        getHotCategories();
        
        if isFirstTime {
            showHud()
        }
        let pager = Pager(offset: Constants.kFirstOffset, limit: currentLimit)
        getData(pager: pager) { (_ result: Result<APIResponse<HomeModel>>) in
            self.isFirstTime = false
            switch result {
            case .success(let response):
                var rowModels = [PBaseRowModel]()
                for item in response.data.videos {
                    if let rowModel = self.convertToRowModel(item) {
                        rowModels.append(rowModel)
                    }
                }
                self.viewModel.data = rowModels
                self.data = response.data.videos
                if self.currentOffset == 0 && self.currentLimit == 0 {
                    // offset and limit = zero when this view is not needed to have paging feature
                    // infinite Scrolling will not be appeared
                } else {
//                    if self.data.count < Constants.kDefaultLimit {
//                        self.tableView?.showsInfiniteScrolling = false
//                    } else {
//                        self.tableView?.showsInfiniteScrolling = true
//                    }
                    self.tableView?.showsInfiniteScrolling = true
                    self.currentOffset = Constants.kFirstOffset
                }
                self.reloadData()
                
                //self.viewListChannel(channels: response.data.channels)
                
                self.isConfirmSms = response.isConfirmSms
                
                // add firebase performance
                self.trace?.stop()
                
                
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
        let pager = Pager(offset: currentOffset, limit: currentLimit)
        getMoreData(pager: pager) { (_ result: Result<APIResponse<[ContentModel]>>) in
            switch result {
            case .success(let response):
                var rowModels = [PBaseRowModel]()
                for item in response.data {
                    if let rowModel = self.convertToRowModel(item) {
                        rowModels.append(rowModel)
                    }
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
                    self.currentOffset = self.currentOffset + self.currentLimit // update the current page
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
    
    func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<HomeModel>>) -> Void) {
        //mark: should be override in subclasses
        fatalError("Must override in subclasses")
    }
    func getMoreData(pager: Pager, _ completion: @escaping (Result<APIResponse<[ContentModel]>>) -> Void) {
        //mark: should be override in subclasses
        fatalError("Must override in subclasses")
    }
    
    func convertToRowModel(_ item: ContentModel) -> PBaseRowModel? {
        fatalError("Must override in subclasses")
    }
    
    func viewListChannel(categories: [CategoryModel]){
        self.hotCategories = categories
        //self.hotCategories.update(categories: categories, isAddEmty: true)
        self.reloadHeaderData()
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
        if let indexPath = tableView?.indexPath(for: cell) {
            let model = self.data[indexPath.row]
            showMoreAction(for: model)
        }
    }
    
    func videoTableViewCell(_ cell: VideoTableViewCell, didTapOnChannel sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: cell) {
            let model = self.data[indexPath.row]
         showChannelDetails(ChannelModel(id: model.channel_id, name: model.userName, desc: model.desc,numFollow: 0,numVideo: 0, viewCount: 0), isMyChannel: false)
        }
    }
    
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: cell) {
            let model = self.data[indexPath.row]
            showMoreAction(for: model)
        }
    }
    
    
    func getHotCategories() {
        userService.getHotCategory() { (result) in
            switch result {
            case .success(let response):
                self.viewListChannel(categories: response.data)
            case .failure:
                self.reloadHeaderData()
                break
            }
        }
    }
    
    func initChannelHeader(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        mainHeader = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 92))
        mainHeader?.backgroundColor = UIColor.clear
        self.headerCategrory()
        headerView = UICollectionView(frame: CGRect(x: 90, y: 10, width: view.frame.width, height: 72), collectionViewLayout: layout)
        headerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView?.backgroundColor = UIColor.clear
        
        headerView?.dataSource = self
        headerView?.delegate = self
        headerView?.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil),
                             forCellWithReuseIdentifier: CategoryCollectionViewCell.nibName())
        headerView?.showsHorizontalScrollIndicator = false
        
        mainHeader?.addSubview(headerView!)
        let divider = UIView(frame: CGRect(x: 0, y: 91, width: view.frame.width, height: 1))
      divider.backgroundColor = UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("DFDFDF"), color2: UIColor.colorFromHexa("1c1c1e"))
        divider.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mainHeader?.addSubview(divider)
        
        tableView?.tableHeaderView = mainHeader
    }
   
    func headerCategrory() {
      self.freeCatgoryView = UIView(frame: CGRect(x: 0, y: 10, width: 80, height: 72))
      self.titleImage  = UIImageView(image: UIImage(named: "placeholder_video"))
      self.titleLb = UILabel()
      let sectionView = UIView()
      let tapButton = UIButton()
      tapButton.setTitle("", for: .normal)
      tapButton.addTarget(self, action: #selector(freeCategoryAction), for: .touchUpInside)
      sectionView.backgroundColor = .lightGray.withAlphaComponent(0.5)
      self.freeCatgoryView?.addSubview(titleImage!)
      self.freeCatgoryView?.addSubview(titleLb!)
      self.freeCatgoryView?.addSubview(sectionView)
      self.freeCatgoryView?.addSubview(tapButton)
      self.titleLb?.text = String.Video_free
      self.titleLb?.font = UIFont(name: "Helvetica", size: 14)
      self.titleImage?.image = UIImage(named: "ic_free_video")
      self.titleImage?.contentMode = .scaleAspectFill
      self.titleLb?.translatesAutoresizingMaskIntoConstraints = false
      self.titleImage?.translatesAutoresizingMaskIntoConstraints = false
      sectionView.translatesAutoresizingMaskIntoConstraints = false
      tapButton.translatesAutoresizingMaskIntoConstraints = false
      [
         self.titleImage!.topAnchor.constraint(equalTo: self.freeCatgoryView!.topAnchor, constant: 0),
         self.titleImage!.centerXAnchor.constraint(equalTo: self.freeCatgoryView!.centerXAnchor),
         self.titleImage!.widthAnchor.constraint(equalToConstant: 50),
         self.titleImage!.heightAnchor.constraint(equalTo: self.titleImage!.widthAnchor, multiplier: 1, constant: 0),
         
         self.titleLb!.topAnchor.constraint(equalTo: self.titleImage!.bottomAnchor, constant: 2),
         self.titleLb!.rightAnchor.constraint(equalTo: self.freeCatgoryView!.rightAnchor, constant: 5),
         self.titleLb!.leftAnchor.constraint(equalTo: self.freeCatgoryView!.leftAnchor, constant: 5),
         
         sectionView.widthAnchor.constraint(equalToConstant: 1),
         sectionView.topAnchor.constraint(equalTo: self.titleImage!.topAnchor, constant: 0),
         sectionView.bottomAnchor.constraint(equalTo: self.titleLb!.bottomAnchor, constant: 0),
         sectionView.trailingAnchor.constraint(equalTo: self.freeCatgoryView!.trailingAnchor, constant: 2),
         
         tapButton.topAnchor.constraint(equalTo: self.freeCatgoryView!.topAnchor, constant: 0),
         tapButton.leadingAnchor.constraint(equalTo: self.freeCatgoryView!.leadingAnchor, constant: 0),
         tapButton.trailingAnchor.constraint(equalTo: self.freeCatgoryView!.trailingAnchor, constant: 0),
         tapButton.leadingAnchor.constraint(equalTo: self.freeCatgoryView!.leadingAnchor, constant: 0),
         tapButton.bottomAnchor.constraint(equalTo: self.freeCatgoryView!.bottomAnchor, constant: 0)
      ].forEach{$0.isActive = true}
      
      mainHeader?.addSubview(self.freeCatgoryView!)
     

   }
   override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
      self.titleImage?.layer.cornerRadius = 25
      self.titleImage?.clipsToBounds = true
   }
    @objc private func freeCategoryAction () {
      let vc = FreeCategoryViewController.initWithNib()
      self.navigationController?.pushViewController(vc, animated: true)
//        let viewcontroller = EventDetailsViewController(selectIndex:0, notifyNumber: notifyNumber)
//        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    func reloadHeaderData() {
        if hotCategories.isEmpty {
            tableView?.tableHeaderView = nil
        } else {
            tableView?.tableHeaderView = mainHeader
        }
        headerView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = hotCategories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  CategoryCollectionViewCell.nibName(), for: indexPath) as! CategoryCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if(hotCategories.count > indexPath.item){
            let viewcontroller = DetailCatogoryViewController.initWithNib()
            viewcontroller.cateModel = hotCategories[indexPath.item]
            navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
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
    
    func gotoPickChannel(){
        let channelVC = SelectChannelViewController.initWithNib()
        channelVC.completionBlock = {( result) in
            //wself?.getFollowedChannels()
        }
        let nav = BaseNavigationController(rootViewController: channelVC)
        present(nav, animated: true, completion: nil)
    }
    
    func gotoVideoDetail(_ viewController: BaseMainSimpleTableViewController,
                         didSelect item: ContentModel,
                         at indexPath: IndexPath){
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        showVideoDetails(item)
    }
}
