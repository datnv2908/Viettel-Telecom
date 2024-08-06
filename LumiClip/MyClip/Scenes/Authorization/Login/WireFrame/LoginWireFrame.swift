//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation

class LoginWireFrame: NSObject {
    weak var viewController: LoginViewController?
    var presenter: LoginWireFrameOutput?
}

extension LoginWireFrame: LoginWireFrameInput {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
   func setTheme(){
      viewController?.setTheme()
   }
    func doShowAlert(title: String, message: String) {
        viewController?.alertView(title, message: message)
    }

    func doShowHud() {
        viewController?.showHud()
    }

    func doHideHud() {
        viewController?.hideHude()
    }

    func doShowToast(message: String) {
        viewController?.toast(message)
    }
}
