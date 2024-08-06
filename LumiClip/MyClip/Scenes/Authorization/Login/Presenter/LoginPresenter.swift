//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//
import Foundation
import Firebase
import UIKit
import ReachabilitySwift
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebasePerformance

class LoginPresenter: NSObject {
    var view: LoginViewControllerInput?
    var viewModel: LoginViewModel?
    var interactor: LoginInteractorInput?
    var wireFrame: LoginWireFrameInput?
    var completionHandler: LoginManagerCompletionHandler?
    init(_ completion: LoginManagerCompletionHandler? = nil) {
        self.completionHandler = completion
    }
}

// MARK: 
// MARK: VIEW
extension LoginPresenter: LoginViewControllerOutput {
    func viewDidLoad() {

    }

    func viewWillAppear() {

    }

    func performLogin(username: String, password: String, captcha: String?) {
        wireFrame?.doShowHud()
        let trace = Performance.startTrace(name:"Login_normal")
        interactor?.authorize(type: .normal, username: username, password: password, captcha: captcha, accessToken: nil, completion: { (result) -> (Void) in
            self.wireFrame?.doHideHud()
            trace?.stop()
            switch result {
            case .success(let response):
                self.loginDidSuccess(response.data)
            case .failure(let error as NSError):
                if error.code == APIErrorCode.needCaptcha.rawValue ||
                    error.code == APIErrorCode.invalidCaptcha.rawValue {
                    self.viewModel?.isNeedCaptcha = true
                    (self.view as? BaseViewController)?.toast(error.localizedDescription)
                    (self.view as? LoginViewController)?.captchaTextField.becomeFirstResponder()
                    self.view?.showCaptcha()
                } else {
                    if (self.viewModel?.isNeedCaptcha)! {
                        self.view?.showCaptcha()
                    }
                    (self.view as? BaseViewController)?.toast(error.localizedDescription)
                    (self.view as? LoginViewController)?.passwordTextField.text = ""
                }
            default:
                break
            }
        })
    }

    func performCancelLogin(_ sender: Any) {
        if let handler = completionHandler {
            handler(CompletionBlockResult(isCancelled: true, isSuccess: false), nil)
        }
        wireFrame?.dismiss()
    }

    func performLoginFB(_ sender: Any) {
        
    }

    func performLoginGG(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }

    func performAutoLogin(_ sender: Any) {
        if let reachability = Reachability() {
            if reachability.isReachable && reachability.isReachableViaWWAN {
                wireFrame?.doShowHud()
                let trace = Performance.startTrace(name:"Login_auto")
                interactor?.authorize(type: .auto, username: nil, password: nil, captcha: nil, accessToken: nil, completion: { (result) -> (Void) in
                    self.wireFrame?.doHideHud()
                    trace?.stop()
                    switch result {
                    case .success(let response):
                        self.loginDidSuccess(response.data)
                    case .failure(let error):                        
                        (self.view as? BaseViewController)?.toast(error.localizedDescription)
                    }
                })
            } else {
                self.showLoginWith3GFailedAlert()
            }
        } else {
            self.showLoginWith3GFailedAlert()
        }
    }

    internal func loginDidSuccess(_ model: MemberModel) {
        if let model = DataManager.getCurrentMemberModel() {
            let service = UserService()
            service.registerDeviceToken(completion: { (result) in
                
            })
            if model.needChangePassword {
                showChangePassword()
            } else if model.needShowMapAccount {
                showMapAccount()
            } else if model.isShowSuggestTopic {
                showSuggestTopic()
            } else {
                showHomePage()
            }
            
            NotificationCenter.default.post(name: .kNotificationShouldReloadFollow, object: nil, userInfo: nil)
        }
    }
    
    private func showChangePassword() {
        let viewcontroller = view as! BaseViewController
        let changePwdVC = ChangePasswordViewController.initWithNib()
        weak var wself = self
        changePwdVC.completionBlock = {(result) in
            guard let model = DataManager.getCurrentMemberModel() else {
                return
            }
            if model.isShowSuggestTopic {
                wself?.showSuggestTopic()
            } else if model.needShowMapAccount {
                wself?.showMapAccount()
            } else {
                wself?.showHomePage()
            }
        }
        let nav = BaseNavigationController(rootViewController: changePwdVC)
        viewcontroller.present(nav, animated: true, completion: nil)
    }
    
    private func showMapAccount() {
        let viewcontroller = view as! BaseViewController
        let mapAccountVC = LinkAccountViewController.initWithNib()
        weak var wself = self
        mapAccountVC.completionBlock = {(result) in
            guard let model = DataManager.getCurrentMemberModel() else {
                return
            }
            if model.isShowSuggestTopic {
                wself?.showSuggestTopic()
            } else {
                wself?.showHomePage()
            }
        }
        let nav = BaseNavigationController(rootViewController: mapAccountVC)
        viewcontroller.present(nav, animated: true, completion: nil)
    }
    
    private func showSuggestTopic() {
        let viewcontroller = view as! BaseViewController
        let selectChannelVC = SelectChannelViewController.initWithNib()
        weak var wself = self
        selectChannelVC.completionBlock = {(result) in
            wself?.showHomePage()
        }
        let nav = BaseNavigationController(rootViewController: selectChannelVC)
        viewcontroller.present(nav, animated: true, completion: nil)
    }
    
    private func showHomePage() {
        completionHandler?(CompletionBlockResult(isCancelled: false, isSuccess: true), nil)
        self.wireFrame?.dismiss()
        self.wireFrame?.setTheme()
//      self.wireFrame
    }
    
    private func showLoginWith3GFailedAlert() {
        let viewcontroller = view as! BaseViewController
        viewcontroller.toast(String.require3G)
    }
}

// MARK: 
// MARK: INTERACTOR
extension LoginPresenter: LoginInteractorOutput {
}

// MARK: 
// MARK: WIRE FRAME
extension LoginPresenter: LoginWireFrameOutput {
}

extension LoginPresenter: GIDSignInDelegate {
    // The sign-in flow has finished and was successful if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        GIDSignIn.sharedInstance().signOut()
        guard let user = user else {
            (self.view as? BaseViewController)?.toast(error.localizedDescription)
            return
        }
        wireFrame?.doShowHud()
        guard let idToken = user.authentication.idToken else {
            return
        }
        let trace = Performance.startTrace(name:"Login_google")
        interactor?.authorize(type: .google, username: nil, password: nil, captcha: nil, accessToken: idToken, completion: { (result) -> (Void) in
            self.wireFrame?.doHideHud()
            trace?.stop()
            switch result {
            case .success(let response):
                self.loginDidSuccess(response.data)
            case .failure(let error):
                (self.view as? BaseViewController)?.toast(error.localizedDescription)
            }
        })
    }

    // Finished disconnecting |user| from the app successfully if |error| is |nil|.
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
    }
}
