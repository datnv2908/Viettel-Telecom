//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony
import MessageUI
import GoogleSignIn

class LoginViewController: BaseViewController {
    var presenter: LoginViewControllerOutput?
    var viewModel: LoginViewModelOutput?
    var fromVC: BaseViewController?

    @IBOutlet weak var captchaHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var captchaTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var phoneNumberTextField: CustomTextField!
    @IBOutlet weak var captchaImageView: ImageCapcharView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var getPassButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var imgBg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginLabel.text = String.login
        registerButton.setTitle(String.dang_ky_tai_khoan, for: .normal)
        getPassButton.setTitle(String.lay_mat_khau, for: .normal)
        loginButton.setTitle(String.login, for: .normal)
        captchaTextField.placeholder = String.nhap_ma_xac_nhan
        passwordTextField.placeholder = String.nhap_mat_khau
        phoneNumberTextField.placeholder = String.nhap_so_dien_thoai
        if UIDevice.current.userInterfaceIdiom == .pad {
            imgBg.image = #imageLiteral(resourceName: "img_login_bg_ipad.png")
        }
        presenter?.viewDidLoad()
        setUpView()
        setUpDataForView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }

    // MARK: 
   // MARK: IBACTIONS

    @IBAction func reloadCaptcha(_ sender: Any) {
        self.getCaptcha()
    }

    @IBAction func login(_ sender: Any) {
        if isInvalidInput() {
            view.endEditing(true)
            presenter?.performLogin(username: phoneNumberTextField.text!,
                                    password: passwordTextField.text!,
                                    captcha: captchaTextField.text!)
        }
    }

    @IBAction func cancel(_ sender: Any) {
        presenter?.performCancelLogin(sender)
        self.getStatusBar()
    }

    @IBAction func loginFacebook(_ sender: Any) {
        view.endEditing(true)
        presenter?.performLoginFB(sender)
    }

    @IBAction func loginGoogle(_ sender: Any) {
        view.endEditing(true)
        presenter?.performLoginGG(sender)        
    }

    @IBAction func loginCecullar(_ sender: Any) {
        presenter?.performAutoLogin(phoneNumberTextField.text)
    }

    @IBAction func onRegister(_ sender: Any) {
        doShowMessageUI()
    }

    @IBAction func onForgotPassword(_ sender: Any) {
        doShowMessageUI()
    }

    func isInvalidInput() -> Bool {
        if (phoneNumberTextField.text?.isEmpty)! {
            toast(String.enterPhoneNumber)
            phoneNumberTextField.becomeFirstResponder()
            return false
        }
        if (phoneNumberTextField.text?.count)! < 6 || (phoneNumberTextField.text?.count)! > 15 {
            toast(String.invalidPhoneNumber)
            phoneNumberTextField.becomeFirstResponder()
            return false
        }
        if !(phoneNumberTextField.text?.isPhoneNumberInvalid())! {
            toast(String.invalidPhoneNumber)
            phoneNumberTextField.becomeFirstResponder()
            return false
        }

        if (passwordTextField.text?.isEmpty)! {
            passwordTextField.becomeFirstResponder()
            toast(String.enterPassword)
            return false
        }

        if captchaImageView.image != nil && (captchaTextField.text?.isEmpty)! {
            captchaTextField.becomeFirstResponder()
            toast(String.enterOTP)
            return false
        }

        return true
    }

    func setUpDataForView() {
        if captchaImageView.image != nil {
            captchaTextField.isHidden = false
            captchaImageView.isHidden = false
            captchaHeightConstraint.constant = passwordTextField.frame.size.height
        } else {
            captchaTextField.isHidden = true
            captchaImageView.isHidden = true
            captchaHeightConstraint.constant = 0
        }
    }
   
   func  setTheme (){
      if #available(iOS 13.0, *) {
      if let model = DataManager.getCurrentMemberModel() {
          if(traitCollection.userInterfaceStyle == .light) {
            DataManager.saveStatusBarStyle(styleBarStatus: UIStatusBarStyle.darkContent.rawValue)
            UIApplication.shared.statusBarStyle =  .darkContent
            appDelegate?.window?.overrideUserInterfaceStyle = .light
          } else {
            appDelegate?.window?.overrideUserInterfaceStyle = .dark
            DataManager.saveStatusBarStyle(styleBarStatus: UIStatusBarStyle.lightContent.rawValue)
            UIApplication.shared.statusBarStyle =  .lightContent
          }
        }
      }
   }
    func getCaptcha() {
        weak var weakSelf = self
        captchaImageView.getCapchar(sucess: { () -> (Void) in
            weakSelf?.setUpDataForView()
        }, failse: nil)
    }

    // MARK: 
  // MARK: METHODS
    func setUpView() {
        self.navigationItem.title = viewModel?.getTitle()
        self.hideKeyboardWhenTappedAround()
        self.captchaTextField.delegate = self
        self.passwordTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.registerButton.isHidden = true
    }
    
    func doShowMessageUI() {
        if (MFMessageComposeViewController.canSendText()) {
            let titleDict = [NSAttributedString.Key.foregroundColor: AppColor.deepSkyBlue90(),
                             NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
            UINavigationBar.appearance().titleTextAttributes = titleDict
            let controller = MFMessageComposeViewController()
            controller.body = "PW"
            controller.recipients = ["1583"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            toast(String.thiet_bi_khong_ho_tro_nhan_tin)
        }
    }
}

extension LoginViewController: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        let titleDict = [NSAttributedString.Key.foregroundColor: UIColor.white,
                         NSAttributedString.Key.font: AppFont.font(style: .bold, size: 19)]
        UINavigationBar.appearance().titleTextAttributes = titleDict
        controller.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        captchaTextField.resignFirstResponder()
        if textField == passwordTextField && !textField.text!.isEmpty {

            if captchaTextField.isHidden == true {
                textField.resignFirstResponder()
                presenter?.performLogin(username: phoneNumberTextField.text!,
                                        password: passwordTextField.text!,
                                        captcha: "")
            } else {
                captchaTextField.becomeFirstResponder()
            }
        } else if textField == captchaTextField {
            textField.resignFirstResponder()
            presenter?.performLogin(username: phoneNumberTextField.text!,
                                    password: passwordTextField.text!,
                                    captcha: captchaTextField.text!)
        }
        return true
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if textField == phoneNumberTextField {
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

extension LoginViewController: LoginViewControllerInput {
    func doRefreshView() {
        captchaImageView.image = viewModel?.captchaImage
        setUpDataForView()
    }
    
    func showCaptcha() {
        getCaptcha()
    }
}
