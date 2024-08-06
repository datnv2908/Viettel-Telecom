//
//  SetupViewController.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SetupViewController: BaseViewController {

    private var setupContext = 1
    @IBOutlet weak var tableView: UITableView!
    fileprivate var viewModel = SetupViewModel()
    var service: UserService? = UserService()
    var userDetail: MemberDetailModel?

    var tableHeaderView: SetupHeaderView!
    var tableFooterView: SetupFooterView!
    var isTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        self.navigationItem.title = isTitle
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem.menuBarItem(target: self,
                                        btnAction: #selector(menuButtonAction(_:)))
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem.menuBarItem(target: self,
                                        btnAction: #selector(menuButtonAction(_:)))
        view.backgroundColor = AppColor.grayBackgroundColor()
        self.tableView.register(UINib(nibName: "SetupSectionHeaderView", bundle: Bundle.main),
                                forHeaderFooterViewReuseIdentifier: "SetupSectionHeaderView")
        tableView.register(UINib(nibName: ProfileTableViewCell.nibName(), bundle: Bundle.main),
                           forCellReuseIdentifier: ProfileTableViewCell.nibName())
        tableView.register(UINib(nibName: SetupFacebookTableViewCell.nibName(), bundle: Bundle.main),
                           forCellReuseIdentifier: SetupFacebookTableViewCell.nibName())

        tableView.estimatedRowHeight = 44
        tableView.estimatedSectionFooterHeight = 95
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension

        //Setup header, footer view
        self.tableHeaderView = Bundle.main.loadNibNamed("SetupHeaderView",
                                                        owner: self, options: nil)!.last as? SetupHeaderView
        self.tableHeaderView.delegate = self
        if let package = userDetail?.packages.first {
            self.tableHeaderView.billData(user: viewModel.user(), package: package)
        } else {
            self.tableHeaderView.billData(user: viewModel.user(), package: nil)
        }

        self.tableFooterView = Bundle.main.loadNibNamed("SetupFooterView",
                                                        owner: self, options: nil)!.last as? SetupFooterView
        self.tableFooterView.selectLogoutClosure = {(_ sender: Any) in
            Constants.appDelegate.doLogout()
            NotificationCenter.default.post(name: NSNotification.Name.receiveRemoteUIBarButton, object: nil)
            Constants.appDelegate.showHomePage()
            //                self.doShowRateAppPopup()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        UserDefaults.standard.addObserver(self,
                                          forKeyPath: Constants.kLoginStatus,
                                          options: [.new],
                                          context: &setupContext)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
        performGetMemberDetail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == &setupContext {
            viewModel = SetupViewModel()
            self.tableView.reloadData()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func performGetMemberDetail() {

        weak var weakSelf = self
        service?.performGetProfile(success: { (model: MemberDetailModel) -> (Void) in

            weakSelf?.userDetail = model
            weakSelf?.reloadData()

        }, failse: { (err: String?) -> (Void) in
            if let string = err {
                self.toast(string)
            }
        })
    }

    func reloadData() {
        if let package = userDetail?.packages.first {
            self.tableHeaderView.billData(user: viewModel.user(), package: package)
        } else {
            self.tableHeaderView.billData(user: viewModel.user(), package: nil)
        }
        tableView.reloadData()
    }
}

extension SetupViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel.numberOfRow(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowModel = self.viewModel.cellModel(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: rowModel.identifier, for: indexPath)
        if let profileCell = cell as? ProfileTableViewCell {
            profileCell.bindingWith(rowModel)
        }
        if let facebookCell = cell as? SetupFacebookTableViewCell {
            facebookCell.bindingData()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return tableHeaderView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterView(
                    withIdentifier: "SetupSectionHeaderView") as! SetupSectionHeaderView
            headerView.headerTitleLabel.text = self.viewModel.sectionHeaderTitle(section: section)
            return headerView
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 96
        } else {
            return 46

        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (numberOfSections(in: tableView) - 1) {
            return 160
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == (numberOfSections(in: tableView) - 1) {
            return tableFooterView
        } else {
            return nil
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.viewModel.cellModel(at: indexPath)
        switch model.type {
        case .content:
            let pinModel = DataManager.getPinModel()
            if pinModel.isOn {
                weak var weakSelf = self
                ConfirmPINViewController.showConfirmPIN(fromViewController: self,
                                                        sender: nil,
                                                        complete: { () -> (Void) in
                                                            let viewcontroller =
                                                                ManageContentViewController.initWithNib()
                                                            weakSelf?.navigationController?.pushViewController(
                                                                viewcontroller, animated: true)
                }, cancel: nil)
            } else {
                let viewcontroller = ManageContentViewController.initWithNib()
                navigationController?.pushViewController(viewcontroller, animated: true)
            }
            break
        case .facebook:
            if let model = DataManager.getCurrentMemberModel() {
                if model.msisdn.isEmpty {
                    AuthorizeLinkAccountViewController.performLinkPhoneNumber(fromViewController: self)
                } else {
                    // return
                }
            }
        default:
            if let viewcontroller = model.type.viewcontroller() {
                self.navigationController?.pushViewController(viewcontroller, animated: true)
            }
            break
        }
    }
}

extension SetupViewController: SetupHeaderViewDelegate {

    func headerViewDidSelectRegisterService(headerView: SetupHeaderView?) {
        let viewController = PackofDataViewController.initWithNib()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
