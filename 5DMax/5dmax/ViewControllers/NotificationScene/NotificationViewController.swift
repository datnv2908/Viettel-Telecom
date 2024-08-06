//
//  NotificationViewController.swift
//  5dmax
//
//  Created by Os on 4/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol NotificationViewProtocol {
    func refreshView()
}
class NotificationViewController: BaseViewController, NotificationViewProtocol {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var viewModel: NotificationViewModel = NotificationViewModel()
    fileprivate var menuViewModel = MenuViewModel()
    let refreshControl: UIRefreshControl = UIRefreshControl()
    var notificationServices: NotificationServices = NotificationServices()
    let service: SettingService = SettingService()
    var isBack: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        refreshView()
        setupNavigation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        checkPushViewController()
        tableView.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateBadgeNumber()
    }
    
    func checkPushViewController() {
        if isBack {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self, btnAction: #selector(menuButtonNotifyAction(_:)))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.backBarItem(target: self, btnAction: #selector(backBarButton(_:)))
        }
    }
    
    func setupNavigation() {
        self.title = String.thong_bao
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self, btnAction: #selector(menuButtonAction(_:)))
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    @objc func getData() {
        self.showHud()
        weak var weakSelf = self
        service.listNotification { (result, error) in
            if error == nil {
                for i in result {
                    weakSelf?.notificationServices.saveNotify(i)
                }
                weakSelf?.getDataLocal()
            } else {
                weakSelf?.toast((error?.localizedDescription)!)
            }
            weakSelf?.refreshControl.endRefreshing()
            self.hideHude()
        }
    }
    
    func getDataLocal() {
        viewModel.listNotification = self.notificationServices.getNotification()
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func menuButtonNotifyAction(_ sender: UIButton) {
        self.mm_drawerController.toggle(.left, animated: true, completion: nil)
    }
    
    @objc func backBarButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setUpView() {
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func refreshView() {
        refreshControl.endRefreshing()
        self.tableView.reloadData()
    }
    
    func updateBadgeNumber() {
        let count = notificationServices.getUnreadNotificationCount()
        UIApplication.shared.applicationIconBadgeNumber = count
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listNotification.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.getNotifyAtIndexPath(indexPath)
        let cell = NotificationTableViewCell.dequeueReuseCellWithNib(in: tableView, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        cell.billData(model: model)
        
        if model.isRead == false {
            let notificationObject = NotificationObject()
            notificationObject.initalize(from: model)
            notificationObject.isRead = true
            self.notificationServices.updateNotificationObjectReaded(notificationObject)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let model = viewModel.getNotifyAtIndexPath(indexPath)
        let notificationObject = NotificationObject()
        notificationObject.initalize(from: model)
        notificationObject.isRead = true
        self.notificationServices.updateNotificationObjectReaded(notificationObject)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let model = viewModel.getNotifyAtIndexPath(indexPath)
        if model.type == .collection {
            let groupModel = GroupModel(groupId:model.groupId, name: model.name)
            let category = CategoryModel(group: groupModel)
//            let viewcontroller = GetMoreCollectionViewController(category)
            let viewcontroller = MoreContentViewController(category, fromNoti: true,presentFrom: false, isCollection: true)
            viewcontroller.isFromMenu = true
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else if model.type == .category{
            let groupModel = GroupModel(groupId:"category_group_\(model.groupId)", name: model.name)
            let category = CategoryModel(group: groupModel)
            let viewcontroller = MoreContentViewController(category, fromNoti: true)
            viewcontroller.isFromMenu = true
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }else{
        if model.action == .detail {
            FilmDetailWireFrame.presentFilmDetailModule(self, film: model.groupId, part: model.id, noti: true, sendView: true)
        }
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}
