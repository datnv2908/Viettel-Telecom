//
//  AppAlertView.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

enum AlertMessageType {
    case errorType
}

class AppAlertView: NSObject {

    class func showAlert(type: AlertMessageType, title: String?, message: String?, viewController: UIViewController?) {

        if let vc = viewController {

            let alertView = UIAlertController(title: title,
                                              message: message, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: String.bo_qua, style: UIAlertAction.Style.cancel) { (_) in

            }

            alertView.addAction(cancelAction)

            DispatchQueue.main.async {
                vc.present(alertView, animated: true, completion: nil)
            }
        }
    }

    class func showAlert(type: AlertMessageType, title: String?, message: String?,
                         viewController: UIViewController?, dismiss:(() -> (Void))?) {

        if let vc = viewController {

            let alertView = UIAlertController(title: title,
                                              message: message, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: String.bo_qua, style: UIAlertAction.Style.cancel) { (_) in

            }

            alertView.addAction(cancelAction)

            DispatchQueue.main.async {
                vc.present(alertView, animated: true, completion: nil)
            }
        }
    }

    class func showAlertTextField(title: String?,
                                  placeHodler: String?,
                                  viewController: UIViewController,
                                  dismiss:(() -> (Void))?,
                                  done: ((_ value: String) -> (Void))?) {
        var messageTextFied: UITextField?
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)

        alertView.addTextField { (textfield: UITextField) in

            textfield.placeholder = placeHodler
            messageTextFied = textfield
        }

        let cancelAction = UIAlertAction(title: String.bo_qua, style: .cancel) { (_) in

            if let block = dismiss {
                block()
            }
        }

        let okAction = UIAlertAction(title: String.dong_y, style: .default) { (_) in

            if let block = done {

                if let message = messageTextFied?.text {
                    block(message)
                } else {
                    block("")
                }
            }
        }

        alertView.addAction(cancelAction)
        alertView.addAction(okAction)

        DispatchQueue.main.async {
            viewController.present(alertView, animated: true, completion: nil)
        }
    }
}
