//
//  ChangePasswordViewController.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {
    
    @IBOutlet weak var oldPasswordView: TextFieldFormView!
    @IBOutlet weak var newPasswordView: TextFieldFormView!
    @IBOutlet weak var confirmPasswordView: TextFieldFormView!
    @IBOutlet weak var captchaView: TextFieldFormView!
    @IBOutlet weak var captchaButton: UIButton!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var descLabel1: UILabel!
    @IBOutlet weak var descLabel2: UILabel!
    @IBOutlet weak var captchaViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var captchaViewBottomContraint: NSLayoutConstraint!
   
   @IBOutlet weak var containner: UIView!
   internal let captchaService = CaptcharService()
    internal let service = UserService()
    var isCaptchaViewHidden: Bool {
        get {
            return captchaViewHeightContraint.constant == 0
        }
        set(val) {
            if val == false {
                getCaptcha(){
                    self.captchaViewHeightContraint.constant = 48
                    self.captchaViewBottomContraint.constant = 10
                    self.captchaView.textField.text = ""
                }
            } else {
                captchaViewHeightContraint.constant = 0
                captchaViewBottomContraint.constant = 0
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
//    override var shouldAutorotate: Bool {
//        get {
//            return true
//        }
//    }
    
    var completionBlock: CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.setViewColor()
        containner.backgroundColor = UIColor.setViewColor()
        isCaptchaViewHidden = false
        descLabel.text = String.toi_thieu_6_ky_tu
        descLabel1.text = String.toi_thieu_6_ky_tu
        descLabel2.text = String.toi_thieu_6_ky_tu
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //config statusbar
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func setupView() {
        navigationItem.title = String.changePassword
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconEscape"), style: .plain, target: self, action: #selector(onClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.luu, style: .plain, target: self, action: #selector(onSave))
        
        //setup textfield mode
        oldPasswordView.mode = .password
//        oldPasswordView.title = "\(String.mat_khau_cu) (\(String.toi_thieu_8_ky_tu)"
        oldPasswordView.titleLabel.attributedText = getAttText(title: String.mat_khau_cu, hint: String.toi_thieu_6_ky_tu)
        
        newPasswordView.mode = .password
//        newPasswordView.title = "\(String.mat_khau_moi) (\(String.toi_thieu_8_ky_tu)"
        newPasswordView.titleLabel.attributedText = getAttText(title: String.mat_khau_moi, hint: String.toi_thieu_6_ky_tu)
        
        confirmPasswordView.mode = .password
//        confirmPasswordView.title = "\(String.xac_nhan_mat_khau_moi) (\(String.toi_thieu_8_ky_tu)"
        confirmPasswordView.titleLabel.attributedText = getAttText(title: String.xac_nhan_mat_khau_moi, hint: String.toi_thieu_6_ky_tu)
        
        captchaView.mode = .normal
        captchaView.title = String.ma_captcha
        captchaView.titleTextColor = AppColor.mainColor()
        captchaView.setLabelFontSize(size: 13)
        captchaView.textField.autocorrectionType = .no
    }
    func getAttText(title: String, hint: String) -> NSAttributedString {
        let attrs1 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : AppColor.mainColor()]

        let attrs2 = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor : AppColor.greyishBrown()]

           let attributedString1 = NSMutableAttributedString(string:title, attributes:attrs1)

           let attributedString2 = NSMutableAttributedString(string:" (\(hint))", attributes:attrs2)

           attributedString1.append(attributedString2)
        return attributedString1
//           self.lblText.attributedText = attributedString1
    }
    
    //set border and shadow of button
    func setupBorderAndShadow(layer: CALayer){
        layer.cornerRadius = 5
        layer.masksToBounds = false
        layer.shadowColor = UIColor.colorFromHexa("919191").cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    //config statusbar text
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
    @objc func onClose() {
        dismiss(animated: true) {
            self.completionBlock?(CompletionBlockResult(isCancelled: true, isSuccess: false))
        }
    }
    
    @objc func onSave() {
        if vertify() {
            view.endEditing(true)
            let oldPassword = self.oldPasswordView.textField.text ?? ""
            let newPassword = self.newPasswordView.textField.text ?? ""
            let reNewPassword = self.confirmPasswordView.textField.text ?? ""
            let captcha = self.captchaView.textField.text ?? ""
            showHud()
            service.changePassword(oldPassword: oldPassword,
                                   newPassword: newPassword,
                                   reNewPassword: reNewPassword,
                                   captcha: captcha,
                                   completion:{ (result) in
                                    self.hideHude()
                                    switch result {
                                    case .success(let message):
                                        self.dismiss(animated: true, completion: {
                                            self.completionBlock?(CompletionBlockResult(isCancelled: false, isSuccess: true, with: [NSLocalizedDescriptionKey: message]))
                                        })
                                    case .failure(let error):
                                        if (error as NSError).code == APIErrorCode.invalidCaptcha.rawValue {
                                            self.toast(error.localizedDescription)
                                            self.getCaptcha()
                                        } else {
                                            self.handleError(error as NSError, completion: { (result) in
                                                if result.isSuccess {
                                                    self.onSave()
                                                }
                                            })
                                        }
                                    }
            })
        }
    }
    
    internal func vertify() -> Bool {
        let oldPassword = self.oldPasswordView.textField.text ?? ""
        let newPassword = self.newPasswordView.textField.text ?? ""
        let reNewPassword = self.confirmPasswordView.textField.text ?? ""
        let captcha = self.captchaView.textField.text ?? ""
        
    
        if oldPassword.isEmpty  {
            toast(String.oldPassEmpty)
            oldPasswordView.textField.becomeFirstResponder()
            return false
        }
        
        if newPassword.isEmpty {
            toast(String.newPassEmpty)
            newPasswordView.textField.becomeFirstResponder()
            return false
        } else if newPassword.count < 6 {
            newPasswordView.textField.becomeFirstResponder()
            toast(String.shortPassword)
            return false
        }
        
        if newPassword == oldPassword {
            toast(String.differentOldPassword)
            newPasswordView.textField.becomeFirstResponder()
            return false
        }
        
        if reNewPassword.isEmpty {
            toast(String.confirmPassEmpty)
            confirmPasswordView.textField.becomeFirstResponder()
            return false
        }
        
        if newPassword != reNewPassword {
            toast(String.passwordNotMatch)
            confirmPasswordView.textField.becomeFirstResponder()
            return false
        }
        
        if captcha.isEmpty {
            toast(String.captchaEmpty)
            captchaView.textField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    @IBAction func performGetCaptcha(_ sender: UIButton) {
        getCaptcha()
    }

    func getCaptcha(completed: (() -> ())? = nil){
        let button = captchaButton
        captchaService.getCaptcha(completion: { (image,error) in
            if error != nil {
                DLog(error!)
            } else if let image = image {
                button?.setImage(image, for: .normal)
                button?.setTitle(nil, for: .normal)
                button?.backgroundColor = UIColor.white
                completed?()
            }
        })
    }
    
}

