//
//  BasePopularSimpleTableViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 4/24/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import GoogleCast
import FirebasePerformance

class BasePopularSimpleTableViewController<T: NSObject>: BaseViewController, UITableViewDataSource, UITableViewDelegate, VideoTableViewCellDelegate, VideoSmallTableViewCellDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView?
    fileprivate var refreshControl = UIRefreshControl()
    var currentOffset = Constants.kFirstOffset
    var currentLimit = Constants.kDefaultLimit
    fileprivate var isFirstTime: Bool = true
    public var viewModel: SimpleTableViewModelProtocol = SimpleTableViewModel()
    public var data = [T]()
    var isConfirmSms: String = "0"
    var notificationButton: MIBadgeButton?
    let appService = AppService()
    internal let userService = UserService()
    
    var delegate: BaseHomeSimpleTableViewDelegate!
    
    var followViewModel = FollowViewModel()
    internal var followedChannels = [ChannelModel]()
    var headerView: UICollectionView?
    var mainHeader: UIView?
    
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
        trace = Performance.startTrace(name:"ThinhHanh")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setupView() {
        initNavigationItem()
        addRefreshControl()
        addScrollToLoadMore()
        registerNib()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    func initNavigationItem(){
        let logoButton = UIButton(type:.system)
        logoButton.setImage(#imageLiteral(resourceName: "ic_logo_text").withRenderingMode(.alwaysTemplate), for:.normal)
        
        let rightBtn = UIBarButtonItem(customView:logoButton)
        rightBtn.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightBtn.customView?.heightAnchor.constraint(equalToConstant: 27).isActive = true
        rightBtn.customView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        navigationItem.leftBarButtonItem = rightBtn
        
        let searchButton = UIButton(type:.system)
        searchButton.setImage(#imageLiteral(resourceName: "iconSearchGray").withRenderingMode(.alwaysTemplate), for:.normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        searchButton.addTarget(self, action:#selector(searchButtonClicked), for: .touchUpInside)
        
        let changeLanguageButton = UIButton(type:.system)

        if getShortLanguage() == "en" {
            changeLanguageButton.setImage(#imageLiteral(resourceName: "ic_us").withRenderingMode(.alwaysOriginal), for:.normal)
        } else {
            changeLanguageButton.setImage(#imageLiteral(resourceName: "ic_bdn").withRenderingMode(.alwaysOriginal), for:.normal)
        }
        changeLanguageButton.frame = CGRect(x: 0, y: 0, width: 25, height: 20)
        changeLanguageButton.addTarget(self, action:#selector(changeLanguage), for: .touchUpInside)
        
        let languageBarBtn = UIBarButtonItem(customView:changeLanguageButton)
        languageBarBtn.customView?.translatesAutoresizingMaskIntoConstraints = false
        languageBarBtn.customView?.heightAnchor.constraint(equalToConstant: 15).isActive = true
        languageBarBtn.customView?.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        let uploadButton = UIButton(type:.system)
        uploadButton.setImage(#imageLiteral(resourceName: "icDangTai").withRenderingMode(.alwaysTemplate), for:.normal)
        uploadButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        uploadButton.addTarget(self, action:#selector(uploadButtonClicked), for: .touchUpInside)
        
        notificationButton = MIBadgeButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(34), height: CGFloat(34))) 
        notificationButton?.setImage(#imageLiteral(resourceName: "icThongBao").withRenderingMode(.alwaysTemplate), for:.normal)
        notificationButton?.badgeEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 8)
        notificationButton?.badgeTextColor = UIColor.white
        notificationButton?.badgeBackgroundColor = UIColor.red
        notificationButton?.addTarget(self, action:#selector(notifyButtonClicked), for: .touchUpInside)
        
        let castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(34), height: CGFloat(34)))
        castButton.tintColor = UIColor.colorFromHexa("4a4a4a")
        
        if let model = DataManager.getCurrentAccountSettingsModel() {
            if(model.event == "20-10"){
                logoButton.tintColor = UIColor.colorFromHexa("fbe116")
                self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "bgEvent2010").resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
//                UIApplication.shared.statusBarStyle = .default
                
                navigationController?.navigationBar.barStyle = UIBarStyle.default
                navigationController?.navigationBar.tintColor = UIColor.black
                
                let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.blackTitleColor(),
                                 NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
                UINavigationBar.appearance().titleTextAttributes = titleDict
            }else if(model.event == "aff-cup"){
                logoButton.tintColor = UIColor.colorFromHexa("feca26")
                self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "bgEventAffcupIphoneX").resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
                searchButton.tintColor = UIColor.colorFromHexa("ffffff")
                changeLanguageButton.tintColor = UIColor.colorFromHexa("ffffff")
                uploadButton.tintColor = UIColor.colorFromHexa("ffffff")
                notificationButton?.tintColor = UIColor.colorFromHexa("ffffff")
                castButton.tintColor = UIColor.colorFromHexa("ffffff")
                
//                UIApplication.shared.statusBarStyle = .lightContent
                
                navigationController?.navigationBar.barStyle = UIBarStyle.black
                navigationController?.navigationBar.tintColor = UIColor.white
                navigationController?.navigationBar.barTintColor = UIColor.white
                navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
                
                let titleDict = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                 NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
                navigationController?.navigationBar.titleTextAttributes = titleDict
            }
            else{
                logoButton.tintColor = UIColor.colorFromHexa(Constants.mainColorHex)
                self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                searchButton.tintColor = UIColor.colorFromHexa("4a4a4a")
                uploadButton.tintColor = UIColor.colorFromHexa("4a4a4a")
                changeLanguageButton.tintColor = UIColor.colorFromHexa("4a4a4a")
                notificationButton?.tintColor = UIColor.colorFromHexa("4a4a4a")
                castButton.tintColor = UIColor.colorFromHexa("4a4a4a")
//                UIApplication.shared.statusBarStyle = .default
                
                navigationController?.navigationBar.barStyle = UIBarStyle.default
                navigationController?.navigationBar.tintColor = UIColor.black
                
                let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.blackTitleColor(),
                                 NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
                UINavigationBar.appearance().titleTextAttributes = titleDict
            }
        }else{
            logoButton.tintColor = UIColor.colorFromHexa(Constants.mainColorHex)
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            searchButton.tintColor = UIColor.colorFromHexa("4a4a4a")
            uploadButton.tintColor = UIColor.colorFromHexa("4a4a4a")
            changeLanguageButton.tintColor = UIColor.colorFromHexa("4a4a4a")
            notificationButton?.tintColor = UIColor.colorFromHexa("4a4a4a")
            castButton.tintColor = UIColor.colorFromHexa("4a4a4a")
//            UIApplication.shared.statusBarStyle = .default
            
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            navigationController?.navigationBar.tintColor = UIColor.black
            
            let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.blackTitleColor(),
                             NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
            UINavigationBar.appearance().titleTextAttributes = titleDict
        }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView:searchButton), UIBarButtonItem(customView:(notificationButton)!) , UIBarButtonItem(customView:uploadButton), languageBarBtn, UIBarButtonItem(customView:castButton)]
        
        self.delegate?.initHeaderFinish()
    }
   override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      self.navigationController?.navigationBar.barTintColor = UIColor.setViewColor()
   }
    @objc func changeLanguage() {
        let alertController = UIAlertController(title: "",
                                                message: String.thay_doi_ngon_ngu,
                                                preferredStyle: .alert)
        let ptAction = UIAlertAction(title: String.tieng_mov, style: .default, handler: { (_) in
            
            self.reloadRootViewController(lange: "pt-PT")
            
        })
        let enAction = UIAlertAction(title: String.tieng_anh, style: .default, handler: { (_) in
            self.reloadRootViewController(lange: "en")
        })
//        let viAction = UIAlertAction(title: String.tieng_viet, style: .default, handler: { (_) in
//            DataManager.save(object: ["vi"], forKey: "AppleLanguages")
//            RTLocalizationSystem.rtSetLanguage("vi")
//            self.reloadRootViewController()
//        })
        let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: { (_) in

        })
        alertController.addAction(ptAction)
        alertController.addAction(enAction)
