//
//  UIViewControllerExtension.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import Toast
import FirebaseAnalytics

extension UIViewController {
    /*class func initWithNib() -> Self {
        return initWithNibTemplate()
    }
    
     */
    class func initWithNibTemplate<T>() -> T {
        var nibName = String(describing: self)
        if Constants.isIpad {
            if let pathXib = Bundle.main.path(forResource: "\(nibName)_\(Constants.iPad)", ofType: "nib") {
                if FileManager.default.fileExists(atPath: pathXib) {
                    nibName = "\(nibName)_\(Constants.iPad)"
                }
            }
        }
        let viewcontroller = self.init(nibName: nibName, bundle: Bundle.main)
        return viewcontroller as! T
    }

    func alertWithTitle(_ title: String?, message: String?) -> UIAlertController? {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.dong_y, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }

    func alertView(_ title: String?, message: String?) {
        let alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: String.dong_y)
        alertView.show()
    }

    func showHud() {
        CustomActivityIndicatorView.addHub(for: view, image: UIImage(named: "IcLoading")!)
    }

    func hideHude() {
        CustomActivityIndicatorView.hideHub(for: view)
    }

    func call(_ phoneNumber: String) {
        let url = URL(string:"tel://\(phoneNumber)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.openURL(url!)
        } else {
            toast(String.thiet_bi_khong_the_thuc_hien_cuoc_goi)
        }
    }

    func toast(_ message: String) {
        if !message.isEmpty {
            view.makeToast(message, duration: TimeInterval(Constants.kToastDuration), position: CSToastPositionCenter)
        }
    }

    func logViewEvent(_ screenName: String, _ event: String) {
        Analytics.logEvent(event, parameters: [
            "screen_name": screenName])
    }

    func logPurchaseEevent(_ screenName: String) {
        Analytics.logEvent("package_register", parameters: [
            "screen_name": screenName])
    }
}
