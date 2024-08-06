//
//  ServicePackageViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI
import FirebasePerformance

class ServicePackageViewController: BaseSimpleTableViewController<PackageModel>, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    let service = AppService()
    var trace: Trace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logScreen(GoogleAnalyticKeys.package.rawValue)
        trace = Performance.startTrace(name:"Goicuoc")
        headerView.backgroundColor = UIColor.setViewColor()
    }
    
    override func setupView() {
        super.setupView()
        self.navigationItem.title = String.package
        UserDefaults.standard.addObserver(self, forKeyPath: Constants.kLoginStatus,
                                          options: [.old, .new],
                                          context: nil)
        refreshData()
        reloadHeaderView()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == Constants.kLoginStatus {
            self.reloadHeaderView()
            self.refreshData()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    func reloadHeaderView() {
        if let model = DataManager.getCurrentMemberModel() {
            if model.msisdn.isEmpty {
                headerViewHeight.constant = 0
                headerView.isHidden = true
            } else {
                headerViewHeight.constant = 40
                headerView.isHidden = false
                phoneNumberLabel.text = "\(String.xin_chao.uperCaseFirst()), \(model.msisdn)"
            }
        } else {
            headerViewHeight.constant = 0
            headerView.isHidden = true
        }
    }

    override func getData(pager: Pager, _ completion: @escaping (Result<APIResponse<[PackageModel]>>) -> Void) {
        service.getPackage { (result) in
            completion(result)
            self.trace?.stop()
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        let titleDict = [NSAttributedString.Key.foregroundColor: UIColor.white,
                         NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
        UINavigationBar.appearance().titleTextAttributes = titleDict
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func convertToRowModel(_ item: PackageModel) -> PBaseRowModel? {
        return ServicePackageRowModel(item)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ServicePackageTableViewCell.nibName(),
                                                 for: indexPath) as! ServicePackageTableViewCell
        let rowModel = viewModel.data[indexPath.row]
        cell.bindingWithModel(rowModel)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: Constants.kLoginStatus)
        service.cancelAllRequests()
    }
}

extension ServicePackageViewController: ServicePackageProtocol {
    func registerButtonTapped(rowModel: ServicePackageRowModel?) {
        guard let model = rowModel else {return}
        if DataManager.isLoggedIn() {
            if(self.isConfirmSms == "1"){
                onRegister(id: model.id)
            }else{
                presentPopupDialog(rowModel: model, index: 0)
            }
        } else {
            performLogin(completion: { (result) in
                
            })
        }
    }
    func unregisterButtonTapped(rowModel: ServicePackageRowModel?) {
        if DataManager.isLoggedIn() {
            guard let model = rowModel else {return}
            presentPopupDialog(rowModel: model, index: 0)
        } else {
            performLogin(completion: { (result) in
                
            })
        }
    }
    
    func presentPopupDialog(rowModel: ServicePackageRowModel, index: Int) {
        let title: String
        let confirmTitle: String
        if rowModel.status == false {
            if index >= rowModel.popup.count {
                onRegister(id: rowModel.id)
                return
            }
            title = index == 0 ? ("\(String.register) \(rowModel.title)") : String.confirmPackageTitle
            confirmTitle = index == 0 ? String.register.uppercased() : String.confirmPackage
        } else {
            if index >= rowModel.popup.count {
                onUnregister(id: rowModel.id)
                return
            }
            title = index == 0 ? ("\(String.cancel) \(rowModel.title)") : String.confirmPackageTitle
            confirmTitle = index == 0 ? String.unregisterPackage.uppercased() : String.confirmPackage
        }
//        let dialog = DialogViewController(title: title,
//                                          message: rowModel.popup[index],
//                                          confirmTitle: confirmTitle,
//                                          cancelTitle: String.cancelPackage)
//        dialog.confirmDialog = {(sender) in
//            self.presentPopupDialog(rowModel: rowModel, index: (index + 1))
//        }
//        presentDialog(dialog, animated: true, completion: nil)
        
        self.showAlert(title: title, message: rowModel.popup[index], okTitle: confirmTitle, onOk: { _ in
            self.presentPopupDialog(rowModel: rowModel, index: (index + 1))
        }, cancelTitle: String.cancelPackage)
    }
    
    func onRegister(id: String) {
        self.showHud()
        service.registerServicePackage(id: id, contentId: "", { (result) in
            switch result {
            case .success(let response):
                self.hideHude()
                if(response.isConfirmSms == "1"){
                    let title: String
                    let confirmTitle: String
                   
                    title = String.register
                    confirmTitle = String.okString.uppercased()
                    
                    let dialog = DialogViewController(title: title,
                                                      message: response.data,
                                                      confirmTitle: confirmTitle,
                                                      cancelTitle: String.cancelPackage,
                                                      isHtmlMessage: true)

                    dialog.confirmDialog = {(sender) in
                        if MFMessageComposeViewController.canSendText() == true {
                            let recipients:[String] = [response.number]

                            let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90(),
                                             NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
                            UINavigationBar.appearance().titleTextAttributes = titleDict

                            let messageController = MFMessageComposeViewController()
                            messageController.messageComposeDelegate  = self
                            messageController.recipients = recipients
                            messageController.body = response.content
                            self.present(messageController, animated: true, completion: nil)
                        } else {
                            //handle text messaging not available
                            self.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
                        }
                    }
                    self.presentDialog(dialog, animated: true, completion: nil)
                }else{
                    self.toast(response.data)
                    self.refreshData()
                }
            case .failure(let error):
                self.handleError(error as NSError, completion: { (result) in
                    if result.isSuccess {
                        self.onRegister(id: id)
                    }
                })
                self.hideHude()
            }
        })
        
        logEventInAppPurchase(packageId:id)
        LoggingRecommend.packageRegisterAction(packageId: id)
    }
    
    func onUnregister(id: String) {
        self.showHud()
        service.unregisterServicePackage(id: id, { (result) in
            switch result {
            case .success(let message):
                guard let message = message as? String else {return}
                self.toast(message)
                self.refreshData()
            case .failure(let error):
                self.handleError(error as NSError, completion: { (result) in
                    if result.isSuccess {
                        self.onUnregister(id: id)
                    }
                })
                self.hideHude()
            }
        })
    }
}
