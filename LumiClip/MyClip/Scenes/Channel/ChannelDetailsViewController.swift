//
//  ChannelViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tabbarPagerView: UIView!
    @IBOutlet weak var pageContentView: UIView!
   @IBOutlet weak var bgView: UIView!
   
    @IBOutlet weak var lineView: UIView!
    var viewModel: ChannelViewModel
    lazy var tabbar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    var viewControllers = [BaseViewController]()
    var service = ChannelService()
    let introductVc: ChannelDetailsAboutViewController!
    var channelDetail: ChannelDetailsModel? {
        didSet {
            introductVc.channelDetail = channelDetail
        }
    }
    var isMyChannel : Bool = false
    init(_ model: ChannelModel,isMyChannel : Bool) {
        viewModel = ChannelViewModel(model)
        self.isMyChannel = isMyChannel
        introductVc = ChannelDetailsAboutViewController(model)
        super.init(nibName: "ChannelDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
        lineView.backgroundColor = UIColor.setSeprateViewColor()
        self.addTabPagerBar()
        self.addPagerController()
        reloadData()
        setupData(id: nil, viewModelChannel: viewModel)
        logScreen(GoogleAnalyticKeys.channelDetails.rawValue)
        LoggingRecommend.viewChannelHome(channelId: viewModel.channelModel.id, channelName: viewModel.channelModel.name)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewcontrollers = pagerController.visibleControllers {
            for index in viewcontrollers.indices {
                viewcontrollers[index].viewWillAppear(animated)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = nil
    }

    override func setupView() {
        navigationItem.title = viewModel.channelModel.name
    }
    
    func addTabPagerBar() {
        self.tabbar.delegate = self
        self.tabbar.dataSource = self
        self.tabbar.register(TYTabPagerBarCell.classForCoder(),
                             forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
        self.tabbar.layout.normalTextColor = AppColor.blackTitleColor()
        self.tabbar.layoutIfNeeded()
        self.tabbar.setNeedsLayout()
        self.tabbar.backgroundColor = UIColor.setViewColor()
        self.bgView.backgroundColor = UIColor.setViewColor()
        self.tabbar.layout.normalTextColor = UIColor.settitleColor()
        self.tabbar.layout.normalTextFont = SFUIDisplayFont.fontWithType(.regular, size: 13)
        self.tabbar.layout.selectedTextFont = SFUIDisplayFont.fontWithType(.regular, size: 13)
        self.tabbar.layout.selectedTextColor = AppColor.deepSkyBlue90()
        self.tabbar.layout.progressColor = AppColor.deepSkyBlue90()
        tabbarPagerView.backgroundColor = UIColor.setViewColor()
        tabbarPagerView.addSubview(self.tabbar)
        tabbar.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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
    
    func reloadData() {
        self.tabbar.reloadData()
        self.pagerController.reloadData()
    }
    
    func setupData(id: String?, viewModelChannel : ChannelViewModel) {
      for item in viewModel.sections {
          if item.objectId == ChannelSectionEnum.home.rawValue {
              let model = viewModel.channelModel
              model.isMyChannel = isMyChannel
              let vc = ChannelDetailsHomeViewController(model)
              vc.parentVC = self
              viewControllers.append(vc)
          } else if item.objectId == ChannelSectionEnum.videos.rawValue {
              let vc = ChannelDetailsVideosViewController.initWithNib()
              vc.id = id
              vc.ChannelViewModel = viewModelChannel
              viewControllers.append(vc)
          } else if item.objectId == ChannelSectionEnum.about.rawValue {
              let vc = ChannelDetailsAboutViewController(viewModel.channelModel)
              vc.parentVC = self
              viewControllers.append(vc)
          }
      }
    }
    
    func didSelectWatchMore(id: String) {
        viewControllers = [BaseViewController]()
        setupData(id: id, viewModelChannel: viewModel )
        reloadData()
        self.pagerController.scrollToController(at: 1, animate: true)
    }
    
    func getChannelDetail() {
        
    }
}

extension ChannelDetailsViewController: TYTabPagerBarDataSource, TYTabPagerBarDelegate {
    func pagerTabBar(_ pagerTabBar: TYTabPagerBar, cellForItemAt index: Int) -> UICollectionViewCell & TYTabPagerBarCellProtocol {
        let cell = pagerTabBar.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()), for: index)
        (cell as? TYTabPagerBarCellProtocol)?.titleLabel.text = self.viewModel.sections[index].title
        cell.backgroundColor = UIColor.setViewColor()
      
        return cell
    }
    
    func numberOfItemsInPagerTabBar() -> Int {
        return self.viewModel.sections.count
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

extension ChannelDetailsViewController: TYPagerControllerDataSource, TYPagerControllerDelegate {
    func numberOfControllersInPagerController() -> Int {
        return self.viewModel.sections.count
    }
    
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = viewControllers[index]
        return vc
    }
    
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabbar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabbar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
