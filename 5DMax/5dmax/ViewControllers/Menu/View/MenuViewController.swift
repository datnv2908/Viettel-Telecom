//
//  MenuViewController.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var menuContext = 2
    fileprivate var viewModel = MenuViewModel()
    var notiModel = NotificationViewModel()
    var notiServices: NotificationServices = NotificationServices()
    var groups = [GroupModel]()
    var selectedMenuIndex: MenuType = .home
    var isBack: Bool = true
//    MyListWatchLaterViewController//
    lazy var profileVC = SetupViewController.initWithNib()
    let homeVC = HomeViewController.initWithNib()
    lazy var notifyViewController = NotificationViewController.initWithNib()
    lazy var homeNav = BaseNavigationViewController(rootViewController: HomeViewController.initWithNib())
    lazy var myFilmVC = MyListWatchLaterViewController(CategoryModel(.myList))
    lazy var seriesNav = BaseNavigationViewController(rootViewController: FilmContainerConfiguration.initContainer(.series))
    lazy var notiNav = BaseNavigationViewController(rootViewController: NotificationViewController.initWithNib())
    lazy var packofDataNav = BaseNavigationViewController(rootViewController: PackofDataViewController.initWithNib())
    lazy var chargesFilmVC = MyListWatchLaterViewController(CategoryModel(.filmRetail))
    lazy var downloadNav = BaseNavigationViewController(rootViewController: DownloadViewController.initWithNib())
    lazy var loginNav = BaseNavigationViewController(rootViewController: LoginViewController.initWithNib())
    let login = LoginViewController.initWithNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        for section in viewModel.sections {
            tableView.register(UINib(nibName: section.identifier, bundle: nil),
                               forCellReuseIdentifier: section.identifier)
        }
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: Constants.kLoginStatus,
                                          options: [.new, .old],
                                          context: &menuContext)
        view.backgroundColor = AppColor.darkGrey()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.endUpdates()
        refreshData()
        setupViewMenu()
        getNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateBadgeNumber()
    }

    func updateBadgeNumber() {
        let count = notiServices.getUnreadNotificationCount()
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    // MARK: - - obser value for keypath
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == &menuContext {
            let oldValue = change?[.oldKey] as? String ?? ""
            let newValue = change?[.newKey] as? String ?? ""
            if oldValue != newValue {
                accessTokenDidChanged()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setupViewMenu() {
        if DataManager.isLoggedIn() {
            if selectedMenuIndex == .profile {
                self.mm_drawerController.centerViewController = BaseNavigationViewController(rootViewController: profileVC)
            } else if selectedMenuIndex == .watchLater {
                self.selectedMenuIndex = .watchLater
                myFilmVC.title = self.selectedMenuIndex.displayString()
                self.mm_drawerController.centerViewController = BaseNavigationViewController(rootViewController: myFilmVC)
            }
        }
    }
    
    func getNotifications() {
        let service: SettingService = SettingService()
        if DataManager.isLoggedIn() {
            service.listNotification { (result, error) in
                if error == nil {
                    self.viewModel.numberNotification = String(result.count)
                    self.notiModel = NotificationViewModel(result)
                    for i in result {
                        self.notiServices.saveNotify(i)
                    }
                    self.tableView.reloadData()
                } else {
                    self.toast((error?.localizedDescription)!)
                }
            }
        }
    }
    
    func refreshData() {
        let listNotification = self.notiServices.getUnreadNotification()
        viewModel.listNotification = listNotification
        viewModel.doReloadMenuData()
        self.tableView.reloadData()
    }
    
    func accessTokenDidChanged() {
        viewModel = MenuViewModel()
        self.mm_drawerController.closeDrawer(animated: true, completion: nil)
    }

    func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.notificationBarItem(
            target: self, btnAction: #selector(notificationButtonAction(_ :)))
        self.navigationItem.titleView = UIView.titleViewItem()
        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }
    
    @objc override func menuButtonAction(_ sender: UIButton) {
        // todo:
        self.dismiss(animated: true, completion: nil)
    }

    @objc func notificationButtonAction(_ sender: UIButton) {
        // todo:

    }

    func onSelectHeader() {
        if DataManager.isLoggedIn() {
            self.mm_drawerController.centerViewController = BaseNavigationViewController(rootViewController: profileVC)
            self.mm_drawerController.toggle(.left, animated: true, completion: nil)
        } else {
            LoginViewController.performLogin(fromViewController: self)
        }
    }

    func onSelectNotification() {
        (self.mm_drawerController.centerViewController as? UINavigationController)?.pushViewController(
            notifyViewController, animated: true)
        self.mm_drawerController.closeDrawer(animated: true, completion: nil)
    }

    func showHome() {
        let homeNav = BaseNavigationViewController(rootViewController: HomeViewController.initWithNib())
        self.mm_drawerController.centerViewController = homeNav
        self.mm_drawerController.closeDrawer(animated: true, completion: nil)
    }

    func showCategory() {
        let vc = ListCategoryViewController.initWithType(.retail)
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: Constants.kLoginStatus, context: &menuContext)
        DLog("")
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var sectionModel = viewModel.sections[indexPath.section]
        if sectionModel.rows.indices.contains(indexPath.row) {
            let rowModel = sectionModel.rows[indexPath.row]
            return rowModel.menuType == .notification ? 80.0 : 44.0
        }
        return 0.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var sectionModel = viewModel.sections[indexPath.section]
        if sectionModel.rows.indices.contains(indexPath.row) {
            let rowModel = sectionModel.rows[indexPath.row]
            let model = sectionModel.rows[indexPath.row]
            
            if model.menuType == .notification {
                let cellNotify = NotificationTableViewCell.dequeueReuseCellWithNib(in: tableView, reuseIdentifier: NotificationTableViewCell.nibName())
                let notification = viewModel.getNotification(indexPath.row)
                cellNotify.billData2(model: notification)
                return cellNotify
            }  else {
                let cell = tableView.dequeueReusableCell(withIdentifier: sectionModel.identifier, for: indexPath) as! MenuTableViewCell
                if DataManager.isLoggedIn() {
                    if model.menuType == .notificationHeader {
                        let noti = viewModel.listNotification
                        cell.checkStatus(noti)
                    }
                } else {
                    cell.statusView.backgroundColor = .clear
                }
                let isSelected = (model.menuType == selectedMenuIndex) ? true : false
                cell.setSelectedCell(isSelected)
                cell.bindingData(rowModel)
                cell.topView.isHidden = indexPath.section == 0 ? true : false
                return cell
            }
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionModel = viewModel.sections[indexPath.section]
        let rowModel = sectionModel.rows[indexPath.row]
        
        switch rowModel.menuType {
        case .notificationHeader:
            let notivc = NotificationViewController.initWithNib()
            notivc.isBack = isBack
            self.mm_drawerController.centerViewController = notiNav
            selectedMenuIndex = rowModel.menuType
            break
        case .notification:
            let notification = viewModel.getNotification(indexPath.row)
            if notification.isRead == false {
                let notificationObject = NotificationObject()
                notificationObject.initalize(from: notification)
                notificationObject.isRead = true
                notiServices.updateNotificationObjectReaded(notificationObject)
            }
            let model =  viewModel.getNotification(indexPath.row)
            if let centerVC = self.mm_drawerController.centerViewController {
                if model.type == .collection {
                    let groupModel = GroupModel(groupId:model.id, name: model.message)
                    let category = CategoryModel(group: groupModel)
                    let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: true, isCollection: true)
                    viewcontroller.isFromMenu = true
                    viewcontroller.modalPresentationStyle = .fullScreen
                    centerVC.present(viewcontroller, animated: true, completion: nil)
                    
                }else if model.type == .category{
                    let groupModel = GroupModel(groupId:"category_group_\(model.id)", name: model.message)
                    let category = CategoryModel(group: groupModel)
                    let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: true, isCollection: false)
                    viewcontroller.isFromMenu = true
                    viewcontroller.modalPresentationStyle = .fullScreen
                    centerVC.present(viewcontroller, animated: true, completion: nil)
                }else{
                    FilmDetailWireFrame.presentFilmDetailModule(centerVC,
                                                                film: model.id, part: model.id, noti: true, sendView: true)
                    
                }
            }
            selectedMenuIndex = rowModel.menuType
            break
        
        case .home:
            let homeNav = BaseNavigationViewController(rootViewController: HomeViewController.initWithNib())
            self.mm_drawerController.centerViewController = homeNav
            homeVC.typeHome = .normalHome
            homeVC.reloadData()
            selectedMenuIndex = rowModel.menuType
            break
        case .charges:
            chargesFilmVC.title = rowModel.menuType.displayString()
            self.mm_drawerController.centerViewController = BaseNavigationViewController(rootViewController: chargesFilmVC)
            selectedMenuIndex = rowModel.menuType
            break
        case .kind:
            showCategory()
            return
        case .watchLater:
            if DataManager.isLoggedIn() {
                selectedMenuIndex = rowModel.menuType
                myFilmVC.title = rowModel.menuType.displayString()
                self.mm_drawerController.centerViewController = BaseNavigationViewController(rootViewController: myFilmVC)
            } else {
                present(loginNav, animated: true, completion: nil)
            }
        case .download:
            self.mm_drawerController.centerViewController = downloadNav
            selectedMenuIndex = rowModel.menuType
            break
        case .package:
            self.mm_drawerController.centerViewController = packofDataNav
            selectedMenuIndex = rowModel.menuType
            break
        case .newUpdate:
            let newUpdateVC = NewUpdateViewController.init(title: rowModel.title, playID: "\(rowModel.id)")
            let nav = BaseNavigationViewController(rootViewController: newUpdateVC)
            self.mm_drawerController.centerViewController = nav
            selectedMenuIndex = rowModel.menuType
            break
        case .profile:
            profileVC.isTitle = String.tai_khoan
            if DataManager.isLoggedIn() {
                selectedMenuIndex = rowModel.menuType
                self.mm_drawerController.centerViewController = BaseNavigationViewController(rootViewController: profileVC)
                break
            } else {
                LoginViewController.performLogin(fromViewController: self)
                break
            }
        case .termCondition:
            selectedMenuIndex = rowModel.menuType
            let setting = DataManager.getDefaultSetting()
            let htmlContent = setting?.getHTMLWithType(contenType: .termCondition)
            let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.dieu_khoan)
            let viewHtmlNav = BaseNavigationViewController(rootViewController: viewController)
            viewController.isBack = isBack
            self.mm_drawerController.centerViewController = viewHtmlNav
            break
        case .language:
            selectedMenuIndex = rowModel.menuType
            let viewController = SelectLanguageViewController.initWithNib()
            let viewControllerNav = BaseNavigationViewController(rootViewController: viewController)
            self.mm_drawerController.centerViewController = viewControllerNav
            break
        case .contact:
            selectedMenuIndex = rowModel.menuType
            let setting = DataManager.getDefaultSetting()
            let htmlContent = setting?.getHTMLWithType(contenType: .contact)
            let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.ho_tro)
            let viewHtmlNav = BaseNavigationViewController(rootViewController: viewController)
            viewController.isBack = isBack
            self.mm_drawerController.centerViewController = viewHtmlNav
            break
        case .logout:
//            let fromViewController = ListPricePopupViewController.init(title: "", message: "")
//            fromViewController.view.backgroundColor = .clear
//            fromViewController.titleLabel.text = ""
//            fromViewController.desLabel.text = String.logoutConfirmMsg
//            fromViewController.confirmDialog = {(_ ) in
                Constants.appDelegate.doLogout()
                NotificationCenter.default.post(name: NSNotification.Name.receiveRemoteUIBarButton, object: nil)
                self.selectedMenuIndex = .home
//                self.doShowRateAppPopup()
                UIApplication.shared.applicationIconBadgeNumber = 0
//            }
//            
//            if let vc = appDelegate?.window?.rootViewController {
//                vc.present(fromViewController, animated: true, completion: nil)
//            }
            break
        case .oddMovie:
            let vc = HomeViewController.initWithNib()
            vc.typeHome = .oddFilm
            vc.reloadData()
            let homeNav = BaseNavigationViewController(rootViewController: vc)
            self.mm_drawerController.centerViewController = homeNav
            
            selectedMenuIndex = rowModel.menuType
            break
        case .seriesMovie:
           let vc = HomeViewController.initWithNib()
            vc.typeHome = .seariesFilm
            vc.reloadData()
            let homeNav = BaseNavigationViewController(rootViewController: vc)
            self.mm_drawerController.centerViewController = homeNav
             selectedMenuIndex = rowModel.menuType
        }
        
        tableView.reloadData()
        if rowModel.menuType != .logout {
            self.mm_drawerController.toggle(.left, animated: true, completion: nil)
        }
    }
    
    func doShowRateAppPopup() {
        DispatchQueue.main.async {
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
            let title = String.danh_gia_ung_dung
            let message = "\(String.ban_co_muon_danh_gia_ung_dung) \(appName)?"
            let fromViewController = ListPricePopupViewController.init(title: title, message: message)
            fromViewController.view.backgroundColor = .clear
            fromViewController.confirmDialog = {(_ ) in
                if let fbURLWeb = URL(string: "itms-apps://itunes.apple.com/app/id1239253794") {
                    if(UIApplication.shared.canOpenURL(fbURLWeb)){
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(fbURLWeb, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(fbURLWeb)
                        }
                    }
                }
            }
            
            if let vc = appDelegate?.window?.rootViewController {
                vc.present(fromViewController, animated: true, completion: nil)
            }
        }
    }
}

extension MenuViewController: NotificationServicesDelegate {
    func didUpdateNotifi(in: NotificationServices, model: NotificationObject) {
        refreshData()
    }
}

extension MenuViewController: ListCategoryViewControllerDelegate {
    func didSelectCountry(viewController: ListCategoryViewController, category: CategoryModel) {
        selectedMenuIndex = .kind
        self.tableView.reloadData()
    }
}
