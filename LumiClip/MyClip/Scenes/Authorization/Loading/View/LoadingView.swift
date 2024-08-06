//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: BaseViewController {
    var presenter: LoadingPresenterProtocol?

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var errorView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        let userService = UserService()
        userService.getAccountSettings(completion: { (result) in
            
        })
        self.view.backgroundColor = UIColor.setViewColor()
        UIApplication.shared.setStatusBarOrientation(.portrait, animated: false)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIViewController.attemptRotationToDeviceOrientation()
    }
    @IBAction func onRetry(_ sender: Any) {
        presenter?.viewDidLoad()
    }

    deinit {
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
}

extension LoadingView: LoadingViewProtocol {
    func showHideErrorView(_ show: Bool) {
        errorView.isHidden = !show
    }

    func toggleIndicator(_ start: Bool) {
        if start {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}
