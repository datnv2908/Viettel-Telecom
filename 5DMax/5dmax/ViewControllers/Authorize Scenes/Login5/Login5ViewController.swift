//
//  Login4ViewController.swift
//  5dmax
//
//  Created by admin on 10/2/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class Login5ViewController: BaseViewController {

    @IBOutlet weak var txtCodeOTP: DarkTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnResend: UIButton!

    var phoneNumber: String = ""
    
    let service = UserService()
    let loginService = LoginInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        DLog(phoneNumber)
        txtCodeOTP.placeholder = String.nhap_mat_khau_tam_thoi
        btnLogin.setTitle(String.dang_nhap, for: .normal)
        btnResend.setTitle(String.gui_lai_mat_khau_tam_thoi, for: .normal)
        txtCodeOTP.becomeFirstResponder()
    }
    
    func setupView() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack2"), style: .plain, target: self, action: #selector(onBackBarButton))
    }
    
    //MARK:
    //MARK: FUNTION
    
    @IBAction func btnLoginSMSPressed(_ sender: Any) {
        weak var weakSelf = self
        if self.isInvalidput() {
            view.endEditing(true)
            showHud()
            service.signInOTP(phone: phoneNumber, otp: txtCodeOTP.text!, completion: { (refreshToken: String) in
                weakSelf?.hideHude()
                weakSelf?.doLoginWithRefreshToken(refreshToken: refreshToken)
            }) { (err: NSError?) in
                weakSelf?.hideHude()
                if let message = err?.localizedDescription {
                    weakSelf?.toast(message)
                }
            }
        }
    }
    
    @IBAction func btnResendPressed(_ sender: Any) {
        showHud()
        weak var weakSelf = self
        service.getLoginSMSOTP(phoneNumber) { (result) in
            weakSelf?.hideHude()
            switch result {
            case .success(let message):
                self.toast(message as! String)
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
                break
            }
        }
    }
    
    //MARK:
    //MARK: METHODS
    func isInvalidput() -> Bool {
        if (txtCodeOTP.text?.isEmpty)! {
            toast(String.enterOTP)
            return false
        }
        return true
    }
    
    @objc func onBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doLoginWithRefreshToken(refreshToken: String) {
        weak var weakSelf = self
        showHud()
        loginService.performLoginWithRefreshTokenOTP(refreshToken: refreshToken, done: { () -> (Void) in
            weakSelf?.hideHude()
            let popupViewController = AlertPopupViewController.init(titleStr: String.luu_y, message: String.yeu_cau_doi_mat_khau,
                                                                    cancelTitle: String.okString)
            popupViewController.cancelDialog = {(_) in
                let changePassVC = FirstChangePassViewController.initWithNib()
                changePassVC.isFromOTP = true
                self.navigationController?.pushViewController(changePassVC, animated: true)
            }
            self.present(popupViewController, animated: true, completion: nil)
            
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LoginSuccess"), object: nil)
//            weakSelf?.hideHude()
//            weakSelf?.toast(String.registerSuccess)
//            weakSelf?.dismiss(animated: true, completion: nil)
        }) { (error: NSError?) -> (Void) in
            weakSelf?.hideHude()
            if let message = error?.localizedDescription {
                weakSelf?.toast(message)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension Login5ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
