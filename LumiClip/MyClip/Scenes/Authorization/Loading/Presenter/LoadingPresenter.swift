//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import ReachabilitySwift
import FirebasePerformance

class LoadingPresenter: LoadingPresenterProtocol, LoadingInteractorOutputProtocol {
    weak var view: LoadingViewProtocol?
    var interactor: LoadingInteractorInputProtocol?
    var wireFrame: LoadingWireFrameProtocol?

    var retryItems = 3

    init() {}

    //mark: -- LoadingPresenterProtocol
    func viewDidLoad() {
        if DataManager.isLoggedIn() {
            self.refreshToken()
        } else {
            autoLoginIfNeeded()
        }
    }

    private func refreshToken() {
        let trace = Performance.startTrace(name:"Splash_refreshtoken")
        interactor?.authorize(type: .refreshToken, username: nil, password: nil, captcha: nil, accessToken: nil, completion: { (result) -> (Void) in
            switch result {
            case .success:
                self.authorizeDidSuccess()
            case .failure:
                // do logout
                DataManager.clearLoginSession()
                // perform auto login if needed
                self.autoLoginIfNeeded()
            }
            trace?.stop()
        })
    }

    private func autoLogin() {
        let trace = Performance.startTrace(name:"Splash_autologin")
        interactor?.authorize(type: .auto, username: nil, password: nil, captcha: nil, accessToken: nil, completion: { (result) -> (Void) in
            switch result {
            case .success:
                self.authorizeDidSuccess()
            case .failure:
                self.loadingComplete()
            }
            trace?.stop()
        })
    }

    // mark: -- private function
    private func autoLoginIfNeeded() {
        if let reachability = Reachability() {
            if reachability.isReachable && reachability.isReachableViaWWAN {
                self.autoLogin()
            } else {
                self.loadingComplete()
            }
        } else {
            self.loadingComplete()
        }
    }

    func authorizeDidSuccess() {
        guard let model = DataManager.getCurrentMemberModel() else {
            return
        }
        let service = UserService()
        service.registerDeviceToken(completion: { (result) in
            
        })
        let viewcontroller = view as! BaseViewController
        if model.isUpdateApp {
            if model.isForceUpdateApp {
                let alertController = UIAlertController(title: String.notification,
                                                        message: String.yeu_cau_nang_cap_phien_ban_moi,
                                                        preferredStyle: .alert)
                let updateAction = UIAlertAction(title: String.nang_cap, style: .default, handler: { (_) in
                    UIApplication.shared.openURL(URL(string: Constants.kRatingUrl)!)
                    abort()
                })
                let exitAction = UIAlertAction(title: String.thoat, style: .cancel, handler: { (_) in
                    abort()
                })
                alertController.addAction(updateAction)
                alertController.addAction(exitAction)
                viewcontroller.present(alertController, animated: true, completion: nil)
            } else {
                let forgetUpdateApp = UserDefaults.standard.bool(forKey: Constants.kForgetNewAppVersionNotice)
                if !forgetUpdateApp {
                    let alertController = UIAlertController(title: String.notification,
                                                            message: String.co_phien_ban_moi,
                                                            preferredStyle: .alert)
                    let updateAction = UIAlertAction(title: String.nang_cap, style: .default, handler: { (_) in
                        UIApplication.shared.openURL(URL(string: Constants.kRatingUrl)!)
                        abort()
                    })
                    let dontAskAction = UIAlertAction(title: String.dung_hoi_lai, style: .default, handler: { (_) in
                        UserDefaults.standard.set(true, forKey: Constants.kForgetNewAppVersionNotice)
                        UserDefaults.standard.synchronize()
                        self.loadingComplete()
                    })
                    let cancelAction = UIAlertAction(title: String.cancel, style: .cancel, handler: { (_) in
                        self.loadingComplete()
                    })
                    alertController.addAction(updateAction)
                    alertController.addAction(dontAskAction)
                    alertController.addAction(cancelAction)
                    viewcontroller.present(alertController, animated: true, completion: nil)
                } else {
                    loadingComplete()
                }
            }
        } else {
            loadingComplete()
        }
    }
    
    private func loadingComplete() {
        if DataManager.checkShowTutorial() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                Constants.appDelegate.showTutorial()
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                // Put your code which should be executed with a delay here
                Constants.appDelegate.showHomePage()
            })
        }
    }
}
