//
//  ProfileViewController.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import GoogleCast

class ProfileViewController: BaseViewController {
    var profileContext = 5
    @IBOutlet weak var tableView: UITableView!
    internal var viewModel = ProfileViewModel()
    let userService = UserService()
    
    var notificationButton: MIBadgeButton?
    let service = AppService()
    var delegate: BaseHomeSimpleTableViewDelegate!
    var notifyNumber: Int = 0
    var myChannel: ChannelDetailsModel?
    var accountInfo: AccountContractInfor?
    var contract: ContractInfor?
    let appService = CommentServices()
    override func viewDidLoad() {
        super.viewDidLoad()
        logScreen(GoogleAnalyticKeys.profile.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DataManager.isLoggedIn() {
//            navigationItem.title = String.ca_nhan
        } else {
//            navigationItem.title = String.tai_khoan
            Constants.appDelegate.rootTabbarController.openTab(at: .home)
        }
        fetchChannel()
        fetchAccountInfo()
        reloadData()
    }
   override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      self.navigationController?.navigationBar.barTintColor = UIColor.setViewColor()
   }
   override func setupView() {
      tableView.backgroundColor = UIColor.setViewColor()
      tableView.estimatedRowHeight = 44
      tableView.rowHeight = UITableView.automaticDimension        
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: Constants.kLoginStatus,
                                          options: [.initial, .new, .old],
                                          context: &profileContext)
        
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        initNavigationItem()
    }
    func fetchChannel() {
//        if self.myChannel != nil {
//            return
//        }
//        let model = DataManager.getCurrentMemberModel()
//        showHud()
//        userService.getChannelInfor(id: (model?.userId)!)  { (result) in
//            switch result {
//            case .success(let response):
//                self.myChannel = response.data
//                self.tableView.reloadData()
//                break
//            case .failure(let error):
//                self.toast(error.localizedDescription)
//            }
//            self.hideHude()
//        }
    }
    
    func fetchAccountInfo() {
        if self.accountInfo != nil {
            return
        }
        showHud()
        service.getAccountInfoUpload()
            { [weak self] result in
            self?.hideHude()
                switch result {
                case .success(let response):
                    self?.accountInfo = response.data
                    self?.fetchContract()
                    
                case .failure(let error):
                    print(error)
//                    self.handleError(error as NSError, automaticShowError: false, completion: {
//                        (result) in
//                        if result.isSuccess {
//
//                        }
//                    })
                    break
                }
        }
    }
    
    func fetchContract() {
        self.service.getContractCondition()
            { [weak self](result) in
                switch result {
                case .success(let response):
                    self?.contract = response.data
                    self?.tableView.reloadData()
                    break
                case .failure(_):
                    break
                }
        }
    }
    
    func processUpload(contract: AccountContractInfor) {
        Singleton.sharedInstance.isHasVideo = contract.isHasVideo
        Singleton.sharedInstance.userStatus = contract.status
        if(contract.isHasVideo == 0){
            NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
            let selectVideoVC = SelectVideoViewController.initWithNib()
            let nav = BaseNavigationController(rootViewController: selectVideoVC)
            self.present(nav, animated: true, completion: nil)
        }else{
            if(contract.status == 1
                || contract.status == 2){
                NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                let selectVideoVC = SelectVideoViewController.initWithNib()
                let nav = BaseNavigationController(rootViewController: selectVideoVC)
                self.present(nav, animated: true, completion: nil)
            }else{
                let updateInforVC = ContractTermsConditionViewController(false)
                self.navigationController?.pushViewController(updateInforVC, animated: true)
            }
        }
    }
    func processAccountContract(info: AccountContractInfor) {
        if(info.status == 1
            || info.status == 2) {
            if self.contract != nil {
                processContractInfo(contract: self.contract!)
                return
            }
            self.service.getContractCondition()
                { [weak self] (result) in
                    switch result {
                    case .success(let response):
                        self?.processContractInfo(contract: response.data)
                        break
                    case .failure(_):
                        break
                    }
            }
        }else{
            let updateInforVC = ContractTermsConditionViewController(true)
            self.navigationController?.pushViewController(updateInforVC, animated: true)
        }
    }
    func processContractInfo(contract: ContractInfor) {
        switch contract.status {
        case 0:
            let updateInforVC = UpdatePaymentInforViewController(contract)
            self.navigationController?.pushViewController(updateInforVC, animated: true)
        case 1:
            let updateInforVC = ContractPendingViewController(contract.status, reason: contract.reason)
            self.navigationController?.pushViewController(updateInforVC, animated: true)
        case 2:
            let updateInforVC = ContractAcceptViewController.initWithNib()
            self.navigationController?.pushViewController(updateInforVC, animated: true)
        case 3:
            let updateInforVC = ContractTermsConditionViewController(true)
            self.navigationController?.pushViewController(updateInforVC, animated: true)
        default:
            let updateInforVC = ContractTermsConditionViewController(true)
            self.navigationController?.pushViewController(updateInforVC, animated: true)
        }
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
                logoButton.tintColor = UIColor.colorFromHexa("cd2d4b")
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
    
    @objc func uploadButtonClicked() {
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
               }else  if model.isUpLoad == 0{
                  let updateInforVC = ContractTermsConditionViewController(false)
                  self.navigationController?.pushViewController(updateInforVC, animated: true)
                 } else if model.isUpLoad == 1 {
                  self.toast(String.alert_waiting_approve)
                 }else if model.isUpLoad == 4 {
                  self.toast(String.alert_lock_approve)
                 } else if model.isUpLoad == 3 {
                  self.toast(String.alert_revoke_approve)
                 }else{
               service.getAccountInfoUpload()
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
            notifyNumber = count
        } else {
            self.notificationButton?.badgeString = ""
            notifyNumber = 0
        }
    }
    
    func reloadData() {
        for sectionModel in viewModel.sections {
            if let identifier = sectionModel.header.identifier {
                tableView.register(UINib(nibName: identifier, bundle: nil),
                                   forHeaderFooterViewReuseIdentifier: identifier)
            }
            for rowModel in sectionModel.rows {
                tableView.register(UINib(nibName: rowModel.identifier, bundle: nil),
                                   forCellReuseIdentifier: rowModel.identifier)
            }
        }
        tableView.reloadData()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.kLoginStatus {
            accessTokenChanged()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func accessTokenChanged() {
        
        viewModel = ProfileViewModel()
        reloadData()
    }
    
    func confirmLogout() {
//        let dialog = DialogViewController(title: String.logout,
//                                          message: String.logoutConfirmMsg,
//                                          confirmTitle: String.okString,
//                                          cancelTitle: String.cancel)
//        dialog.confirmDialog = { button in
//            self.doLogout()
//            self.tableView.setContentOffset(CGPoint.zero, animated: false)
//        }
//        presentDialog(dialog, animated: true, completion: nil)

        showAlert(title: String.logout, message: String.logoutConfirmMsg, okTitle: String.okString, onOk: { (action) in
            self.doLogout()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        })
        
    }
    
    func doLogout() {
        NotificationCenter.default.post(name: .kShouldClosePlayer, object: nil)
        NotificationCenter.default.post(name: .kNotificationShouldReloadFollow, object: nil, userInfo: nil)
        let service = UserService()

        self.showHud()
        service.logout { (_) in
            self.hideHude()
            self.accountInfo = nil
            self.contract = nil
            self.myChannel = nil
            
            DataManager.clearLoginSession()
            Constants.appDelegate.rootTabbarController.openTab(at: .home)
            NotificationCenter.default.post(name: .kShouldGetNotification, object: nil)
            LoggingRecommend.logoutAction()
        }
    }
    
    func contact() {
        let alert = UIAlertController(title: "", message: String.callConfirm, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: String.okString, style: .default, handler: { (action) in
            guard let number = URL(string: "tel://\(Constants.supportPhone)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                UIApplication.shared.openURL(number)
            }
        }))
        alert.addAction(UIAlertAction(title: String.huy, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: Constants.kLoginStatus)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var rowModel: ProfileRowModel = viewModel.sections[indexPath.section].rows[indexPath.row] as! ProfileRowModel
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier,
                                                 for: indexPath) as! BaseTableViewCell
        if rowModel.type == .bankInfor && (self.contract?.status == 1 || self.contract?.status == 2) {
            rowModel.title = String.payment_infomation
        }
        cell.bindingWithModel(rowModel)
        if let rowModel = viewModel.sections[indexPath.section].rows[indexPath.row] as? ProfileRowModel {
            switch rowModel.type {
            case .myEarning:
                if let cell = cell as? ProfileTableViewCell {
                    cell.seperatorView.isHidden = false
                }
            case .playlist:
                if let cell = cell as? ProfileTableViewCell {
                    cell.seperatorView.isHidden = false
                }
            default:
                if let cell = cell as? ProfileTableViewCell {
                    cell.seperatorView.isHidden = true
                }
                break
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let rowModel = viewModel.sections[indexPath.section].rows[indexPath.row] as? ProfileRowModel {
            if !rowModel.type.open(){
                if !Singleton.sharedInstance.isConnectedInternet{
                    showInternetConnectionError()
                    return
                }
            }
            switch rowModel.type {
            case .myEarning:
                let viewcontroller = EarningViewController.initWithNib()
                navigationController?.pushViewController(viewcontroller, animated: true)
            case .bankInfor:
                if self.accountInfo != nil {
                    processAccountContract(info: self.accountInfo!)
                    return
                }
                service.getAccountInfoUpload()
                    { [weak self](result) in
                        switch result {
                        case .success(let response):
                            self?.processAccountContract(info: response.data)
                        case .failure(let error):
                            self?.handleError(error as NSError, automaticShowError: false, completion: {
                                (result) in
                                if result.isSuccess {
                                    
                                }
                            })
                            break
                        }
                }
            case .playlist:
                let playlistVC = PlaylistViewController.initWithNib()
                navigationController?.pushViewController(playlistVC, animated: true)
            case .download:
                let vc = DownloadViewController.initWithNib()
                navigationController?.pushViewController(vc, animated: true)
            case .watchLater:
                let vc = WatchLaterViewController.initWithNib()
                navigationController?.pushViewController(vc, animated: true)
            case .watchRecently:
                let vc = WatchRecentlyViewController.initWithNib()
                navigationController?.pushViewController(vc, animated: true)
            case .myList:
                let vc = MyListViewController.initWithNib()
                navigationController?.pushViewController(vc, animated: true)
            case .logout:
                self.confirmLogout()
            case .pakage:
                let packageVC = ServicePackageViewController.initWithNib()
                navigationController?.pushViewController(packageVC, animated: true)
            case .settings:
                let settingsStoryboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
                guard let settingsVC =
                    settingsStoryboard.instantiateViewController(withIdentifier: "SettingsViewController")
                        as? SettingsViewController else {return}
                navigationController?.pushViewController(settingsVC, animated: true)
            case .changePassword:
                let changePasswordView = ChangePasswordViewController()
                weak var wself = self
                changePasswordView.completionBlock = {(result) in
                    if !result.isCancelled && result.isSuccess {
                        if let message = result.userInfo?[NSLocalizedDescriptionKey] as? String {
                            wself?.toast(message)
                        }
                    }
                }
                let nav = BaseNavigationController(rootViewController: changePasswordView)
                present(nav, animated: true, completion: nil)
            case .privacy:
                let termOfUseView = TermOfUseViewController.initWithNib()
                navigationController?.pushViewController(termOfUseView, animated: true)
            case .contact:
                self.contact()
//                let contactView = ContactViewController.initWithNib()
//                navigationController?.pushViewController(contactView, animated: true)
            case .present:
                let presentView = PresentViewController.initWithNib()
                navigationController?.pushViewController(presentView, animated: true)
            case .manageComment:
//               let managerView = ManagerCommentViewController.initWithNib()
//               managerView.modalPresentationStyle = .fullScreen
//               self.present(managerView, animated: true, completion: nil)
               self.showHud()
               appService.getCommentForID(status: CommentStatus.all.getId() ) { resurt in
                  switch resurt  {
                  case .success( let respond) :
                     let viewControler = ManagerCommentConfigurator.managerCotroller(listVideoComment: respond.data, curentStatus: .all, fromNoti: false)
                     viewControler.modalPresentationStyle = .fullScreen
                     self.present(viewControler, animated: true, completion: nil)
                     self.hideHude()
                  case .failure(let err) :
                     self.toast(err.localizedDescription)
                     self.hideHude()
                  }
               }
               
              
               
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, LoginProtocol, ProfilePushViewProtocol {
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 264
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionModel = viewModel.sections[section]
        if let identifier = sectionModel.header.identifier {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier)
                as! BaseTableHeaderView
            if let view = view as? ProfileHeaderLogin {
                view.delegate = self
            }
            if let view = view as? ProfileHeaderPersonal {
                if let memberModel = DataManager.getCurrentMemberModel() {
                    view.avatarImageView.kf.setImage(with: URL(string: memberModel.avatarImage),
                                                     placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                                     options: nil,
                                                     progressBlock: nil,
                                                     completionHandler: nil)
                    view.coverImageVIew.kf.setImage(with: URL(string: memberModel.coverImage),
                                                    placeholder: #imageLiteral(resourceName: "bitmap"),
                                                    options: nil,
                                                    progressBlock: nil,
                                                    completionHandler: nil)
                  view.separateView.backgroundColor = UIColor.setViewColor()
//                    view.nameLabel.text = memberModel.msisdn
                    
                    if myChannel != nil {
                       view.nameLabel.text = memberModel.fullName
                    } else if !memberModel.fullName.isEmpty {
                        view.nameLabel.text = memberModel.fullName
                    }
                    
                    if !memberModel.msisdn.isEmpty {
                        view.linkAccountButton.isHidden = true
                    } else {
                        view.linkAccountButton.isHidden = false
                    }
                }
                view.delegate = self
            }
            return view
        } else {
            return nil
        }
    }
    
    func loginButtonTapped() {
        performLogin { (result) in
            
        }
    }
    
    func performLinkAccount() {
        let linkAccountView = LinkAccountViewController.initWithNib()
        weak var wself = self
        linkAccountView.completionBlock = {(result) in
            if !result.isCancelled && result.isSuccess {
                if let message = result.userInfo?[NSLocalizedDescriptionKey] as? String {
                    wself?.toast(message)
                }
            }
        }
        let nav = BaseNavigationController(rootViewController: linkAccountView)
        present(nav, animated: true, completion: nil)
    }
    
    func performEditMyChannel() {
      if !Singleton.sharedInstance.isConnectedInternet {
          showInternetConnectionError()
          return
      }
      guard let currentUser = DataManager.getCurrentMemberModel() else {
          return
      }
      userService.getDetailChannelAndUserEdit(id: currentUser.userId, type: .user) { (result) in
          switch result {
          case .success(let response) :
              let editMyChannelView = UpdateProfileViewController(viewModel:  UpdateProfileViewModel(model: response.data))
              self.navigationController?.pushViewController(editMyChannelView, animated: true)
              break
          case .failure(let err ) :
              self.toast(err.localizedDescription)
              break
          }
      }
    }
    
    func performOpenMyChannel() {
      if !Singleton.sharedInstance.isConnectedInternet {
          showInternetConnectionError()
          return
      }
//        if let model = DataManager.getCurrentMemberModel() {
      //            showChannelDetails(ChannelModel(id: model.userId, name: model.getName(), desc: model.descriptionChannel))
      //        }
      let tabbarController = Constants.appDelegate.rootTabbarController
      tabbarController.playerManager?.minimizePlayerView()
      
      self.showHud()
      let userID = DataManager.getCurrentMemberModel()?.userId
      service.getMutilChannelDetails(userID!,getActiveChannel: .isChannelActive) { [weak self ](result) in
          switch result {
          case .success(let  response) :
              let model = response.data
              let viewcontroller = MyChannelVC()
              viewcontroller.mutilChannelModel = ChannelDetailsModel(model)
              self?.hideHude()
              (tabbarController.tabController.selectedViewController() as? BaseNavigationController)?.pushViewController(viewcontroller, animated: true)
              break
          case .failure(let err) :
              self?.toast(err.localizedDescription)
              self?.hideHude()
              // Todo: lol-for test
//                let viewcontroller = MyChannelVC()
//                var temp = ChannelDetailsModel.init()
//                let chanTemp = MutilChannelModel.init()
//                temp.channels = [chanTemp]
//
//                viewcontroller.mutilChannelModel = temp
//
//                (tabbarController.tabController.selectedViewController() as? BaseNavigationController)?.pushViewController(viewcontroller, animated: true)
              
              break
              
          }
      }
    }
}
