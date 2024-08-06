//
//  MyChannelVC.swift
//  UClip
//
//  Created by Toan on 5/18/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class MyChannelVC: BaseViewController, TYPagerControllerDataSource, TYPagerControllerDelegate, TYTabPagerBarDelegate, TYTabPagerBarDataSource {
    
    @IBOutlet weak var tabbarPagerView: UIView!
    @IBOutlet weak var pageContentView: UIView!
   @IBOutlet weak var bgCollectionView: UIView!
   lazy var tabbar = TYTabPagerBar()
    lazy var pagerController = TYPagerController()
    var mutilChannelModel : ChannelDetailsModel!
    var service = ChannelService()
    var viewModel = MyChannelModel()
    var viewControllers = [BaseViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTabPagerBar()
        self.addPagerController()
        
    }
    
    override func setupView() {
        self.title = DataManager.getCurrentMemberModel()?.getName()
        for item in  viewModel.sections {
            if item.identifier == MyChannelEnum.myChannel.rawValue {
                let vc = HomeMyChannelVC()
                vc.channels = mutilChannelModel
                viewControllers.append(vc)
            }else if item.identifier  == MyChannelEnum.videos.rawValue {
                let vc = ChannelDetailsVideosViewController.initWithNib()
                vc.isUser = true
                vc.mutilChannelModel = mutilChannelModel
                viewControllers.append(vc)
            }else if  item.identifier == MyChannelEnum.playList.rawValue {
                let vc = ChannelDetailsPlaylistViewController.initWithNib()
                vc.parentModel = ChannelModel(mutilChannelModel)
                viewControllers.append(vc)
            } else if item.objectId == ChannelSectionEnum.channel.rawValue{
                let vc = MyChannelRelatedViewController.initWithNib()
                vc.channelModel = ChannelModel(mutilChannelModel)
                viewControllers.append(vc)
            } else if item.identifier ==  MyChannelEnum.about.rawValue {
                let vc = ChannelDetailsAboutViewController(ChannelModel(mutilChannelModel))
                vc.isChannel = true
                viewControllers.append(vc)
            }
            //
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewcontrollers = pagerController.visibleControllers {
            for index in viewcontrollers.indices {
                viewcontrollers[index].viewWillAppear(animated)
            }
        }
    }
    func addTabPagerBar() {
        self.tabbar.delegate = self
        self.tabbar.dataSource = self
        self.tabbar.register(TYTabPagerBarCell.classForCoder(),
                             forCellWithReuseIdentifier: NSStringFromClass(TYTabPagerBarCell.classForCoder()))
      
        self.tabbar.layoutIfNeeded()
        self.tabbar.setNeedsLayout()
       self.tabbar.layout.normalTextColor  = UIColor.settitleColor()
        self.tabbar.layout.normalTextFont = SFUIDisplayFont.fontWithType(.regular, size: 13)
        self.tabbar.layout.selectedTextFont = SFUIDisplayFont.fontWithType(.regular, size: 13)
        self.tabbar.layout.selectedTextColor = AppColor.deepSkyBlue90()
        self.tabbar.layout.progressColor = AppColor.deepSkyBlue90()
      bgCollectionView.backgroundColor = UIColor.setViewColor()
        self.tabbarPagerView.backgroundColor = UIColor.setViewColor()
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
    // MARK: - page view
    func numberOfItemsInPagerTabBar() -> Int {
        return viewModel.sections.count
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
    // MARK: - pageViewController
    func numberOfControllersInPagerController() -> Int {
        return viewModel.sections.count
    }
    func pagerController(_ pagerController: TYPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        return viewControllers[index]
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, animated: Bool) {
        self.tabbar.scrollToItem(from: fromIndex, to: toIndex, animate: animated)
    }
    func pagerController(_ pagerController: TYPagerController, transitionFrom fromIndex: Int, to toIndex: Int, progress: CGFloat) {
        self.tabbar.scrollToItem(from: fromIndex, to: toIndex, progress: progress)
    }
}
