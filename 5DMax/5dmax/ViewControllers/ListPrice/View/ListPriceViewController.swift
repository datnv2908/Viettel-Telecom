//
//  ListPriceViewController.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import MessageUI

protocol ListPriceViewProtocol {

    func refreshView()
    func showSMSConfirm(message: String, number: String, smsContent: String)
}

class ListPriceViewController: BaseViewController, ListPriceViewProtocol, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var presenter: ListPricePresenter? = ListPricePresenter()
    @IBOutlet weak var btnRegister: UIButton!
    var refreshControl: UIRefreshControl? = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        refreshView()
        presenter?.performGetListPrice()
    }

    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
        logViewEvent(Constants.fire_base_package, Constants.fire_base_package_event)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: 
    // MARK: IBACTIONS
    @IBAction func btnRegisterPressed(_ sender: Any) {
        if let userModel = DataManager.getCurrentMemberModel() {
            if userModel.msisdn.isEmpty {
                AuthorizeLinkAccountViewController.performLinkPhoneNumber(fromViewController: self)
            } else {
                if let package = presenter?.viewModel?.selectedPackage {
                    let count = package.popUp.count
                    if count > 0 {
                        showConfirmPopup(package, at: 0)
                    }
                }
            }
        } else {
            LoginViewController.performLogin(fromViewController: self)
        }
    }

    private func showConfirmPopup(_ package: PackageModel, at index: Int) {
        
        if package.status {
            self.presenter?.performRegisterPackage(package, isConfirmSMS: false)
            return
        }
        
        if((presenter?.viewModel?.isRegisterFast)!) {
            self.presenter?.performRegisterPackage(package, isConfirmSMS: (presenter?.viewModel?.isConfirmSMS)!)
        } else {
            if ((presenter?.viewModel?.isConfirmSMS)!) {
                if (package.popUp.count < 1) {
                    self.presenter?.performRegisterPackage(package)
                } else {
                    let title = package.status == true ? String.unregisterSubTitle : String.registerSubTitle
                    let message = package.popUp[index]
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
                        self.presenter?.performRegisterPackage(package, isConfirmSMS: false)
                    }
                    let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    present(alertController, animated: true, completion: nil)
                }
            } else {
                let title = package.status == true ? String.unregisterSubTitle : String.registerSubTitle
                if index >= package.popUp.count {
                    self.presenter?.performRegisterPackage(package, isConfirmSMS: false)
                    return
                }
                let message = package.popUp[index]
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
                    let nextIndex = index + 1
                    self.showConfirmPopup(package, at: nextIndex)
                }
                let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }

    @IBAction func btnChargeVisaPressed(_ sender: Any) {
        presenter?.performChargeVisa()
    }

    // MARK: 
    // MARK: METHODS
    private func setUpView() {
        self.navigationItem.title = presenter?.viewModel?.title
        view.backgroundColor = AppColor.grayBackgroundColor()
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem.menuBarItem(target: self, btnAction: #selector(menuButtonAction(_:)))
        }

        //presenter?.view = self

        tableView.backgroundColor = AppColor.whiteTwo()
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension

        refreshControl?.addTarget(presenter, action: #selector(presenter?.performGetListPrice),
                                  for: UIControl.Event.valueChanged)
        refreshControl?.tintColor = UIColor.black
        tableView?.addSubview(refreshControl!)
    }
    

    // MARK: 
    // MARK: PROTOCOLS
    func refreshView() {
        if let packageSelected = presenter?.viewModel?.selectedPackage {
            btnRegister.isHidden = false
            if packageSelected.status {
                btnRegister.setTitle(String.huy_goi_cuoc.uppercased(), for: UIControl.State.normal)
            } else {
                btnRegister.setTitle(String.dang_ky.uppercased(), for: UIControl.State.normal)
            }
        } else {
            btnRegister.isHidden = true
        }
        self.tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func showSMSConfirm(message: String, number: String, smsContent: String) {
        let alertController = UIAlertController(title: String.registerSubTitle, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
            if MFMessageComposeViewController.canSendText() == true {
                let recipients:[String] = [number]
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate  = self
                messageController.recipients = recipients
                messageController.body = smsContent
                self.present(messageController, animated: true, completion: nil)
            } else {
                //handle text messaging not available
                self.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
            }
        }
        let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.setValue(NSAttributedString(html: message), forKey: "attributedMessage")
        present(alertController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ListPriceViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = presenter?.viewModel {
            return model.getNumberRowInSection(section)
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = PriceTableViewCell.dequeueReuseCellWithNib(in: tableView, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.clear
        if let model = presenter?.viewModel?.getPackageAtIndexPath(indexPath) {
            let selected = presenter?.viewModel?.selectedPackage
            cell.billData(model: model, selectedModel: selected)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.performSelectAtIndexPath(indexPath)
        refreshView()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TitleHeaderView.initWithDefaultNib()
        if let model =  presenter?.viewModel {
             view.lblTitle.text = model.getTitleSection(section)
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        let count = self.tableView(tableView, numberOfRowsInSection: section)
        if count == 0 {
            return 0.01
        }
        return 40.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
