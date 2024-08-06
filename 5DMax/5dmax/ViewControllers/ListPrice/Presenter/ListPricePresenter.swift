//
//  ListPricePresenter.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListPricePresenter: NSObject {
    var viewModel: ListPriceViewModel? = ListPriceViewModel()
    var interactor: ListPriceInteractor? = ListPriceInteractor()
    var view: PackofDataViewControllerProtocol?
    var message: String = ""
    
    func viewWillAppear() {
        viewModel?.selectedPackage = nil
        performGetListPrice()
        view?.refreshView()
    }

    func performSelectAtIndexPath(_ indexPath: IndexPath) {
        if let model = viewModel?.getPackageAtIndexPath(indexPath) {
            if !model.packageId.isEmpty { // check if the selected package is not the empty package
                viewModel?.selectedPackage = model
            }
        }
    }
    
    func performRegisterPackage(_ package: PackageModel, isConfirmSMS: Bool) {
        if DataManager.isLoggedIn() {
            if let vc = view as! UIViewController? {
                vc.showHud()
                weak var weakSelf = self
                
                if package.status {
                    guard let message = package.popUp.first else {
                        return
                    }
                    
                    
                    let popupViewController = ListPricePopupViewController.init(title: String.huy_goi_cuoc_dk,
                                                                                message: message,
                                                                                confirmTitle: String.si_dong_y.uppercased(),
                                                                                cancelTitle: String.cancel.uppercased())
                    popupViewController.view.backgroundColor = .clear
                    popupViewController.desLabel.text = message
                    popupViewController.confirmDialog = {(_) in
                        self.interactor?.performStopPackage(package, complete: { () -> (Void) in
                            vc.hideHude()
                            weakSelf?.performGetListPrice()
                            weakSelf?.showErr(message: String.unregisterSubSuccess)
                        }, failse: { (err: String) -> (Void) in
                            vc.hideHude()
                            weakSelf?.showErr(message: err)
                        })
                    }
                    
                    popupViewController.cancelDialog = {(_) in
                        vc.hideHude()
                    }
                    vc.present(popupViewController, animated: true, completion: nil)
                    
                } else {
                    interactor?.performRegisterPackage(package, complete: { (json: JSON, err: NSError?) -> (Void) in
                        (weakSelf?.view as? BaseViewController)?.logPurchaseEevent(Constants.fire_base_package)
                        vc.hideHude()
                        if(json["is_confirm_sms"].intValue == 1 && isConfirmSMS){
                            self.message = json["message"].stringValue
                            self.view?.showSMSConfirm(message: self.message,
                                                      number: json["number"].stringValue,
                                                      smsContent: json["content"].stringValue)
                        }else{
                            weakSelf?.performGetListPrice()
                            weakSelf?.showErr(message: String.registerSubSuccess)
                        }
                        
                    }, failse: { (err: String) -> (Void) in
                        vc.hideHude()
                        weakSelf?.showErr(message: err)
                    })
                }
            }
        } else {
            if let vc = view as! UIViewController? {
                LoginViewController.performLogin(fromViewController: vc)
            }
        }
    }

    func performRegisterPackage(_ package: PackageModel) {
        if DataManager.isLoggedIn() {
            if let vc = view as! UIViewController? {
                vc.showHud()
                weak var weakSelf = self
               
                if package.status {
                    guard let message = package.popUp.first else {
                        return
                    }
                    

                    let popupViewController = ListPricePopupViewController.init(title: "",
                                                                                message: message,
                                                                                confirmTitle: String.okString,
                                                                                cancelTitle: String.cancel)
                    popupViewController.view.backgroundColor = .clear
                    popupViewController.titleLabel.text = ""
                    popupViewController.desLabel.text = message
                    popupViewController.confirmDialog = {(_) in
                        self.interactor?.performStopPackage(package, complete: { () -> (Void) in
                            vc.hideHude()
                            weakSelf?.performGetListPrice()
                            weakSelf?.showErr(message: String.unregisterSubSuccess)
                        }, failse: { (err: String) -> (Void) in
                            vc.hideHude()
                            weakSelf?.showErr(message: err)
                        })
                    }

                    popupViewController.cancelDialog = {(_) in
                        vc.hideHude()
                    }
                    vc.present(popupViewController, animated: true, completion: nil)

                } else {
                    interactor?.performRegisterPackage(package, complete: { (json: JSON, err: NSError?) -> (Void) in
                        (weakSelf?.view as? BaseViewController)?.logPurchaseEevent(Constants.fire_base_package)
                        vc.hideHude()
                        if(json["is_confirm_sms"].intValue == 1){
                            self.message = json["message"].stringValue
                            self.view?.showSMSConfirm(message: self.message,
                                                      number: json["number"].stringValue,
                                                      smsContent: json["content"].stringValue)
                        }else{
                            weakSelf?.performGetListPrice()
                            weakSelf?.showErr(message: String.registerSubSuccess)
                        }

                    }, failse: { (err: String) -> (Void) in
                        vc.hideHude()
                        weakSelf?.showErr(message: err)
                    })
                }
            }
        } else {
            if let vc = view as! UIViewController? {
                LoginViewController.performLogin(fromViewController: vc)
            }
        }
     }

    func performChargeVisa() {

    }

    @objc func performGetListPrice() {
        weak var weakSelf = self
        interactor?.performGetListPrice(completion: { (list: [PackageModel], isConfirmSMS: Bool, isRegisterFast: Bool, err: NSError?) in
            if let message = err?.localizedDescription {
                weakSelf?.showErr(message: message)
            } else {
                weakSelf?.viewModel?.performUpdateListPackage(list: list, isConfirmSMS: isConfirmSMS, isRegisterFast: isRegisterFast)
            }
            weakSelf?.view?.refreshView()
        })
    }
    private func showErr(message: String) {
        if let vc = view as! UIViewController? {
            vc.toast(message)
        }
    }
}
