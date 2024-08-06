//
//  Macro.swift
//  SwiftDemo
//
//  Created by ThuanND 12/23/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

import Foundation
import UIKit

let kConstantPi = 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280

func DLog(_ message: Any...,
          function: String = #function,
          file: NSString = #file,
          line: Int = #line) {

    #if DEBUG
        // debug only code
        print("\(file.lastPathComponent) - \(function)[\(line)]: \(message)")
    #else
        // release only code
    #endif
}

func isIphoneApp() -> Bool {

    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
        return true
    case .pad:
        return false

    default:
        return false
    }
}

func ALog(_ message: String?,
          function: String = #function,
          file: NSString = #file,
          line: Int = #line) {

    #if DEBUG
        // debug only code
        print("\n\(file.lastPathComponent) - \(function)[\(line)]: show alert with "
            + "\nMessage: \(message ?? "")"
            + "\n--------------------------------------------")

    let alertView = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
    let dismissAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)

        alertView.addAction(dismissAction)

        let viewController = UIApplication.shared.windows.first?.rootViewController
        DispatchQueue.main.async {
            viewController!.present(alertView, animated: true, completion: nil)
        }
    #else
        // release only code
    #endif
}

func showAlert(title: String?, message: String?, completeHanle : ((() -> Swift.Void)?)) {

    let alertView = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let cancelAction = UIAlertAction(title: String.huy_bo, style: UIAlertAction.Style.cancel)

    let dismissAction = UIAlertAction(title: String.dong_y, style: UIAlertAction.Style.default) { (_) in

        if completeHanle != nil {
            completeHanle!()
        }
    }

    alertView.addAction(cancelAction)
    alertView.addAction(dismissAction)

    let viewController = UIApplication.shared.windows.first?.rootViewController
    DispatchQueue.main.async {
        viewController!.present(alertView, animated: true, completion: nil)
    }
}
