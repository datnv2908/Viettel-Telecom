//
//  AuthorizeLinkAccountViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AuthorizeLinkAccountViewController: BaseViewController {

    @IBOutlet weak var phoneTextField: DarkTextField!
    @IBOutlet weak var captchaTextField: DarkTextField!
    @IBOutlet weak var captchaImageView: ImageCapcharView!

    @IBOutlet weak var getCaptcha: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var btnContact: UIButton!
    
    private let service = UserService()
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneTextField.placeholder = String.so_dien_thoai
        captchaTextField.placeholder = String.nhap_ma_captcha
        lbltitle.text = String.xac_thuc_lien_ket_tai_khoan
        lblDes.text = String.quy_khach_vui_long_lien_ket_tai_khoan_voi_so_dien_thoai_de_xem_cac_noi_dung_tinh_phi_tren_5Dmax
        
        btnContact.setTitle(String.lien_he_198_de_duoc_ho_tro, for: .normal)
        getCaptcha.setTitle(String.lay_ma_xac_thuc, for: .normal)
        
        // Do any additional setup after loading the view.
        view.backgroundColor = AppColor.grayBackgroundColor()
        self.captchaImageView.getCapchar(sucess: { () -> (Void) in
        }, failse: { (_) -> (Void) in
        })
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icClose"), style: .plain,
                                                                 target: self, action: #selector(onClose))
    }

    @objc func onClose() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    @IBAction func onGetCaptcha(_ sender: Any) {
        self.captchaImageView.getCapchar(sucess: { () -> (Void) in
        }, failse: { (message) -> (Void) in
            if let string = message {
                self.toast(string)
            }
        })
    }

    @IBAction func onGetOtp(_ sender: Any) {
        let phoneNumber = phoneTextField.text ?? ""
        if phoneNumber.isEmpty {
            toast(String.enterPhoneNumber)
        } else {
            showHud()
            service.getOTP(phoneNumber, completion: { (result) in
                self.hideHude()
                switch result {
                case .success( _):
                    let viewcontroller = LinkFBAccountViewController(phoneNumber)
                    self.navigationController?.pushViewController(viewcontroller, animated: true)
                    break
                case .failure(let error):
                    self.captchaImageView.getCapchar(sucess: { () -> (Void) in
                    }, failse: { (_) -> (Void) in
                    })
                    self.toast(error.localizedDescription)
                    break
                }
            })
        }
    }

    @IBAction func onCall198(_ sender: Any) {
        call(Constants.kSupportPhoneNumber)
    }
}

extension AuthorizeLinkAccountViewController {
    class func performLinkPhoneNumber(fromViewController: UIViewController!) {
        let viewcontroller = AuthorizeLinkAccountViewController.initWithNib()
        let nav = BaseNavigationViewController.initWithDefaultStyle(rootViewController: viewcontroller)
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = AppColor.grayBackgroundColor()
        nav.navigationBar.tintColor = UIColor.black
        fromViewController.present(nav, animated: true, completion: nil)
    }
}
