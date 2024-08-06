//
//  Login6InputViewController.swift
//  5dmax
//
//  Created by Đào Văn Nghiên on 2/4/20.
//  Copyright © 2020 Huy Nguyen. All rights reserved.
//

import UIKit

class Login6InputViewController: BaseViewController {
    
    @IBOutlet weak var txfPhone: DarkTextField!
    @IBOutlet weak var btnContinue: UIButton!
    var isFromChangePass = false
    var parentVC: UIViewController?
    
    let service = UserService()
    // MARK:
    // MARK: VIEW LIFE SCYLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txfPhone.placeholder = String.so_dien_thoai
        btnContinue.setTitle(String.tiep_tuc, for: .normal)
        btnContinue.titleLabel?.font = AppFont.museoSanFont(style: .semibold, size: 15)
        view.backgroundColor = AppColor.blackLogingroundColor()
        navigationItem.title = String.quen_mat_khau
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack2"), style: .plain, target: self, action: #selector(onBackBarButton))
        
        
        if (isFromChangePass) {
            if let user = DataManager.getCurrentMemberModel() {
                txfPhone.text = user.msisdn
            }
        } else {
            txfPhone.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:
    // MARK: IBACTIONS
    
    @IBAction func btnContinuePressed(_ sender: Any) {
        txfPhone.resignFirstResponder()
        if let phone = txfPhone.text {
            if phone.isEmpty {
                toast(String.enterPhoneNumber)
            }
            if phone.isPhoneNumberInvalid() {
                showHud()
                checkNewUser(phone: phone)
            } else {
                DLog(String.invalidPhoneNumber)
            }
        }
    }
    
    func getLoginOTP(phone: String, isNewUser: Bool) {
        weak var weakSelf = self
        service.getLoginSMSOTP(phone, completion: {(result) in
            weakSelf?.hideHude()
            switch result {
            case .success(let message):
                if (isNewUser) {
                    if (self.isFromChangePass) {
                        if let vc = self.parentVC as? ChangePassViewController {
                            vc.isFromOTP = true
                        }
                        self.navigationController?.popViewController(animated: true)
                        Constants.appDelegate.rootViewController.toast(message as! String)
                    } else {
                        let viewcontroller = Login4ViewController.initWithNib()
                        viewcontroller.toast(message as! String)
                        viewcontroller.phoneNumber = phone
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                    }
                } else {
                    if (self.isFromChangePass) {
                        if let vc = self.parentVC as? ChangePassViewController {
                            vc.isFromOTP = true
                        }
                        self.navigationController?.popViewController(animated: true)
                        Constants.appDelegate.rootViewController.toast(message as! String)
                    } else {
                        let viewcontroller = Login5ViewController.initWithNib()
                        viewcontroller.phoneNumber = phone
                        viewcontroller.title = String.quen_mat_khau
                        viewcontroller.toast(message as! String)
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                    }
                }
                break
            case .failure(let error):
                self.hideHude()
                self.toast(error.localizedDescription)
                break
            }
        })
    }
    
    func checkNewUser(phone: String) {
        service.checkUserNew(phoneNumber: phone, completion: { (result) in
            switch result {
            case .success(let isNewUser):
                let newUser = isNewUser as! Bool
                if (newUser) {
                    let popupViewController = AlertPopupViewController.init(titleStr: "", message: String.user_moi,
                                                                            cancelTitle: String.OK_base)
                    popupViewController.cancelDialog = {(_) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    self.present(popupViewController, animated: true, completion: nil)
                } else {
                    self.getLoginOTP(phone: phone, isNewUser: newUser)
                }
                break
            case .failure(let error):
                self.hideHude()
                self.toast(error.localizedDescription)
                break
            }
        })
    }
    
    //MARK:
    //MARK: METHODS
    
    @objc func onBackBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        service.cancelAllRequests()
    }
}

extension Login6InputViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        if textFieldText.length == 1 {
            return true
        }
        let searchStr = textFieldText.replacingCharacters(in: range, with: string)
        return searchStr.isPhoneNumberInvalid()
    }
}