//        alertController.addAction(viAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func reloadRootViewController(lange: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.showLoading()
//        self.view.makeToast(String.yeu_cau_restart_app)
        
        let alertController = UIAlertController(title: "",
                                                message: String.yeu_cau_restart_app,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.okString, style: .default, handler: { (_) in
            DataManager.save(object: [lange], forKey: "AppleLanguages")
            RTLocalizationSystem.rtSetLanguage(lange)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
           appDelegate.showHomePage()
        })
        alertController.addAction(okAction)
        alertController.addAction(UIAlertAction(title: String.huy, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func searchButtonClicked() {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        let searchVC = SearchConfigurator.viewController()
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(searchVC, animated: false)
    }
    
    @objc func uploadButtonClicked(){
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
      if !Singleton.sharedInstance.isConnectedInternet {
                 showInternetConnectionError()
                 return
             }
             if DataManager.isLoggedIn() {
              if let model = DataManager.getCurrentMemberModel() {
                 if model.isUpLoad == 5 {
                    let alert  = UIAlertController(title: String.notice , message: String.creat_a_channel , preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: String.cancel, style: .default) { _ in
                       alert.dismiss(animated: false, completion: nil)
                    }
                    let doneAction = UIAlertAction(title: String.okString, style: .default) { _ in
                       let vc = CreateChannelVc.initWithNib()
                       vc.channelCurrent = 0
                       self.navigationController?.pushViewController(vc, animated: true)
                    }
                  alert.addAction(closeAction)
                  alert.addAction(doneAction)
                  self.present(alert, animated: false, completion: nil)
                 }else if model.isUpLoad == 0{
                  let updateInforVC = ContractTermsConditionViewController(false)
                  self.navigationController?.pushViewController(updateInforVC, animated: true)
                 } else if model.isUpLoad == 1 {
                  self.toast(String.alert_waiting_approve)
                 }else if model.isUpLoad == 4 {
                  self.toast(String.alert_lock_approve)
                 } else if model.isUpLoad == 3 {
                  self.toast(String.alert_revoke_approve)
                 }else{
                  appService.getAccountInfoUpload()
                  { (result) in
                     switch result {
                     case .success(let response):
                             Singleton.sharedInstance.isHasVideo = response.data.isHasVideo
                             Singleton.sharedInstance.userStatus = response.data.status
                             if(response.data.isHasVideo == 0){
                                 NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                                 let selectVideoVC = SelectVideoViewController.initWithNib()
                                 let nav = BaseNavigationController(rootViewController: selectVideoVC)
                                 self.present(nav, animated: true, completion: nil)
                             }else{
                                 if(response.data.status == 1
                                     || response.data.status == 2){
                                     NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                                     let selectVideoVC = SelectVideoViewController.initWithNib()
                                     let nav = BaseNavigationController(rootViewController: selectVideoVC)
                                     self.present(nav, animated: true, completion: nil)
                                 }else{
                                     let updateInforVC = ContractTermsConditionViewController(false)
                                     self.navigationController?.pushViewController(updateInforVC, animated: true)
                                 }
                             }
                         case .failure(let error):
                             self.handleError(error as NSError, automaticShowError: false, completion: {
                                 (result) in
                                 if result.isSuccess {
                                     
                                 }
                             })
                             break
                         }
                 }
              }
              }
             } else {
                 performLogin(completion: { (result) in
                     if result.isSuccess {
                         NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                         let selectVideoVC = SelectVideoViewController.initWithNib()
                         let nav = BaseNavigationController(rootViewController: selectVideoVC)
                         self.present(nav, animated: true, completion: nil)
                     }
                 })
             }
    }
    
    @objc func notifyButtonClicked(){
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if DataManager.isLoggedIn() {
            let vc = NotificationViewController.initWithNib()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            performLogin(completion: { (result) in
            })
        }
    }
    
    func updateNotifyNumber(_ count:Int){
        if count > 0 {
            self.notificationButton?.badgeString = String(count)
        } else {
            self.notificationButton?.badgeString = ""
        }
    }
    
    func addRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
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
                
//                print("isconfirmSms \(self.isConfirmSms)")
                
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
         showChannelDetails(ChannelModel(id: model.channel_id, name: model.userName, desc: model.desc,numFollow: 0,numVideo: 0, viewCount: 0), isMyChannel: false)
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
    
    func gotoVideoDetail(_ viewController: BasePopularSimpleTableViewController,
                         didSelect item: ContentModel,
                         at indexPath: IndexPath){
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        showVideoDetails(item)
    }
    
    func goToTop(){
        if (viewModel.data.count == 0)
        {
            return
        }
        
        let indexPath = NSIndexPath.init(row: 0, section: 0)
        
        if(self.tableView?.indexPathsForVisibleRows?.contains(indexPath as IndexPath) == false)
        {
            self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.tableView?.setContentOffset(.zero, animated: true)
            }
        }
        
        
    }
}
