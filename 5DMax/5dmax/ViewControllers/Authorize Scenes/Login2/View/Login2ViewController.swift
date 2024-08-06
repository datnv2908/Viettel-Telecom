//
//  Login2ViewController.swift
//  5dmax
//
//  Created by Hoang on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class Login2ViewController: BaseViewController {

    @IBOutlet weak var txfPhone: DarkTextField!
    @IBOutlet weak var btnContinue: UIButton!

    let service = UserService()
    // MARK: 
    // MARK: VIEW LIFE SCYLER
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txfPhone.placeholder = String.so_dien_thoai
        btnContinue.setTitle(String.tiep_tuc, for: .normal)
        view.backgroundColor = AppColor.blackLogingroundColor()
        navigationItem.title = String.dang_ky_moi
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icBack2"), style: .plain, target: self, action: #selector(onBackBarButton))
        txfPhone.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override class func initWithNib() -> Login2ViewController {
        var storyboardId = String(describing: self)
        if Constants.isIpad {
            storyboardId = "iPad"
        }
        return Login2ViewController.initWithDefautlStoryboardWithID(storyboardId: storyboardId)
    }

    // MARK: 
    // MARK: IBACTIONS
    
    @IBAction func btnBackPressed(_ sender: Any) {

        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }

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
                    let viewcontroller = Login4ViewController.initWithNib()
                    viewcontroller.toast(message as! String)
                    viewcontroller.phoneNumber = phone
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                } else {
                    let viewcontroller = Login5ViewController.initWithNib()
                    viewcontroller.phoneNumber = phone
                    viewcontroller.title = String.dang_ky_moi
                    viewcontroller.toast(message as! String)
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                }
                break
            case .failure(let error):
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
                self.getLoginOTP(phone: phone, isNewUser: newUser)
//                if (newUser) {
//                    let popupViewController = AlertPopupViewController.init(titleStr: "", message: String.user_moi,
//                                                                            cancelTitle: String.OK_base)
//                    popupViewController.cancelDialog = {(_) in
//                        self.getLoginOTP(phone: phone, isNewUser: newUser)
//                    }
//                    self.present(popupViewController, animated: true, completion: nil)
//                } else {
//                    self.getLoginOTP(phone: phone, isNewUser: newUser)
//                }
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

extension Login2ViewController: UITextFieldDelegate {

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
