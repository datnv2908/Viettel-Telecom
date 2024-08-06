//
//  LoginWireFrame.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class LoginWireFrame: NSObject {

    var hostViewController: UIViewController?

    func performSignUp() {

        let login2VC = Login2ViewController.initWithNib()
        self.hostViewController?.navigationController?.pushViewController(login2VC, animated: true)
    }

    func performGetPass() {

//        let login2VC = Login2ViewController.initWithNib()
        let login6VC = Login6InputViewController.initWithNib()
        self.hostViewController?.navigationController?.pushViewController(login6VC, animated: true)
    }

    func performDissmiss(isChangePass: Bool = false) {
        if (isChangePass == true) {
            let changePassVC = FirstChangePassViewController.initWithNib()
            self.hostViewController?.navigationController?.pushViewController(changePassVC, animated: true)
        } else {
            self.hostViewController?.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
