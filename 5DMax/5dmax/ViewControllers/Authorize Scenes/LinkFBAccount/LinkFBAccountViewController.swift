//
//  LinkFBAccountViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class LinkFBAccountViewController: BaseViewController {

    @IBOutlet weak var otpTextField: DarkTextField!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var btnResendOTP: UIButton!

    private var service = UserService()

    private var phoneNumber: String

    init(_ phone: String) {
        phoneNumber = phone
        super.init(nibName: "LinkFBAccountViewController", bundle: Bundle.main)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        otpTextField.placeholder = String.ma_xac_thuc
        lbltitle.text = String.xac_thuc_lien_ket_tai_khoan
        btnConnect.setTitle(String.lien_ket_tai_khoan, for: .normal)
        btnContact.setTitle(String.lien_he_198_de_duoc_ho_tro, for: .normal)
        btnResendOTP.setTitle(String.gui_lai_ma, for: .normal)
        
        // Do any additional setup after loading the view.
        view.backgroundColor = AppColor.grayBackgroundColor()
        phoneLabel.text = "\(String.otpSentToPhoneNumber) \(phoneNumber)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func onLinkAccount(_ sender: Any) {
        let otp = otpTextField.text ?? ""
        if otp.isEmpty {
            toast(String.enterOTP)
        } else {
            service.mapAccount(msidn: phoneNumber, otp: otp, completion: { (result) in
                switch result {
                case .success(_):
                    if let model = DataManager.getCurrentMemberModel() {
                        model.msisdn = self.phoneNumber
                        DataManager.saveMemberModel(model)
                    }
                    self.toast(String.linkSuccess)
                    self.dismiss(animated: true, completion: nil)
                    break
                case .failure(let error):
                    self.toast(error.localizedDescription)
                }
            })
        }
    }

    @IBAction func onResendOtp(_ sender: UIButton) {
        sender.isEnabled = false
        service.getOTP(phoneNumber) { (result) in
            sender.isEnabled = true
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.toast(error.localizedDescription)
                break
            }
        }
    }

    @IBAction func onCall198(_ sender: Any) {
        call(Constants.kSupportPhoneNumber)
    }
}
