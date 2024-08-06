    //
//  HomeViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import GoogleCast
import Reachability
import UserNotifications

class HomeViewController: BaseViewController {
    
    private var homeContext = 1
    @IBOutlet weak var notifyMessageLabel: UILabel!
    @IBOutlet weak var notifyViewTopSpace: NSLayoutConstraint!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var chormeCastButton: GCKUICastButton!
    @IBOutlet weak var bannerGameView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    fileprivate var viewModel: HomeViewModel = HomeViewModel()
    fileprivate var menuViewModel: MenuViewModel = MenuViewModel()
    fileprivate var notiModel: NotificationViewModel = NotificationViewModel()
    fileprivate var groups = [GroupModel]()
    private var notifyModel: NotifyModel?
    
    fileprivate var storedOffset: [Int: CGPoint] = [:]
    let service: FilmService = FilmService()
    let settingService: SettingService = SettingService()
    let notificationService: NotificationServices = NotificationServices()
    var groupModel: GroupModel?
    var model: CategoryModel!
    var currentOffset = kDefaultOffset
    var notifyBarButon: MJBadgeBarButton!
    var reality = Reachability()
    var presenter: FilmDetailPresenterProtocol?
    var isBack: Bool = false
    var typeHome : HomeType = .normalHome  {
        didSet{
            self.getData()
            self.reloadData()
        }
    }
    @IBOutlet weak var gameBottomConstraint: NSLayoutConstraint!
    
