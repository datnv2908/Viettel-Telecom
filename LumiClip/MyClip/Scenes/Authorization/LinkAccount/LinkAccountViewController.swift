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
    
    var completionBlock: CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        otpView.mode = .normal
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconEscape"), style: .plain, target: self, action: #selector(onClose))
    }
    
    @objc func onClose() {
        self.dismiss(animated: true, completion: {
            self.completionBlock?(CompletionBlockResult(isCancelled: true, isSuccess: false))
        })
    }
    
    @IBAction func performOTPCreate(_ sender: UIButton) {
        //let phoneNumber = numberTextField.text
        //TODO
        let phoneNumber = phoneNumberView.textField.text ?? ""
        if phoneNumber.isEmpty {
            toast(String.enterPhoneNumber)
            phoneNumberView.textField.becomeFirstResponder()
        } else {
            showHud()
            userService.getOTP(msidn: phoneNumber, completion: { (result) in
                self.hideHude()
                switch result {
                case .failure(let err):
                    self.toast(err.localizedDescription)
                case .success(let response):
                    self.toast(response.data)
                }
            })
        }
        
    }
    
    @IBAction func performLinkAccount(_ sender: UIButton) {
        //TODO
        //show captcha box
        if vertify() {
            let phoneNumber = phoneNumberView.textField.text!
            let otp = otpView.textField.text!
            self.showHud()
            userService.mapAccount(msidn: phoneNumber, otp: otp, completion: { (result) in
                self.hideHude()
                switch result {
                case .success(let response):
                    self.toast(response.data)
                    if let model = DataManager.getCurrentMemberModel() {
                        if model.msisdn.isEmpty {
                            model.msisdn = phoneNumber
                        }
                        //print ("update new token: \(response.newAccessToken)")
                        if(!response.newAccessToken.isEmpty){
                            model.accessToken = response.newAccessToken
                        }
                        
                        model.isShowPromotionAPP = response.isShowPromotionAPP
                        
                        DataManager.saveMemberModel(model)
                    }
                    
                    self.dismiss(animated: true, completion: {
                        self.completionBlock?(CompletionBlockResult(isCancelled: false,
                                                                    isSuccess: true,
                                                                    with: [NSLocalizedDescriptionKey: response.data]))
                    })
                    break
                case .failure(let error):
                    self.toast(error.localizedDescription)
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
        self.phoneNumberView.textField.keyboardType = UIKeyboardType.numberPad
        self.phoneNumberView.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
        //hide captcha box
        isCaptchaViewHidden = true
    }
    
    //config statusbar text
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return .lightContent
//    }
    
    func vertify() ->Bool {
        let phoneNumber = phoneNumberView.textField.text ?? ""
        let otp = otpView.textField.text ?? ""
        let captcha = captchaView.textField.text ?? ""
        if phoneNumber == "" {
            toast(String.enterPhoneNumber)
            phoneNumberView.textField.becomeFirstResponder()
            return false
        }
        
        if phoneNumber.phoneNumber().count > 10 || phoneNumber.phoneNumber().count < 9 {
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! {
            otpButton.backgroundColor = AppColor.deepSkyBlue90()
        } else {
            otpButton.backgroundColor = AppColor.warmGreyTwo()
        }
    }
}

