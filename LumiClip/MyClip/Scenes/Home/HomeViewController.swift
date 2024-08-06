//
//  HomeViewController.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit
import SnapKit
import MIBadgeButton_Swift
import GoogleCast

class HomeViewController: BaseViewController {
    
   // @IBOutlet weak var tabbarPagerView: UIView!
    @IBOutlet weak var pageContentView: UIView!
    let service = AppService()
    var viewModel = HomeViewModel()
//    lazy var tabBar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    var viewControllers = [BaseViewController]()
    var playerManager: FWDraggableManager?
    var currentId = ""
    var currentIndex = 0
    var firstTime = false
    var isShowPromotionPopup = false
    var notificationButton: MIBadgeButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        firstTime = true
        logScreen(GoogleAnalyticKeys.home.rawValue)
        LoggingRecommend.viewHomePage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        perform(#selector(showPopupPromotion), with: nil, afterDelay: 1)

        if firstTime {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2), execute: {
                if !DownloadManager.shared.getAllDownloadedVideo().isEmpty && !Singleton.sharedInstance.isConnectedInternet {
                    self.openDownloadedFromHome()
                }
            })
            firstTime = false
        }
      
    }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
   }
   override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      self.navigationController?.navigationBar.barTintColor = UIColor.setViewColor()
   }
   override func setupView() {
      self.addPagerController()
      initNavigationItem()
      setupData()
      automaticallyAdjustsScrollViewInsets = false
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
//            UIApplication.shared.statusBarStyle = .default
            
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
            
//            UIApplication.shared.statusBarStyle = .lightContent
            
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
//            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            searchButton.tintColor = UIColor.colorFromHexa("4a4a4a")
            uploadButton.tintColor = UIColor.colorFromHexa("4a4a4a")
            changeLanguageButton.tintColor = UIColor.colorFromHexa("4a4a4a")
            notificationButton?.tintColor = UIColor.colorFromHexa("4a4a4a")
            castButton.tintColor = UIColor.colorFromHexa("4a4a4a")
//            UIApplication.shared.statusBarStyle = .default
            
            navigationController?.navigationBar.barStyle = UIBarStyle.default
            navigationController?.navigationBar.tintColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.setViewColor()
            let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.blackTitleColor(),
                             NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
            UINavigationBar.appearance().titleTextAttributes = titleDict
        }
        
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView:searchButton), UIBarButtonItem(customView:uploadButton),
//                                              languageBarBtn, UIBarButtonItem(customView:castButton)]
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView:searchButton), UIBarButtonItem(customView:(notificationButton)!), UIBarButtonItem(customView:uploadButton), UIBarButtonItem(customView:changeLanguageButton), UIBarButtonItem(customView:castButton)]
        
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
    
    @objc func uploadButtonClicked(){
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
        if(viewControllers.count > 0){
            let controller = viewControllers[0] as! MainViewController
            if count > 0 {
                self.notificationButton?.badgeString = String(count)
                controller.notifyNumber = count
            } else {
                controller.notifyNumber = 0
                self.notificationButton?.badgeString = ""
            }
        }
    }
    
    func backToMyClipPage() {
        if self.viewModel.data.first != nil {
            self.pagerController.scrollToController(at: 0, animate: true);
            currentId = self.viewModel.data[0].objectId
        }
    }
    
    func goToTop(){
        let controller = viewControllers[0] as! MainViewController
        
        if (controller.viewModel.data.count == 0)
        {
            return
        }
        
        let indexPath = NSIndexPath.init(row: 0, section: 0)
        
        if(controller.tableView?.indexPathsForVisibleRows?.contains(indexPath as IndexPath) == false)
        {
            controller.tableView?.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                controller.tableView?.setContentOffset(.zero, animated: true)
            }
        }
    }
    
    @objc func showPopupPromotion(){
        if let user = DataManager.getCurrentMemberModel() {
            if (user.isShowPromotionAPP == 1
                && user.msisdn.isEmpty == false
                && isShowPromotionPopup == false) {
                isShowPromotionPopup = true;
                let storyboard = UIStoryboard(name: "PopupPromotionController", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PopupPromotionViewController") as! PopupPromotionViewController
                controller.delegate = self
                self.present(controller, animated: true, completion:nil)
            }
        }
    }
    
    func addPagerController() {
        self.pagerController.dataSource = self
        self.pagerController.delegate = self
        self.addChild(self.pagerController)
        pageContentView.addSubview(pagerController.view)
        self.pagerController.didMove(toParent: self)
        pagerController.view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateData() {
        for model in viewModel.data {
            if !viewModel.oldList.contains(where: {$0.objectId == model.objectId}) {
                let vc = ChannelVideosViewController.init(model.objectId)
                vc.delegate = self
                self.viewControllers.append(vc)
            }
        }
        var listVC = [BaseViewController]()
        for model in viewModel.data {
            if let index = viewModel.oldList.index(where: {$0.objectId == model.objectId}) {
                listVC.append(viewControllers[index])
            } else {
                let vc = ChannelVideosViewController.init(model.objectId)
                vc.delegate = self
                listVC.append(vc)
            }
        }
        self.viewControllers = listVC
        for (index, item) in viewModel.data.enumerated() {
            if item.objectId == currentId {
                currentIndex = index
            }
        }
    }
    
    func setupData() {
        let vc = MainViewController.initWithNib()
        viewControllers.append(vc)
    }
}

extension HomeViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func numberOfItemsInPagerTabBar() -> Int {
        return self.viewModel.data.count
    }
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        (cell as? TYTabPagerBarCellProtocol)?.titleLabel.text = self.viewModel.data[index].title
        return cell
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = self.viewModel.data[index].title
        return pagerTabBar.cellWidth(forTitle: title)
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        self.pagerController.scrollToController(at: index, animate: true);
        currentId = self.viewModel.data[index].objectId
    }
}

extension HomeViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return 1;
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = viewControllers[index]
        currentId = self.viewModel.data[index].objectId
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
    }
}

extension HomeViewController: PopupPromotionViewDelegate {
    func registerPromotionAppFinish(message : String) {
        self.toast(message)
        dismiss(animated: true, completion: nil)
    }
}

extension HomeViewController: ChannelVideosViewControllerDelegate {
    func channelVideosViewController(_ viewController: ChannelVideosViewController,
                                     didSelect item: ContentModel,
                                     at indexPath: IndexPath) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        showVideoDetails(item)
    }
}
