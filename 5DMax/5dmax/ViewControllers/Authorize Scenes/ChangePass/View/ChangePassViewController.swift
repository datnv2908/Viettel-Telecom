//
//  ChangePassViewController.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import MessageUI

class ChangePassViewController: BaseViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var txfOldPassword: DarkTextField!
    @IBOutlet weak var txfNewPassword: DarkTextField!
    @IBOutlet weak var txfRepeatPass: DarkTextField!
    @IBOutlet weak var txfCaptcha: DarkTextField!
    @IBOutlet weak var imgCaptcha: ImageCapcharView!
    
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnForgot: UIButton!

    let viewModel = ChangePassViewModel()
    var isFromOTP = false
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        getCaptcha()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txfOldPassword.placeholder = String.nhap_mat_khau_cu
        txfNewPassword.placeholder = String.nhap_mat_khau_moi
        txfRepeatPass.placeholder = String.xac_nhan_mat_khau_moi
        txfCaptcha.placeholder = String.nhap_ma_captcha
        
        btnChangePass.setTitle(String.doi_mat_khau, for: .normal)
        btnChangePass.titleLabel?.font = AppFont.museoSanFont(style: .semibold, size: 15)
        btnForgot.setTitle(String.quen_mat_khau, for: .normal)
        
        setData()
        self.title = viewModel.title
        view.backgroundColor = AppColor.grayBackgroundColor()
        
        getCaptcha()
    }

    @IBAction func btnChangeCaptcha(_ sender: Any) {
        getCaptcha()
    }

    @IBAction func btnForgotPass(_ sender: Any) {
        let login6VC = Login6InputViewController.initWithNib()
        login6VC.isFromChangePass = true
        login6VC.parentVC = self
        self.navigationController?.pushViewController(login6VC, animated: true)
        
        /*
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = "MK"
            controller.recipients = ["9545"]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else {
            toast(String.messageNotSupport)
        }
        */
    }

    @IBAction func btnChangePassword(_ sender: Any) {
        if isInvalidInput() {
            let service = UserService()
            service.changePassword(password: txfOldPassword.text!, newPassword: txfNewPassword.text!,
                                   reNewPassword: txfRepeatPass.text!, captcha: txfCaptcha.text!, isFromOTP: self.isFromOTP,
                                   completion: { (result) in
                switch result {
                case .success(_):
                    _ = self.navigationController?.popViewController(animated: true)
                    self.navigationController?.toast(String.changePasswordSuccess)
                    break
                case .failure(let error):
                    self.getCaptcha()
                    self.toast(error.localizedDescription)
                    break
                }
            })
        }
    }

    func getCaptcha() {
        imgCaptcha.getCapchar(sucess: { () -> (Void) in
        }, failse: nil)
    }
    
    func setData() {
        txfCaptcha.text = viewModel.captcha
        txfOldPassword.text = viewModel.oldPass
        txfRepeatPass.text = viewModel.repeatPass
        txfNewPassword.text = viewModel.newPass
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func isInvalidInput() -> Bool {

        if (txfOldPassword.text?.characters.isEmpty)! {
            toast(String.enterPassword)
            return false
        }
        if (txfNewPassword.text?.characters.isEmpty)! {
            toast(String.enterNewPassword)
            return false
        }
        if (txfRepeatPass.text?.characters.isEmpty)! {
            toast(String.enterConfirmPassword)
            return false
        }
        if (txfCaptcha.text?.characters.isEmpty)! {
            toast(String.enterCaptcha)
            return false
        }
        if txfNewPassword.text != txfRepeatPass.text {
            toast(String.confirmPasswordNotMatch)
            return false
        }

        return true
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
}
