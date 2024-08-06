//
//  LoginPresenter.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Reachability

class LoginPresenter: NSObject {

    var viewModel: LoginViewModel? = LoginViewModel()
    var wireFrame: LoginWireFrame? = LoginWireFrame()
    var interactor: LoginInteractor? = LoginInteractor()
    weak var view: LoginViewController?

    func performLogin() {

        weak var weakSelf = self
        wireFrame?.hostViewController?.showHud()
        interactor?.performLoginWithPhone(phoneNumber: viewModel?.phone,
                                          pass: viewModel?.pass,
                                          captcha: viewModel?.captcha,
                                          refreshToken: viewModel?.refreshToken,
                                          done: { () -> (Void) in

                                            weakSelf?.wireFrame?.hostViewController?.hideHude()
                                            if let user = DataManager.getCurrentMemberModel() {
                                                weakSelf?.wireFrame?.performDissmiss(isChangePass: user.needChangePassword)
                                            } else {
                                                weakSelf?.wireFrame?.performDissmiss()
                                            }
                                            Constants.appDelegate.registerDeviceToken()

        }, failse: { (err: NSError?) -> (Void) in

            weakSelf?.wireFrame?.hostViewController?.hideHude()

            if err?.code == APIErrorCode.needCaptcha.rawValue || err?.code == APIErrorCode.invalidCaptcha.rawValue {

                weakSelf?.viewModel?.isNeedCapcha = true

            } else {
                weakSelf?.wireFrame?.hostViewController?.toast((err?.localizedDescription)!)
            }

            if weakSelf?.viewModel?.isNeedCapcha == true {
                weakSelf?.wireFrame?.hostViewController?.toast((err?.localizedDescription)!)
                weakSelf?.view?.performGetCapchar()
            }
        })
    }

    func performLoginFacebookWithToken(token: String!, facebookUserID: String!) {

        viewModel?.fbToken = token

        weak var weakSelf = self
        wireFrame?.hostViewController?.showHud()
        interactor?.performLoginFacebookWithToken(fbToken: viewModel?.fbToken,
                                                  captcha: viewModel?.captcha,
                                                  refreshToken: viewModel?.refreshToken,
                                                  done: { () -> (Void) in

                                                    weakSelf?.wireFrame?.hostViewController?.hideHude()
                                                    if let user = DataManager.getCurrentMemberModel() {
                                                        weakSelf?.wireFrame?.performDissmiss(isChangePass: user.needChangePassword)
                                                    } else {
                                                        weakSelf?.wireFrame?.performDissmiss()
                                                    }
                                                    Constants.appDelegate.registerDeviceToken()
        }, failse: { (err: String?) -> (Void) in

            weakSelf?.wireFrame?.hostViewController?.hideHude()
            if let string = err {
                weakSelf?.wireFrame?.hostViewController?.toast(string)
            }
        })
    }

    func peformLoginWith3G() {

        if let reachability = Reachability() {
            if reachability.isReachable && reachability.isReachableViaWWAN {
                weak var weakSelf = self
                wireFrame?.hostViewController?.showHud()
                interactor?.performLogin3G(done: { () -> (Void) in

                    weakSelf?.wireFrame?.hostViewController?.hideHude()
                    if let user = DataManager.getCurrentMemberModel() {
                        weakSelf?.wireFrame?.performDissmiss(isChangePass: user.needChangePassword)
                    } else {
                        weakSelf?.wireFrame?.performDissmiss()
                    }
                    Constants.appDelegate.registerDeviceToken()
                }, failse: { (err: NSError?) -> (Void) in

                    weakSelf?.wireFrame?.hostViewController?.hideHude()
                    //self.view?.toast((err?.localizedDescription)!)
                })
            } else {
               self.showLoginWith3GFailedAlert()
            }
        } else {
            self.showLoginWith3GFailedAlert()
        }
    }

    private func showLoginWith3GFailedAlert() {
        view?.toast(String.loginFailedMsg)
    }

    func performSignUp() {

        wireFrame?.performSignUp()
    }

    func performGetPass() {

        wireFrame?.performGetPass()
    }
}
