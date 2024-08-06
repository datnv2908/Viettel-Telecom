//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import Reachability

class LoadingPresenter: LoadingPresenterProtocol, LoadingInteractorOutputProtocol {
    weak var view: LoadingViewProtocol?
    var interactor: LoadingInteractorInputProtocol?
    var wireFrame: LoadingWireFrameProtocol?
    
    init() {}
    
    //mark: -- LoadingPresenterProtocol
    func viewDidLoad() {
        if DataManager.isLoggedIn() {
            weak var wself = self
            //            interactor?.performRefreshToken({ (result) in
            //                wself?.refreshTokenDidComplete(result: result)
            //            })
            //  check if current time expire do  refresh token  
            let currentTime = NSDate()
            let model = DataManager.getCurrentMemberModel()
            let timeLogin = DataManager.getCurrentTimeLogin()
            if (currentTime.getCurrentMillis() < (model!.expiredTime * 1000) + timeLogin ){
                weak var wself = self
                print( "current time \(currentTime.getCurrentMillis())")
                print("time will refresh token \(model!.expiredTime + timeLogin)")
                interactor?.performRefreshToken({ (result) in
                    wself?.refreshTokenDidComplete(result: result)
                })
            }else{
                self.loadingDidComplete()
                appDelegate?.doLogout()
            }
        } else {
            let mps = DataManager.objectForKey(Constants.kMPSDetectLink) as! String
            if mps.count > 0 {
                self.authen3G()
            } else {
                self.loadingDidComplete()
                NotificationCenter.default.addObserver(self, selector: #selector(authen3G), name: NSNotification.Name(rawValue: Constants.nMPSDetectLinkSuccess), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(loadingDidComplete), name: NSNotification.Name(rawValue: Constants.nMPSDetectLinkFaild), object: nil)
            }
        }
    }
    
    @objc private func authen3G() {
        if let reachability = Reachability() {
            if reachability.isReachable && reachability.isReachableViaWWAN {
                weak var wself = self
                interactor?.performAutoLogin({ (_) in
                    wself?.loadingDidComplete()
                })
            } else {
                loadingDidComplete()
            }
        } else {
            loadingDidComplete()
        }
    }
    
    private func refreshToken() {
        if DataManager.isLoggedIn() {
            weak var wself = self
            interactor?.performRefreshToken({ (result) in
                wself?.refreshTokenDidComplete(result: result)
            })
        }
    }
    
    private func refreshTokenDidComplete(result: Result<Any>) {
        switch result {
        case .success(_):
            loadingDidComplete()
            break
        case .failure( _):
            Constants.appDelegate.doLogout()
            // auto login with 3G if needed
            if let reachability = Reachability() {
                if reachability.isReachable && reachability.isReachableViaWWAN {
                    weak var wself = self
                    interactor?.performAutoLogin({ (_) in
                        wself?.loadingDidComplete()
                    })
                } else {
                    loadingDidComplete()
                }
            } else {
                loadingDidComplete()
            }
            break
        }
    }

    @objc private func loadingDidComplete() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
//            let didShowTutorial = DataManager.boolForKey(Constants.didShowTutorialPage)
//            if didShowTutorial {
                Constants.appDelegate.showHomePage()
//            } else {
//                Constants.appDelegate.showTutorial()
//            }
        })
    }
    
}
