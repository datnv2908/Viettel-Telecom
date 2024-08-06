//
//  Login4ViewController.swift
//  5dmax
//
//  Created by admin on 10/2/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class Login4ViewController: BaseViewController {

    @IBOutlet weak var txtCodeOTP: DarkTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbText: UILabel!
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
        
        let str = NSString(string: self.lbText.text!)
        let theRange = str.range(of: String.dieu_khoan)
        
        let attributedString = NSMutableAttributedString(string: String.xem_dieu_khoan)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: theRange)
        self.lbText.attributedText = attributedString
    }
    
    func setupView() {
        self.navigationItem.title = String.dang_ky_moi
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack2"), style: .plain, target: self, action: #selector(onBackBarButton))
    }
    
    //MARK:
    //MARK: FUNTION
    
    @IBAction func btnLoginSMSPressed(_ sender: Any) {
        if (btnCheck.isSelected == false) {
            self.toast(String.check_term_msg)
            return
        }
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
            self.toast(String.da_gui_lai_ma)
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
    
    @IBAction func btnCheckPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func btnTermPressed(_ sender: Any) {
        self.btnCheck.isSelected = true
        let termVC = TermPopupViewController.initWithNib()
        self.present(termVC, animated: true, completion: nil)
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

extension Login4ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
