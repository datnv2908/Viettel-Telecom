//
//  HomeEventViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeEventViewController: BaseViewController {

    @IBOutlet weak var viewHowTo: UIView!
    @IBOutlet weak var viewAds: UIView!
    @IBOutlet weak var takeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        takeBtn.setTitle(String.tham_gia_ngay, for: .normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showHowToScreen(_ sender: Any) {
        viewAds.isHidden = true;
        viewHowTo.isHidden = false;
    }
    
    
    @IBAction func showPackageList(_ sender: Any) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if DataManager.isLoggedIn() {
            let packageVC = ServicePackageViewController.initWithNib()
            navigationController?.pushViewController(packageVC, animated: true)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                }
            })
        }
    }
    @IBAction func showPackageListMonth(_ sender: Any) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if DataManager.isLoggedIn() {
            let packageVC = ServicePackageViewController.initWithNib()
            navigationController?.pushViewController(packageVC, animated: true)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                }
            })
        }
    }
    
    @IBAction func showUploadAction(_ sender: Any) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        if DataManager.isLoggedIn() {
            NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
            let selectVideoVC = SelectVideoViewController.initWithNib()
            let nav = BaseNavigationController(rootViewController: selectVideoVC)
            present(nav, animated: true, completion: nil)
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                }
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
