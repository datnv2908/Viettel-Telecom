//
//  BaseNavigationController.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
   
   var currentVc = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        self.delegate = self
    }

    func setUp() {
//        self.navigationBar.isOpaque = true
//        self.navigationBar.isTranslucent = false
//        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white,
//                                       NSFontAttributeName: AppFont.font(style: .bold, size: 17)]
//        self.navigationBar.titleTextAttributes = titleDict as? [String : Any]
//        self.navigationBar.tintColor = UIColor.white
//        self.navigationBar.barTintColor = AppColor.navigationColor()
//        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationBar.shadowImage = UIImage()
        
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = false
      let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.settitleColor(),
                                       NSAttributedString.Key.font: AppFont.font(style: .bold, size: 17)]
        self.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        self.navigationBar.tintColor = UIColor.settitleColor()
        self.navigationBar.barTintColor = UIColor.setViewColor()
        self.getStatusBar()
        
        //        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //        self.navigationBar.shadowImage = UIImage()
    }
   override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
      super.traitCollectionDidChange(previousTraitCollection)
      self.navigationController?.navigationBar.barTintColor = UIColor.setViewColor()
   }


    func setUpTranslucentStyle() {
        self.navigationBar.isOpaque = true
        self.navigationBar.isTranslucent = true
        let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.settitleColor(),
                                       NSAttributedString.Key.font: AppFont.font(style: .bold, size: 17)]
        self.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
        self.navigationBar.tintColor = UIColor.settitleColor()
        self.navigationBar.barTintColor = UIColor.setViewColor()
    }

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
        return .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func initWithDefaultStyle(rootViewController: UIViewController!) -> BaseNavigationController {
        let nav = BaseNavigationController(rootViewController: rootViewController)
        nav.setUp()
        return nav
    }

    class func initWithTranslucentStyle(rootViewController: UIViewController!)
        -> BaseNavigationController {
        let nav = BaseNavigationController(rootViewController: rootViewController)
        nav.setUpTranslucentStyle()
        return nav
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
//      let arr = [HomeViewController.]
      if let currentVC = self.topViewController {
      if  let _ = viewController as? PopularViewController  {
//         currentVc.navigationController?.
      }else if let _ = viewController as? HomeViewController {}else if let _ = viewController as? ProfileViewController{}else if let _ = viewController as? HomePageViewController {}else if let _ = viewController as? FollowViewController {} else if let _ = viewController as? ChangePasswordViewController {}else if let _ = viewController as? SelectVideoViewController {}else{

         let itemBack = UIBarButtonItem(image:DataManager.getStatusbarVaule() ? UIImage(named: "backGray") :  UIImage(named: "iconBack"), style: .done, target: self, action: #selector(backAction))
         currentVC.navigationController?.navigationBar.tintColor = DataManager.getStatusbarVaule() ?  .black : .white
//         currentVC.navigationController?.navigationBar.barStyle = UIBarStyl
         currentVC.navigationItem.setHidesBackButton(true, animated: false)
          currentVC.navigationItem.leftBarButtonItem =  itemBack
         self.currentVc = currentVC
      }
      }
       
    }
   @objc func backAction (){
      currentVc.navigationController?.popViewController(animated: true)
   }
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
    }

}
