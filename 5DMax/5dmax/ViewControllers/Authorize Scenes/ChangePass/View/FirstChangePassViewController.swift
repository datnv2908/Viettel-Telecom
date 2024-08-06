//
//  FirstChangePassViewController.swift
//  5dmax
//
//  Created by nghiendv ♥️ on 12/13/19.
//  Copyright © 2019 Huy Nguyen. All rights reserved.
//

import UIKit

class FirstChangePassViewController: BaseViewController {
    
    @IBOutlet weak var txfOldPassword: DarkTextField!
    @IBOutlet weak var txfNewPassword: DarkTextField!
    @IBOutlet weak var txfRepeatPass: DarkTextField!
    @IBOutlet weak var txfCaptcha: DarkTextField!
    @IBOutlet weak var imgCaptcha: ImageCapcharView!
    
    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lbText: UILabel!
//    @IBOutlet weak var lbTitle: UILabel!
    
    let viewModel = ChangePassViewModel()
    var isFromOTP: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        let str = NSString(string: String.xem_dieu_khoan)
        let theRange = str.range(of: String.dieu_khoan)
        
        let attributedString = NSMutableAttributedString(string: String.xem_dieu_khoan)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: theRange)
        self.lbText.attributedText = attributedString
        
//        lbTitle.text = String.doi_mat_khau.uppercased()
        
        txfOldPassword.placeholder = "  " + String.mat_khau_tam_thoi
//        txfOldPassword.backgroundColor = .white
//        txfOldPassword.layer.borderWidth = 1.0
//        txfOldPassword.layer.borderColor = UIColor.gray.cgColor
        
        txfNewPassword.placeholder = "  " + String.nhap_mat_khau_moi
//        txfNewPassword.backgroundColor = .white
//        txfNewPassword.layer.borderWidth = 1.0
//        txfNewPassword.layer.borderColor = UIColor.gray.cgColor
        
        txfRepeatPass.placeholder = "  " + String.xac_nhan_mat_khau_moi
//        txfRepeatPass.backgroundColor = .white
//        txfRepeatPass.layer.borderWidth = 1.0
//        txfRepeatPass.layer.borderColor = UIColor.gray.cgColor
        
        txfCaptcha.placeholder = "  " + String.nhap_ma_captcha
//        txfCaptcha.backgroundColor = .white
//        txfCaptcha.layer.borderWidth = 1.0
//        txfCaptcha.layer.borderColor = UIColor.gray.cgColor
        
        btnChangePass.setTitle(String.doi_mat_khau, for: .normal)
        btnChangePass.titleLabel?.font = AppFont.museoSanFont(style: .semibold, size: 15)
        getCaptcha()
        setData()
        self.title = viewModel.title
//        view.backgroundColor = AppColor.grayBackgroundColor()
    }
    
    func setupView() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack2"), style: .plain, target: self, action: #selector(onBackBarButton))
    }
    
    @objc func onBackBarButton() {
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnChangeCaptcha(_ sender: Any) {
        getCaptcha()
    }
    
    @IBAction func btnTermPressed(_ sender: Any) {
        let termVC = TermPopupViewController.initWithNib()
        self.present(termVC, animated: true, completion: nil)
    }
    
    @IBAction func btnChangePassword(_ sender: Any) {
        if isInvalidInput() {
            let service = UserService()
            service.changePassword(password: txfOldPassword.text!, newPassword: txfNewPassword.text!,
                                   reNewPassword: txfRepeatPass.text!, captcha: txfCaptcha.text!, isFromOTP: isFromOTP,
                                   completion: { (result) in
                                    switch result {
                                    case .success(_):
                                        let popupViewController = AlertPopupViewController.init(titleStr: String.thong_bao, message: String.changePasswordSuccess,
                                                                                                cancelTitle: String.cancel)
                                        popupViewController.cancelDialog = {(_) in
                                            self.navigationController?.dismiss(animated: true, completion: nil)
                                        }
                                        self.present(popupViewController, animated: true, completion: nil)
                                        break
                                    case .failure(let error):
                                        self.toast(error.localizedDescription)
                                        self.getCaptcha()
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

}
