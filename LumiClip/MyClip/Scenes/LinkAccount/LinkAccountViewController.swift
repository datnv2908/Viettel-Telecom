//
//  LinkPhoneNumberViewController.swift
//  UserMenu
//
//  Created by sunado on 9/7/17.
//  Copyright © 2017 sunado. All rights reserved.
//

import UIKit

class LinkAccountViewController: BaseViewController {
    
    @IBOutlet weak var phoneNumberView: TextFieldFormView!
    @IBOutlet weak var otpView: TextFieldFormView!
    @IBOutlet weak var captchaView: TextFieldFormView!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var linkAccountButton: UIButton!
    @IBOutlet weak var captchaButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var captchaViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var captchaViewTopContraint: NSLayoutConstraint!
    internal let userService = UserService()
    internal let captchaService = CaptcharService()
    var isCaptchaViewHidden: Bool {
        get {
            return captchaViewHeightContraint.constant == 0
        }
        set(val) {
            if val == false {
                getCaptcha(){
                    self.captchaViewHeightContraint.constant = 48
                    self.captchaViewTopContraint.constant = 20
                }
            } else {
                captchaViewHeightContraint.constant = 0
                captchaViewTopContraint.constant = 0
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func performOTPCreate(_ sender: UIButton) {
        //let phoneNumber = numberTextField.text
        //TODO
    }
    
    @IBAction func performLinkAccount(_ sender: UIButton) {
        //TODO
        //show captcha box
        isCaptchaViewHidden = false
        
        if vertify() {
            let phoneNumber = phoneNumberView.textField.text!
            let otp = otpView.textField.text!
            self.showHud()
            userService.mapAccount(msidn: phoneNumber, otp: otp, completion: { (result) in
                switch result {
                case .success(let json):
                    let responseCode = json["responseCode"].intValue
                    let message = json["message"].stringValue
                    print (responseCode)
                    self.toast(message)
                    self.hideHude()
                    self.navigationController?.popViewController(animated: true)
                    break
                case .failure( _):
                    self.toast(String.changePasswordFail)
                }
            })
        }
    }
    
    @IBAction func performGetCaptcha(_ sender: UIButton) {
        getCaptcha()
    }
    
    override func setupView() {
        //set up text title
        hintLabel.text = String.linkAccountHint
        otpButton.setTitle(String.getOTPCode, for: .normal)
        linkAccountButton.setTitle(String.LINKACCOUNT, for: .normal)
        //setup border
        setupBorderAndShadow(layer: otpButton.layer)
        setupBorderAndShadow(layer: linkAccountButton.layer, radius: 3)
        //setup nav
        setupNavigation()
        //set view mode
        phoneNumberView.mode = .number
        phoneNumberView.title = String.phoneNumberEnter
        phoneNumberView.maxNumberCharracters = 11
        
        otpView.mode = .number
        otpView.title = String.enterOTPCode
        
        captchaView.mode = .normal
        captchaView.title = String.enterCaptcha
        
    }
    
    //set border and shadow of button
    func setupBorderAndShadow(layer: CALayer, radius: CGFloat = 5){
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 145/255, green: 145/255, blue: 145/255, alpha: 1).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func setupNavigation(){
        //add title
        self.navigationItem.title = String.linkAccount
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //config statusbar
        UIApplication.shared.statusBarStyle = .lightContent
        //hide captcha box
        isCaptchaViewHidden = true
    }
    
    //config statusbar text
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func popBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func vertify() ->Bool {
        let phoneNumber = phoneNumberView.textField.text ?? ""
        let otp = otpView.textField.text ?? ""
        let captcha = captchaView.textField.text ?? ""
        if phoneNumber == "" {
            toast(String.enterPhoneNumber)
            phoneNumberView.textField.becomeFirstResponder()
            return false
        }
        
        if phoneNumber.phoneNumber().characters.count > 10 || phoneNumber.phoneNumber().characters.count < 9 {
            toast(String.phoneNumberNotValid)
            phoneNumberView.textField.becomeFirstResponder()
            return false
        }
        
        if  otp == "" {
            toast(String.enterOTP)
            otpView.textField.becomeFirstResponder()
            return false
        }
        
        if isCaptchaViewHidden == false && captcha == "" {
            toast(String.captchaEmpty)
            captchaView.textField.becomeFirstResponder()
            return false
        }
        
        return true
    }
    
    func getCaptcha( completed: (() -> ())? = nil){
        let button = captchaButton
        captchaService.getCaptcha(completion: { (image,error) in
            if error != nil {
                DLog(error!)
            } else if let image = image {
                button?.setBackgroundImage(image, for: .normal)
                button?.setTitle("", for: .normal)
                completed?()
            }
        })
    }
}

