//
//  LoginManager.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

typealias LoginManagerCompletionHandler = (_ result: CompletionBlockResult, _ error: NSError?) -> Void
class LoginManager: NSObject {
    internal var fromViewController: UIViewController!
    internal var handler: LoginManagerCompletionHandler?
    func login(from viewcontroller: UIViewController, animated: Bool = false, handler: @escaping LoginManagerCompletionHandler) {
        fromViewController = viewcontroller
        self.handler = handler
        let loginVC = LoginConfigurator.viewController(handler)
        let nav = BaseNavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .overCurrentContext
        fromViewController.present(nav, animated: animated, completion: nil)
    }
    
    func logout(from viewcontroller: UIViewController) {
        DataManager.removeObject(forKey: Constants.kUserModel)
        DataManager.removeObject(forKey: Constants.kLoginStatus)
    }
}
