//
//  Login3ViewController.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class Login3ViewController: BaseViewController {

    @IBOutlet weak var txfCode: DarkTextField!
    @IBOutlet weak var txfPass: DarkTextField!
    @IBOutlet weak var txfRePass: DarkTextField!
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    var phoneNumber: String = ""
    private var captcha: String = ""

    let service = UserService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txfCode.placeholder = String.nhap_ma_xac_nhan
        txfPass.placeholder = String.nhap_mat_khau
        txfRePass.placeholder = String.nhap_lai_mat_khau
        
        btnRegister.setTitle(String.dang_ky, for: .normal)
        btnResend.setTitle(String.gui_lai_ma, for: .normal)
        view.backgroundColor = AppColor.grayBackgroundColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override class func initWithNib() -> Login3ViewController {
        var storyboardId = String(describing: self)
        if Constants.isIpad {
            storyboardId = "iPad"
        }
        return Login3ViewController.initWithDefautlStoryboardWithID(storyboardId: storyboardId)
    }

    // MARK: 
    // MARK: IBACTIONS

    @IBAction func btnBackPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSignUpPressed(_ sender: Any) {
        if self.isInvalidInput() {
            view.endEditing(true)
            showHud()
            service.signUp(phone: phoneNumber, otp: txfCode.text!, pass: txfPass.text!,
                           captcha: captcha, completion: { (result) in
                self.hideHude()
                switch result {
                case .success(_):
                    let rootViewController = self.navigationController!.viewControllers.first
                    rootViewController?.toast(String.registerSuccess)
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    break
                case .failure(let error):
                    self.toast(error.localizedDescription)
                }
            })
        }
    }

    @IBAction func btnResendPressed(_ sender: Any) {
        service.getOTP(phoneNumber) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
                break
            }
        }
    }
    // MARK: 
    // MARK: METHODS

    func isInvalidInput() -> Bool {
        if (txfCode.text?.characters.isEmpty)! {
            toast(String.enterOTP)
            return false
        } else if (txfPass.text?.characters.isEmpty)! {
            toast(String.enterPassword)
            return false
        } else if (txfRePass.text?.characters.isEmpty)! {
            toast(String.enterConfirmPassword)
            return false
        } else if txfPass.text != txfRePass.text {
            toast(String.confirmPasswordNotMatch)
            return false
        }
        return true
    }
    
    deinit {
        service.cancelAllRequests()
    }
}

extension Login3ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txfCode {
            txfPass.becomeFirstResponder()
        } else if textField == txfPass {
            txfRePass.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
