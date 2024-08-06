//
//  ConfirmPINViewController.swift
//  5dmax
//
//  Created by Hoang on 3/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ConfirmPINViewController: BaseViewController {

    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txfCode1: UITextField!
    @IBOutlet weak var txfCode2: UITextField!
    @IBOutlet weak var txfCode3: UITextField!
    @IBOutlet weak var txfCode4: UITextField!

    let pinModel: PinModel = DataManager.getPinModel()
    var complete:(() -> (Void))?
    var cancel:(() -> (Void))?
    var fromVC: BaseViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = String.nhap_ma_pin_hien_tai
        lblError.text = String.ma_pin_khong_dung
        lblError.isHidden = true
        txfCode1.becomeFirstResponder()
        self.navigationController?.navigationBar.isHidden = true
        lblError.layer.borderWidth = 1.0
        lblError.layer.cornerRadius = lblError.frame.size.height/2
        view.backgroundColor = AppColor.grayBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func checkInputInvalid() {
        if let code1 = txfCode1.text,
            let code2 = txfCode2.text,
            let code3 = txfCode3.text,
            let code4 = txfCode4.text {
            if code1.characters.count > 0
                && code2.characters.count > 0
                && code3.characters.count > 0
                && code4.characters.count > 0 {
                let pin = code1 + code2 + code3 + code4
                if pinModel.isEqualWithPin(pin: pin) {

                    lblError.isHidden = true
                    view.endEditing(true)
                    if let block = complete {
                        block()
                    }

                    if let vc = fromVC {
                        vc.dismissPopOver()
                    }
                    return
                } else {
                    lblError.isHidden = false
                    txfCode1.becomeFirstResponder()
                    txfCode1.text = ""
                    txfCode2.text = ""
                    txfCode3.text = ""
                    txfCode4.text = ""
                }

            } else {

                lblError.isHidden = false
                txfCode1.becomeFirstResponder()
                txfCode1.text = ""
                txfCode2.text = ""
                txfCode3.text = ""
                txfCode4.text = ""

            }
        } else {

            lblError.isHidden = false
            txfCode1.becomeFirstResponder()
            txfCode1.text = ""
            txfCode2.text = ""
            txfCode3.text = ""
            txfCode4.text = ""
        }
    }

    deinit {
        complete = nil
        cancel = nil
        fromVC = nil
    }
}

extension ConfirmPINViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

        if newString.length > 0 {

            if (newString as String).isNumberInvalid() == false {
                return false
            }

            textField.text = string
            if textField == txfCode1 {

                txfCode2.becomeFirstResponder()

            } else if textField == txfCode2 {

                txfCode3.becomeFirstResponder()

            } else if textField == txfCode3 {

                txfCode4.becomeFirstResponder()

            } else if textField == txfCode4 {
               checkInputInvalid()
            }

        } else {

            textField.text = ""
            if textField == txfCode4 {

                txfCode3.becomeFirstResponder()

            } else if textField == txfCode3 {

                txfCode2.becomeFirstResponder()

            } else if textField == txfCode2 {

                txfCode1.becomeFirstResponder()
            }
        }

        return false
    }
}

extension ConfirmPINViewController {

    class func showConfirmPIN(fromViewController: BaseViewController, sender: UIView?,
                              complete:(() -> (Void))?, cancel:(() -> (Void))?) {

        let vc = ConfirmPINViewController.initWithNib()
        vc.complete = complete
        vc.cancel = cancel
        vc.fromVC = fromViewController
        vc.preferredContentSize = CGSize(width: 320.0, height: 200.0)

        let nav = BaseNavigationViewController(rootViewController: vc)
        fromViewController.presentPopOverVC(viewController: nav, sender: sender, style: .none)
    }
}
