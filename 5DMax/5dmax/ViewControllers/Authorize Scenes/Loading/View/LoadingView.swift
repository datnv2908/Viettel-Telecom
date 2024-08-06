//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: BaseViewController, LoadingViewProtocol {
    var presenter: LoadingPresenterProtocol?

    override func viewDidLoad() {
//        super.viewDidLoad()

        view.backgroundColor = AppColor.navigationColor()
        presenter?.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingAnimation), name: NSNotification.Name(rawValue: "NavigationAnimation"), object: nil)
        
        self.settingAnimation()
    }
    
    @objc override func settingAnimation() {
        let setting = DataManager.getDefaultSetting()
        if (setting?.animation == "1") {
            self.view.makeItSnow(withFlakesCount: 160, animationDurationMin: 15.0, animationDurationMax: 30.0)
        }
    }

    deinit {
    }
}
