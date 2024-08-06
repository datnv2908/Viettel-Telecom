//
//  BaseNavigationController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class BaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.delegate = self
        self.navigationBar.isTranslucent = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingAnimation), name: NSNotification.Name(rawValue: "NavigationAnimation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.settingAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.stopSnowing()
    }
    
    @objc func deviceRotated(){
        if UIDevice.current.orientation.isLandscape {
            self.view.stopSnowing()
            // Resize other things
        }
        if UIDevice.current.orientation.isPortrait {
            self.settingAnimation()
            // Resize other things
        }
    }
    
    @objc func settingAnimation() {
        let setting = DataManager.getDefaultSetting()
        if (setting?.animation == "1") {
            self.view.makeItSnow(withFlakesCount: 160, animationDurationMin: 15.0, animationDurationMax: 30.0)
        }
    }

    func setUp() {
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = false
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                       NSAttributedString.Key.font: AppFont.museoSanFont(style: .regular, size: 17.0)]
        self.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = AppColor.navigationColor()
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }

    func setUpTranslucentStyle() {
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = true
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                       NSAttributedString.Key.font: AppFont.museoSanFont(style: .regular, size: 17.0)]
        self.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.init(red: 18, green: 18, blue: 18, alpha: 1)

    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    class func initWithDefaultStyle(rootViewController: UIViewController!) -> BaseNavigationViewController {

        let nav = BaseNavigationViewController(rootViewController: rootViewController)
        nav.setUp()

        return nav
    }

    class func initWithTranslucentStyle(rootViewController: UIViewController!) -> BaseNavigationViewController {

        let nav = BaseNavigationViewController(rootViewController: rootViewController)
        nav.setUpTranslucentStyle()
        return nav
    }
}

extension BaseNavigationViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {

        if let currentVC = self.topViewController {

            let itemBack = UIBarButtonItem(title: "", style: .done, target: currentVC, action: nil)
            currentVC.navigationItem.backBarButtonItem = itemBack
        }
    }
}