    //mark: -- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if #available(iOS 11.0, *) {
        //            let window = UIApplication.shared.keyWindow;
        //            self.gameBottomConstraint.constant = (window?.safeAreaInsets.bottom)!;
        //        } else {
        //            self.gameBottomConstraint.constant = 0;
        //        }
        NotificationCenter.default.addObserver(self, selector: #selector(settingTet), name: NSNotification.Name(rawValue: "NavigationAnimation"), object: nil)
        
        setUpView()
        getData()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.height, height: 30))
        footerView.backgroundColor = UIColor.clear
        self.tableView.tableFooterView = footerView
        
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: Constants.kLoginStatus,
                                          options: [.new],
                                          context: &homeContext)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didReceiceRemoteNotification(_:)),
                                               name: NSNotification.Name.receiveRemoteNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupUpdateNavigation(_:)), name: NSNotification.Name.receiveRemoteUIBarButton, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingTet()
        logViewEvent(Constants.fire_base_home_page, Constants.fire_base_home_page_event)
        setupNavigation()
        getNotifications()
        updateNotificationBadge()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPlayTrailer()
    }
    
    @objc func settingTet() {
        let setting = DataManager.getDefaultSetting()
        if (setting?.popup_tet == "1") {
            setTetPopup()
        }
        
        if (self.bannerGameView != nil) {
            if (setting?.game == "1") {
                self.bannerGameView.isHidden = false
            } else {
                self.bannerGameView.isHidden = true
                banner_close_action(UIButton())
            }
        }
    }
    
    func setTetPopup() {
        
        let tetKey = "BANNER_TET"
        let isShowed = DataManager.boolForKey(tetKey)
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd-MM-yyyy"
        //
        //        let tetDate = DataManager.objectForKey(tetKey) as? String
        //        let currentDate = dateFormatter.string(from: Date())
        
        if (!isShowed) {
            let tetVC = TetBannerViewController.init(nibName: "TetBannerViewController", bundle: nil)
            self.present(tetVC, animated: true, completion: {
                DataManager.save(boolValue: true, forKey: tetKey)
            })
        }
        
    }
    
    func stopPlayTrailer() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotificationType.stopPlayTrailer.value), object: nil)
    }
    
    func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
        let searchBtn : UIButton = UIButton.init(type: .custom)
        searchBtn.setImage(#imageLiteral(resourceName: "icSearch"), for: .normal)
        searchBtn.addTarget(self, action: #selector(itemSearchPressed(_:)), for: .touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: #imageLiteral(resourceName: "icSearch").size.width, height: 30)
        let searchBar = UIBarButtonItem(customView: searchBtn)
        notifyBarButon = UIBarButtonItem.notifyBarItem(target: self, btnAction: #selector(itemNotificationPressed(_:)))
        if DataManager.isLoggedIn() {
            self.navigationItem.setRightBarButtonItems([searchBar, notifyBarButon], animated: false)
        } else {
            self.navigationItem.setRightBarButton(searchBar, animated: false)
        }
    }
    
    @objc override func menuButtonAction(_ sender: UIButton) {
        // todo:
        updateNotificationBadge()
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    @objc func setupUpdateNavigation(_ notification: NSNotification) {
        self.navigationItem.setRightBarButtonItems(nil, animated: false)
        let searchBtn : UIButton = UIButton.init(type: .custom)
        searchBtn.setImage(#imageLiteral(resourceName: "icSearch"), for: .normal)
        searchBtn.addTarget(self, action: #selector(itemSearchPressed(_:)), for: .touchUpInside)
        searchBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let searchBar = UIBarButtonItem(customView: searchBtn)
        self.navigationItem.setRightBarButton(searchBar, animated: false)
    }
    
    @objc func itemSearchPressed(_ sender: UIButton) {
        stopPlayTrailer()
        self.searchButtonAction(sender)
    }
    
    @objc func itemNotificationPressed(_ sender: UIButton) {
        stopPlayTrailer()
        self.onShowNotifications(sender)
    }
    
    func setUpView() {
        self.navigationItem.titleView = UIView.titleViewItem()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(doRefreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func doRefreshData() {
        self.getNotifications()
        self.getData()
    }
    
    func updateNotificationBadge() {
        let count = notificationService.getUnreadNotificationCount()
        if count > 0 {
            self.notifyBarButon?.badgeValue = "\(count)"
            UIApplication.shared.applicationIconBadgeNumber = count
        } else {
            self.notifyBarButon?.badgeValue = ""
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    //mark: --@IBAction
    
    func onShowNotifications(_ sender: UIButton) {
        let viewcontroller = NotificationViewController.initWithNib()
        viewcontroller.isBack = isBack
        navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
    @objc func didReceiceRemoteNotification(_ notify: NSNotification) {
        notifyModel = notify.object as? NotifyModel
        if let model = notifyModel {
            print("go Notifi from home")
            if model.contentType  == .category || model.contentType == .collection {
                self.didReceiveCateNoti(id: model.partId,type: model.contentType, model: model)
            }else{
                FilmDetailWireFrame.presentFilmDetailModule(self, film: model.parentId, part: model.partId, noti: true, sendView: true)
            }
        }
        
    }
    func didReceiveCateNoti (id : String, type : ContentType , model : NotifyModel) {
        let groupModel = GroupModel(groupId:id, name: model.message)
        let category = CategoryModel(group: groupModel)
        if model.contentType == .collection {
            let groupModel = GroupModel(groupId:model.partId, name: model.message)
            let category = CategoryModel(group: groupModel)
            let viewcontroller = MoreContentViewController(category, fromNoti: true, presentFrom: false, isCollection: true)
            viewcontroller.isFromMenu = true
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else if model.contentType == .category{
            let groupModel = GroupModel(groupId:"category_group_\(model.partId)", name: model.message)
            let category = CategoryModel(group: groupModel)
            let viewcontroller = MoreContentViewController(category, fromNoti: true, presentFrom: false, isCollection: false)
            viewcontroller.isFromMenu = true
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    @IBAction func onClose(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.notifyViewTopSpace.constant = (0 - self.notifyView.bounds.size.height)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    @IBAction func onOpenNotifyDetail(_ sender: Any) {
        if let model = notifyModel {
            if model.contentType  == .category || model.contentType == .collection {
                self.didReceiveCateNoti(id: model.partId,type: model.contentType, model: model)
            }else{
                onClose(sender)
                FilmDetailWireFrame.presentFilmDetailModule(self, film: model.parentId, part: model.partId, noti: true, sendView: true)
            }
        }
    }
    
    @IBAction func onOpenChormeCast(_ sender: Any) {
        
    }
    
    //mark: -- private functions
    func viewMoreContent(index: Int) {
        let groupModel = groups[index]
        if groupModel.blockType == .watching {
            let category = CategoryModel(group: groupModel)
            let viewcontroller = MyListWatchingViewController(category)
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        } else {
            let category = CategoryModel(group: groupModel)
            let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: true, isCollection: true)
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    func getData() {
        showHud()
        service.cancelAllRequests()
        switch typeHome {
        case .normalHome:
            self.getHomeFilm()
            break
        case .oddFilm :
            self.getOddFilm()
            break
        case .seariesFilm :
            self.getSeasonFilm()
            break
        default:
            self.getHomeFilm()
            break
        }
        
    }
    func getSeasonFilm(){
        service.getSeriesFilm { (result, error,serriesModel ) in
            if error == nil {
                self.groups = result
                self.viewModel = HomeViewModel(result, serriesModel!)
                self.reloadData()
                do {
                    let data = try PropertyListEncoder().encode(result)
                    DataManager.save(object: data, forKey: Constants.kCacheHome)
                } catch {
                    DLog(error.localizedDescription)
                }
            } else {
                if let homeCache = DataManager.objectForKey(Constants.kCacheHome) as? Data {
                    do {
                        let groupModels = try PropertyListDecoder().decode([GroupModel].self, from: homeCache)
                        self.groups = groupModels
                        self.viewModel = HomeViewModel(groupModels)
                        self.reloadData()
                    } catch {
                        DLog(error.localizedDescription)
                    }
                }
                self.toast((error?.localizedDescription)!)
            }
            self.refreshControl.endRefreshing()
            self.hideHude()
        }
    }
    func getOddFilm(){
        service.getOddFilm { (result, error) in
            if error == nil {
                self.groups = result
                self.viewModel = HomeViewModel(result)
                self.reloadData()
                do {
                    let data = try PropertyListEncoder().encode(result)
                    DataManager.save(object: data, forKey: Constants.kCacheHome)
                } catch {
                    DLog(error.localizedDescription)
                }
            } else {
                if let homeCache = DataManager.objectForKey(Constants.kCacheHome) as? Data {
                    do {
                        let groupModels = try PropertyListDecoder().decode([GroupModel].self, from: homeCache)
                        self.groups = groupModels
                        self.viewModel = HomeViewModel(groupModels)
                        self.reloadData()
                    } catch {
                        DLog(error.localizedDescription)
                    }
                }
                self.toast((error?.localizedDescription)!)
            }
            self.refreshControl.endRefreshing()
            self.hideHude()
        }
    }
    func getHomeFilm(){
        service.getHomeFilm { (result, error) in
            if error == nil {
                self.groups = result
                self.viewModel = HomeViewModel(result)
                self.reloadData()
                do {
                    let data = try PropertyListEncoder().encode(result)
                    DataManager.save(object: data, forKey: Constants.kCacheHome)
                } catch {
                    DLog(error.localizedDescription)
                }
            } else {
                if let homeCache = DataManager.objectForKey(Constants.kCacheHome) as? Data {
                    do {
                        let groupModels = try PropertyListDecoder().decode([GroupModel].self, from: homeCache)
                        self.groups = groupModels
                        self.viewModel = HomeViewModel(groupModels)
                        self.reloadData()
                    } catch {
                        DLog(error.localizedDescription)
                    }
                }
                self.toast((error?.localizedDescription)!)
            }
            self.refreshControl.endRefreshing()
            self.hideHude()
        }
    }
    func getNotifications() {
        if DataManager.isLoggedIn() {
            settingService.listNotification { (result, error) in
                if error == nil {
                    self.notiModel = NotificationViewModel(result)
                    if self.menuViewModel.listNotification.first ==  nil {
                        for i in result {
                            self.notificationService.saveNotify(i)
                            self.updateNotificationBadge()
                        }
                    } else if result.count > self.menuViewModel.listNotification.count || result.count < self.menuViewModel.listNotification.count {
                        for i in result {
                            self.notificationService.saveNotify(i)
                            self.updateNotificationBadge()
                        }
                    }
                } else {
                    //self.toast((error?.localizedDescription)!)
                }
            }
        }
    }
    
    func getMoreData(offset: Int, limit: Int) {
        DLog("getMoreData")
    }
    
    func reloadData() {
        for section in (viewModel.sections) {
            tableView.register(UINib(nibName: section.identifier, bundle: Bundle.main),
                               forCellReuseIdentifier: section.identifier)
        }
        storedOffset.removeAll()
        tableView?.reloadData()
    }
    
    // MARK: - - banner game
    @IBAction func banner_action(_ sender: Any) {
        if DataManager.isLoggedIn() == false {
            LoginViewController.performLogin(fromViewController: self)
            return
        }
        
        self.getGamerUrl()
    }
    
    @IBAction func banner_close_action(_ sender: Any) {
        self.bannerGameView.removeFromSuperview()
    }
    
    func getGamerUrl() {
        showHud()
        settingService.getGamerUrl(completion: { (gamerUrl, error) -> (Void) in
            print(gamerUrl)
            if error == nil {
                let gameVC = GameViewController.init(nibName: "GameViewController", bundle: nil)
                gameVC.gameUrl = gamerUrl
                self.present(gameVC, animated: true, completion: {
                    
                })
            } else {
                self.toast((error?.localizedDescription)!)
            }
            self.hideHude()
        })
    }
    
    // MARK: - - obser value for keypath
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == &homeContext {
            accessTokenDidChanged()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: 
    /*
     *  USER's access token did changed. may be logout/ login
     *  sub classes can override this method to implement their own business
     */
    func accessTokenDidChanged() {
        getData()
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: Constants.kLoginStatus, context: &homeContext)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.receiveRemoteNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = viewModel.sections[indexPath.section].identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let sectionModel = viewModel.sections[indexPath.section]
        if sectionModel.blockType == .series {
            (cell as! SeriesTableViewCell).bindingWith(sectionModel)
             (cell as! SeriesTableViewCell).layoutIfNeeded()
            (cell as! SeriesTableViewCell).delegate = self
        }else{
            (cell as! CollectionTableViewCell).delegate = self
            (cell as! CollectionTableViewCell).bindingWith(sectionModel)
            
            if sectionModel.blockType != .banner {
                if let offset = storedOffset[indexPath.section] {
                    (cell as! CollectionTableViewCell).setCollectionViewOffset(offset)
                } else {
                    (cell as! CollectionTableViewCell).setCollectionViewOffset(CGPoint.zero)
                }
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionModel = viewModel.sections[indexPath.section]
        if sectionModel.blockType == .series {
            return UITableView.automaticDimension
        }else{
            return sectionModel.sizeForSection().height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionModel = viewModel.sections[section]
        if sectionModel.blockType == .banner {
            return 0.01
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = viewModel.sections[section]
        if sectionModel.showHeader() {
            let view = SectionHeaderView.dequeueReuseHeaderWithNib(in: tableView,
                                                                   reuseIdentifier: SectionHeaderView.nibName())
            view.bindingWith(sectionModel)
            
            view.delegate = self
            weak var wself = self
            view.viewAllClosure = {(_ sender: Any) in
                wself?.viewMoreContent(index: section)
            }
            return view
        } else {
            let view = UIView(frame: CGRect.zero)
            view.backgroundColor = UIColor.clear
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = UIColor.clear
        return view
    }
}

extension HomeViewController: CollectionTableViewCellDelegate {
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectItemAtIndex index: Int, film: FilmModel?) {
        if let indexPath = tableView.indexPath(for: cell) {
            let group = groups[indexPath.section]
            
            switch group.blockType {
            case .watching:
                if let mFilm = film {
                    if GCKCastContext.sharedInstance().castState == .connected {
                        // show detail view when
                        FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
                        
                        /*
                         self.showHud()
                         service.getPlaylistStream(playListID: mFilm.id, videoID: mFilm.partId, profileID: nil) { (_ result) in
                         self.hideHude()
                         switch result {
                         case .success(let streamModel):
                         let stream = streamModel as! StreamModel
                         let errorCode = stream.errorCode
                         
                         if (errorCode == .success && URL(string: stream.urlStreaming) != nil) {
                         FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm)
                         } else {
                         self.showAlertToDetail(mFilm)
                         }
                         break
                         case .failure(let error):
                         self.toast(error.localizedDescription)
                         break
                         }
                         }
                         */
                    } else {
                        if let userModel = DataManager.getCurrentMemberModel() {
                            if userModel.msisdn.isEmpty {
                                AuthorizeLinkAccountViewController.performLinkPhoneNumber(fromViewController: self)
                            } else {
                                self.showHud()
                                service.getPlaylist(playListID: mFilm.id, videoID: mFilm.partId, profileID: nil, noti: false, sendNoti: false) { (_ result) in
                                    self.hideHude()
                                    switch result {
                                    case .success(let playListModel):
                                        let playList = playListModel as! PlayListModel
                                        let errorCode = playList.stream.errorCode
                                        
                                        if (errorCode == .success && URL(string: playList.stream.urlStreaming) != nil) {
                                            
                                            let filter = ContentLevel(rawValue: playList.detail.contentFilter) ?? .all
                                            let pinModel = DataManager.getPinModel()
                                            if pinModel.isOn && pinModel.contentLevel.intValue() < filter.intValue() {
                                                ConfirmPINViewController.showConfirmPIN(fromViewController: self,
                                                                                        sender: nil,
                                                                                        complete: { () -> (Void) in
                                                                                            PlayerWireFrame.presentPlayerModule(self, filmModel: mFilm,fromNoti: true, sendView: false)
                                                                                        }, cancel: nil)
                                            } else {
                                                PlayerWireFrame.presentPlayerModule(self, filmModel: mFilm, fromNoti: false, sendView: false)
                                            }
                                        } else {
                                            //                                                self.showAlertToDetail(mFilm)
                                            FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
                                        }
                                        break
                                    case .failure(let error):
                                        self.toast(error.localizedDescription)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            case .comingsoon:
                break
            case .banner:
                
                if let mFilm = film {
                    
                    if mFilm.link.count > 0 {
                        
                        if let url = URL(string: mFilm.link), UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.openURL(url)
                        }
                        
                        return
                    }
                    
                    if mFilm.contentType == .game {
                        self.banner_action(UIButton())
                        
                        return
                    }
                    
                    stopPlayTrailer()
                    FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
                }
                
                break
            default:
                if let mFilm = film {
                    stopPlayTrailer()
                    FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
                }
                break
            }
        }
    }
    
    func showAlertToDetail(_ film: FilmModel) {
        let alertView = UIAlertController(title: String.rentFilm,
                                          message: String.chuyen_ve_man_hinh_chi_tiet_film,
                                          preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: String.huy, style: .cancel) { (_) in
            
        }
        alertView.addAction(cancelAction)
        let registerPackageAction = UIAlertAction(title: String.dong_y, style: .default) { (_) in
            FilmDetailWireFrame.presentFilmDetailModule(self, film: film, noti: false, sendView: false)
        }
        alertView.addAction(registerPackageAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectViewInfoItemAtIndex index: Int, film: FilmModel?) {
        if let indexPath = tableView.indexPath(for: cell) {
            let group = groups[indexPath.section]
            if group.blockType != .comingsoon, let mFilm = film {
                FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
            }
        }
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didScroll scrollView: UIScrollView) {
        let indexPath = tableView.indexPath(for: cell)
        if let path = indexPath {
            storedOffset[path.section] = scrollView.contentOffset
        }
        weak var wself = self
        tableView.addInfiniteScrolling {
            let offset = (wself?.currentOffset)! + kDefaultLimit
            wself?.getMoreData(offset: offset, limit: kDefaultLimit)
        }
        tableView.showsInfiniteScrolling = false
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectAddSeeLate index: Int) {
        if DataManager.isLoggedIn() == false {
            LoginViewController.performLogin(fromViewController: self)
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        weak var weakSelf = self
        let section = viewModel.sections[indexPath.section]
        let row = section.rows[index]
        service.addFilmToMyList(id: row.id, completion: { (isAdd: Bool, err: NSError?) in
            if err == nil {
                weakSelf?.getData()
            } else if let errStr = err?.localizedDescription {
                weakSelf?.toast(errStr)
            }
        })
        DLog("xem sau")
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, playTrailer index: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let section = viewModel.sections[indexPath.section]
        let row = section.rows[index]
        self.doGetTrailer(row)
    }
    
    func doGetTrailer(_ item: RowModel) {
        weak var weakSelf = self
        service.getVideoTrailer(ItemId: "\(item.trailer)") { (result) in
            switch result {
            case .success(let _videotrailerModel):
                if let streanModel = _videotrailerModel as? StreamModel {
                    weakSelf?.stopPlayTrailer()
                    weakSelf?.doPlayTrailer(streanModel, item.title)
                }
            case .failure(let err):
                weakSelf?.toast(err.localizedDescription)
                break
            }
        }
    }
    
    func doPlayTrailer(_ item: StreamModel, _ title: String?) {
        DLog("play trailer")
        PlayerWireFrame.presentPlayerModule(self, trailer: nil, trailerStream: item, title: title)
    }
    
    func collectionTableViewCell(_ cell: CollectionTableViewCell, setVolume index: Int) {
        DLog("play volume")
    }
}

    extension HomeViewController : headerDelegate{
        func getMoreContent(id: String, name: String, model: NotifyModel?) {
//            let groupModel = GroupModel(groupId:id, name: model?.message ?? "")
//            let category = CategoryModel(group: groupModel)
//            let viewcontroller = GetMoreCollectionViewController(category, fromNoti: false)
//            viewcontroller.nameCollection = name
//            viewcontroller.movieType = self.typeHome
//            self.navigationController?.pushViewController(viewcontroller, animated: true)
            let groupModel = GroupModel(groupId:id, name: name)
            let category = CategoryModel(group: groupModel)
            let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: false, isCollection: true)
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    
    
}
extension HomeViewController : getDetailFilm{
    func getDetailFilm(mFilm: FilmModel) {
            stopPlayTrailer()
        FilmDetailWireFrame.presentFilmDetailModule(self, film: mFilm, noti: false, sendView: false)
    }
}
