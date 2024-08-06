//
//  ChannelViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import GoogleCast

class EventDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tabbarPagerView: UIView!
    @IBOutlet weak var pageContentView: UIView!
    
    var viewModel: EventViewModel
    lazy var tabbar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    var viewControllers = [BaseViewController]()
    let eventService = EventService()
    var notificationButton: MIBadgeButton?
    var selectIndex: Int
    var notifyNumber: Int
    
    init(selectIndex: Int, notifyNumber: Int) {
        self.selectIndex = selectIndex
        self.notifyNumber = notifyNumber
        viewModel = EventViewModel()
        super.init(nibName: "EventDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTabPagerBar()
        self.addPagerController()
        getEventConfig()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewcontrollers = pagerController.visibleControllers {
            for index in viewcontrollers.indices {
                viewcontrollers[index].viewWillAppear(animated)
            }
        }
        initNavigationItem()
    }
    
    func initNavigationItem(){
        let logoButton = UIButton(type:.system)
        logoButton.setImage(#imageLiteral(resourceName: "myclip_blue").withRenderingMode(.alwaysTemplate), for:.normal)
        logoButton.frame = CGRect(x: 0, y: 0, width: 110, height: 27)
        //navigationItem.leftBarButtonItem = UIBarButtonItem(customView:logoButton)
        
        let searchButton = UIButton(type:.system)
        searchButton.setImage(#imageLiteral(resourceName: "iconSearchGray").withRenderingMode(.alwaysOriginal), for:.normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        searchButton.addTarget(self, action:#selector(searchButtonClicked), for: .touchUpInside)
        
        let uploadButton = UIButton(type:.system)
        uploadButton.setImage(#imageLiteral(resourceName: "icDangTai").withRenderingMode(.alwaysOriginal), for:.normal)
        uploadButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        uploadButton.addTarget(self, action:#selector(uploadButtonClicked), for: .touchUpInside)
        
        notificationButton = MIBadgeButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(34), height: CGFloat(34)))
        notificationButton?.setImage(#imageLiteral(resourceName: "icThongBao").withRenderingMode(.alwaysOriginal), for:.normal)
        notificationButton?.badgeEdgeInsets = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 8)
        notificationButton?.badgeTextColor = UIColor.white
        notificationButton?.badgeBackgroundColor = UIColor.red
        notificationButton?.addTarget(self, action:#selector(notifyButtonClicked), for: .touchUpInside)
        updateNotifyNumber()
        
        let castButton = GCKUICastButton(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(34), height: CGFloat(34)))
        castButton.tintColor = UIColor.colorFromHexa("4a4a4a")
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView:searchButton), UIBarButtonItem(customView:(notificationButton)!), UIBarButtonItem(customView:uploadButton), UIBarButtonItem(customView:castButton)]
    
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
        if DataManager.isLoggedIn() {
            eventService.getAccountInfoUpload()
                { (result) in
                    switch result {
                    case .success(let response):
                        NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                        let selectVideoVC = SelectVideoViewController.initWithNib()
                        let nav = BaseNavigationController(rootViewController: selectVideoVC)
                        self.present(nav, animated: true, completion: nil)
                    case .failure(_):
                        let updateInforVC = UpdateAccountInforViewController.initWithNib()
                        self.navigationController?.pushViewController(updateInforVC, animated: true)
                        break
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
    
    func updateNotifyNumber(){
        if notifyNumber > 0 {
            self.notificationButton?.badgeString = String(notifyNumber)
        } else {
            self.notificationButton?.badgeString = ""
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = nil
    }

    override func setupView() {
        
    }
    
    func addTabPagerBar() {
        self.tabbar.delegate = self
        self.tabbar.dataSource = self
        self.tabbar.register(TYTabPagerBarCell.classForCoder(),
                             forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        self.tabbar.layout.normalTextColor = AppColor.blackTitleColor()
        self.tabbar.layoutIfNeeded()
        self.tabbar.setNeedsLayout()
        self.tabbar.layout.normalTextFont = SFUIDisplayFont.fontWithType(.regular, size: 13)
        self.tabbar.layout.selectedTextFont = SFUIDisplayFont.fontWithType(.regular, size: 13)
        self.tabbar.layout.selectedTextColor = AppColor.deepSkyBlue90()
        self.tabbar.layout.progressColor = AppColor.deepSkyBlue90()
        tabbarPagerView.addSubview(self.tabbar)
        tabbar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tabbar.backgroundColor = UIColor.clear
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
    
    func reloadData() {
        self.tabbar.reloadData()
        self.pagerController.reloadData()
    }
    
    func setupData() {
        for item in viewModel.sections {
            if item.objectId == EventEnum.event.rawValue {
                let vc = HomeEventViewController.initWithNib()
                viewControllers.append(vc)
            } else if item.objectId == EventEnum.diemcuatoi.rawValue {
                let vc = MyScoreViewController.initWithNib()
                viewControllers.append(vc)
            } else if item.objectId == EventEnum.thele.rawValue {
                let vc = TermsConditioinViewController(viewModel.eventConfigModel.termsCondition)
                viewControllers.append(vc)
            } else if item.objectId == EventEnum.giaithuong.rawValue{
                let vc = AwardHomeViewController(viewModel.eventConfigModel.startEventDate, viewModel.eventConfigModel.eventMonthRanges)
                viewControllers.append(vc)
            }
        }
        
        self.pagerController.scrollToController(at: selectIndex, animate: true)
    }
    
    func getEventConfig() {
        showHud()
        eventService.getConfig{ (result) in
            switch result {
            case .success(let response):
                self.viewModel.eventConfigModel = response.data
                self.viewControllers = [BaseViewController]()
                self.setupData()
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }
}

extension EventDetailsViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func numberOfItemsInPagerTabBar() -> Int {
        return self.viewModel.sections.count
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        (cell as? TYTabPagerBarCellProtocol)?.titleLabel.text = self.viewModel.sections[index].title
        return cell
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, widthForItemAt index: Int) -> CGFloat {
        let title = self.viewModel.sections[index].title
        self.tabbar.layout.progressWidth = pagerTabBar.cellWidth(forTitle: title)
        return pagerTabBar.cellWidth(forTitle: title) + 10
    }
    
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, didSelectItemAt index: Int) {
        self.pagerController.scrollToController(at: index, animate: true);
        
    }
}

extension EventDetailsViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.viewModel.sections.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = viewControllers[index]
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        if(toIndex == 1){
            if(!DataManager.isLoggedIn()){
                print("from index ", fromIndex)
                self.pagerController.scrollToController(at: fromIndex, animate: true)
                performLogin(completion: { (result) in
                })
                return
            }
        }
        self.tabbar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabbar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
