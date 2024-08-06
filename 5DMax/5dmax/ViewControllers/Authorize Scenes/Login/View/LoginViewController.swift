//
//  LoginViewController.swift
//  5dmax
//
//  Created by Hoang on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
//import FBSDKCoreKit
//import FBSDKLoginKit
import Reachability
import CoreTelephony
import MessageUI

class LoginViewController: BaseViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var txfPhone: DarkTextField!
    @IBOutlet weak var txfPass: DarkTextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnGetPass: UIButton!
    @IBOutlet weak var btnLoginSMS: UIButton!
    @IBOutlet weak var btnLoginFacebook: UIButton!
    @IBOutlet weak var lblContact198: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var captchaView: UIView!
    @IBOutlet weak var imgCaptcha: ImageCapcharView!
    @IBOutlet weak var txfCapchar: DarkTextField!
    @IBOutlet weak var mainViewConstantHeight: NSLayoutConstraint!
    @IBOutlet weak var btnGetDefaullPass: UIButton!
    @IBOutlet weak var txfCapcharConstantHeight: NSLayoutConstraint!

    @IBOutlet weak var btnContact198: UIButton!
    var presenter: LoginPresenter? = LoginPresenter()
    
    // MARK: 
   // MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSetUp()
        self.performSetUpDataForView()
        
        txfPhone.placeholder = "  " + String.so_dien_thoai
        txfPass.placeholder = "  " + String.mat_khau
        txfCapchar.placeholder = "  " + String.nhap_ma_captcha
        btnLogin.setTitle(String.dang_nhap, for: .normal)
        btnLogin.titleLabel?.font = AppFont.museoSanFont(style: .semibold, size: 15)
        btnLoginSMS.setTitle(String.dang_nhap_bang_SMS, for: .normal)
        btnLoginFacebook.setTitle(String.dang_nhap_bang_facebook, for: .normal)
        lblOr.text = String.hoac.uppercased()
        btnGetDefaullPass.setTitle(String.lay_mat_khau_mac_dinh, for: .normal)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack2"), style: .plain, target: self, action: #selector(onClose))
        self.navigationItem.titleView = UIView.titleViewItem()
        self.navigationItem.hidesBackButton = false
    }

    @objc func onClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override class func initWithNib() -> LoginViewController {
        var storyboardId = String(describing: self)
        if Constants.isIpad {
            storyboardId = "iPad"
        } else {
            storyboardId = "iPhone5"
            
            if Constants.screenHeight == 480 {
                storyboardId = "iPhone4"
            }
        }

        return LoginViewController.initWithDefautlStoryboardWithID(storyboardId: storyboardId)
    }

    // MARK: 
  // MARK: IBACTIONS
    @IBAction func btnClosePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btnLoginFacebookPressed(_ sender: Any) {
        performHideKeyboard()
//        let fbLoginManager = FBSDKLoginManager()
//        fbLoginManager.loginBehavior = .web
//        weak var weakSelf = self
//        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"],
//                             from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
//
//            if let err = error {
//                self.toast(err.localizedDescription)
//            } else if let response = result {
//                if response.isCancelled {
//                } else {
//                    DLog("facebook token " + response.token.tokenString)
//                    weakSelf?.presenter?.performLoginFacebookWithToken(token: response.token.tokenString,
//                                                                       facebookUserID: response.token.userID)
//                }
//            }
//        }
    }

    @IBAction func btnLoginPressed(_ sender: Any) {
        performHideKeyboard()
        if self.isInvalidInput() {
            presenter?.viewModel?.phone = txfPhone.text!
            presenter?.viewModel?.pass  = txfPass.text!
            presenter?.viewModel?.captcha = txfCapchar.text!
            presenter?.performLogin()
        }
    }

    @IBAction func btnSignUpPressed(_ sender: Any) {
        performHideKeyboard()
        presenter?.performSignUp()
    }

    @IBAction func btnGetPassPressed(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = "MK"
            controller.recipients = ["9545"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            toast(String.thiet_bi_khong_ho_tro_nhan_tin)
        }
    }

    @IBAction func btnLogin3G(_ sender: Any) {
        presenter?.peformLoginWith3G()
    }
    
    @IBAction func btnGetDefaultPass_action(_ sender: Any) {
        presenter?.performGetPass()
//        if MFMessageComposeViewController.canSendText() {
//            let controller = MFMessageComposeViewController()
//            controller.body = "CLAVE"
//            controller.recipients = ["8889"]
//            controller.messageComposeDelegate = self
//            self.present(controller, animated: true, completion: nil)
//        } else {
//            toast(String.thiet_bi_khong_ho_tro_nhan_tin)
//        }
    }

    @IBAction func btnRefreshCapchaPressed(_ sender: Any) {
        performGetCapchar()
    }

    @IBAction func btnContact198(_ sender: Any) {
        call(Constants.kSupportPhoneNumber)
    }
    // MARK: 
 // MARK: METHODS
    func performHideKeyboard() {
        view.endEditing(true)
    }

    func performSetUp() {
        presenter?.view = self
        presenter?.wireFrame?.hostViewController = self
        txfCapchar.textColor = UIColor.red
        btnGetDefaullPass.titleLabel?.adjustsFontSizeToFitWidth = true
        view.backgroundColor = AppColor.grayBackgroundColor()
    }

    func isInvalidInput() -> Bool {
        if (txfPhone.text?.characters.isEmpty)! {
            toast(String.enterPhoneNumber)
            return false
        }

        if (txfPass.text?.characters.isEmpty)! {
            toast(String.enterPassword)
            return false
        }
        return true
    }

    func performSetUpDataForView() {
        if imgCaptcha.image != nil {
            captchaView.isHidden = false
            txfCapchar.isHidden = false
            txfCapchar.placeholder = presenter?.viewModel?.captchaPlaceHolder
            txfCapcharConstantHeight.constant = txfPass.frame.size.height
        } else {
            captchaView.isHidden = true
            txfCapchar.isHidden = true
            txfCapcharConstantHeight.constant = 0
        }
    }

    func performGetCapchar() {
        weak var weakSelf = self
        imgCaptcha.getCapchar(sucess: { () -> (Void) in
            weakSelf?.performSetUpDataForView()
        }, failse: nil)
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: 
extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txfPass.resignFirstResponder()
        if textField == txfPass && !textField.text!.characters.isEmpty {
            if txfCapchar.isHidden == true {
                textField.resignFirstResponder()
                presenter?.viewModel?.phone = txfPhone.text!
                presenter?.viewModel?.pass  = txfPass.text!
                presenter?.performLogin()
            } else {

                txfCapchar.becomeFirstResponder()
            }
        } else if textField == txfCapchar {
            textField.resignFirstResponder()
            presenter?.viewModel?.phone = txfPhone.text!
            presenter?.viewModel?.pass  = txfPass.text!
            presenter?.viewModel?.captcha = txfCapchar.text!
            presenter?.performLogin()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == txfPhone {
            let textFieldText: NSString = (textField.text ?? "") as NSString
            if textFieldText.length == 1 {
                return true
            }
            let searchStr = textFieldText.replacingCharacters(in: range, with: string)
            return searchStr.isPhoneNumberInvalid()
        }
        return true
    }
}

// MARK: 
extension LoginViewController {
    class func performLogin(fromViewController: UIViewController!) {
        let loginVC = LoginViewController.initWithNib()
        let nav = BaseNavigationViewController.initWithDefaultStyle(rootViewController: loginVC)
        fromViewController.present(nav, animated: true, completion: nil)
    }
}
