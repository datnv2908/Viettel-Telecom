//
//  UpdateAccountInforViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import MobileCoreServices
import DLRadioButton

class UpdatePaymentInforViewController: BaseViewController {
    let eventService = EventService()
    let service = AppService()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var rdButtonBank: DLRadioButton!
    @IBOutlet weak var rdButtonVTPay: DLRadioButton!
    
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var searchBtn1Btn: UIButton!
    @IBOutlet weak var searchBtn2Btn: UIButton!
    
    @IBOutlet weak var contraintBankInforHeight: NSLayoutConstraint!
    @IBOutlet weak var bankInforView: UIView!
    @IBOutlet weak var tfAccountNo: UITextField!
    @IBOutlet weak var tfBankName: UITextField!
    @IBOutlet weak var tfBankBranche: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfMSTNumber: UITextField!
    
    
    @IBOutlet weak var vtpInforView: UIView!
    @IBOutlet weak var contraintVTPInforHeight: NSLayoutConstraint!
    @IBOutlet weak var tfVTPPhone: UITextField!
    @IBOutlet weak var tfVTPAddress: UITextField!
    @IBOutlet weak var tfVTPMST: UITextField!
    @IBOutlet weak var tvGoToVTP: UITextView!

   
    var contractInfor = ContractInfor()
    init(_ infor: ContractInfor) {
        contractInfor = infor
        super.init(nibName: "UpdatePaymentInforViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      backgroundView.backgroundColor = UIColor.setViewColor()
      vtpInforView.backgroundColor = UIColor.setViewColor()
      bankInforView.backgroundColor = UIColor.setViewColor()
      tvGoToVTP.backgroundColor = UIColor.setViewColor()
//        navigationItem.title = String.hinh_thuc_nhan_tien
        navigationItem.title = String.payment_infomation
        rdButtonVTPay.setTitleColor(UIColor.settitleColor(), for: .normal)
        okBtn.setTitle(String.tiep_tuc, for: .normal)
//        cancelBtn.setTitle(String.huy, for: .normal)
      searchBtn1Btn.setTitle(String.tra_cuu_mst, for: .normal)
      searchBtn2Btn.setTitle(String.tra_cuu_mst, for: .normal)
      searchBtn1Btn.setTitleColor(UIColor.settitleColor(), for: .normal)
      searchBtn2Btn.setTitleColor(UIColor.settitleColor(), for: .normal)
      rdButtonBank.setTitleColor(UIColor.settitleColor(), for: .normal)
      rdButtonVTPay.setTitle(String.cash_by_viettel_pay, for: .normal)
        rdButtonBank.setTitle(String.bank_account, for: .normal)
        rdButtonVTPay.setTitle(String.cash_by_viettel_pay, for: .normal)
        tfVTPPhone.placeholder = String.phone_number
        tfVTPAddress.placeholder = String.permanent_address
        tfVTPMST.placeholder = String.tax_code
        
        tfAccountNo.placeholder = String.bank_account_number
        tfBankName.placeholder = String.bank
        tfBankBranche.placeholder = String.branch
        tfAddress.placeholder = String.permanent_address
        tfMSTNumber.placeholder = String.tax_code
        
        registerKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        if(contractInfor.paymentType.count > 0) {
            displayByAccountInfor()
        } else {
            self.service.getContractCondition()
                { (result) in
                    switch result {
                    case .success(let response):
                        self.contractInfor = response.data
                        self.displayByAccountInfor()
                        break
                    case .failure(_):
                        self.displayDefaultValue()
                        break
                    }
            }
        }
        
        tvGoToVTP.isEditable = false
        tvGoToVTP.dataDetectorTypes = UIDataDetectorTypes.link
        let attributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: UIColor.settitleColor()
        ]
      let data = Data("<a href=\"https://apps.apple.com/us/app/id1484826743\">here <a>".utf8)
      if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
         let attributedQuote = NSMutableAttributedString(string:  String.link_register_viettel_pay, attributes: attributes)
         attributedQuote.append(attributedString)
           tvGoToVTP.attributedText = attributedQuote
      }
//
   
            
    }
    
    func displayDefaultValue(){
        contraintVTPInforHeight.constant = 0
        vtpInforView.isHidden = true
        rdButtonVTPay.isSelected = false
        
        contraintBankInforHeight.constant = 260
        bankInforView.isHidden = false
        rdButtonBank.isSelected = true
    }
    
    func displayByAccountInfor(){
        if(contractInfor.paymentType.elementsEqual("BANK_ACCOUNT")){
            tfBankName.text = contractInfor.bankName
            tfBankBranche.text = contractInfor.bankDepartment
            tfAddress.text = contractInfor.address
            tfMSTNumber.text = contractInfor.taxCode
            tfAccountNo.text = contractInfor.accountNumber
            
            contraintVTPInforHeight.constant = 0
            vtpInforView.isHidden = true
            contraintBankInforHeight.constant = 260
            bankInforView.isHidden = false
            rdButtonBank.isSelected = true
        }else{
            tfVTPPhone.text = contractInfor.msisdnPay
            tfVTPMST.text = contractInfor.taxCode
            tfVTPAddress.text = contractInfor.address
            
            contraintVTPInforHeight.constant = 260
            vtpInforView.isHidden = false
            contraintBankInforHeight.constant = 0
            bankInforView.isHidden = true
            rdButtonVTPay.isSelected = true
        }
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionOpenMST(_ sender: Any) {
        guard let url = URL(string: "https://www.tncnonline.com.vn/Pages/TracuuMST.aspx") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpdateInfor(_ sender: Any) {
        if(rdButtonVTPay.isSelected){
            updateVTPInfor()
        }else{
            updateBankInfor()
        }
    }
    
    func updateBankInfor(){
        
        let accountNo = self.tfAccountNo.text
        if (!self.tfAccountNo.hasText)
        {
            self.toast(String.EnterAccountNo)
            self.tfAccountNo.becomeFirstResponder()
            return
        }
        
        let bankName = self.tfBankName.text
        if (!self.tfBankName.hasText)
        {
            self.toast(String.EnterBankInfor)
            self.tfBankName.becomeFirstResponder()
            return
        }
        
        let bankBranche = self.tfBankBranche.text
        if (!self.tfBankBranche.hasText)
        {
            self.toast(String.EnterBankBranche)
            self.tfBankBranche.becomeFirstResponder()
            return
        }
        
        let bankAddress = self.tfAddress.text
        if (!self.tfAddress.hasText)
        {
            self.toast(String.EnterBankAddress)
            self.tfAddress.becomeFirstResponder()
            return
        }
        
        let taxCode = self.tfMSTNumber.text
        if (!self.tfMSTNumber.hasText)
        {
            self.toast(String.EnterMST)
            self.tfMSTNumber.becomeFirstResponder()
            return
        }
        
        
        self.showHud()
    
        service.updateBankPaymentInfor(accountNumber: accountNo!, bankName: bankName!, bankDepartment: bankBranche!, address: bankAddress!, taxCode: taxCode!){ (result) in
            switch result {
            case .success(_):
                self.service.confirmContract(self.contractInfor.status)
                    { (result) in
                        switch result {
                        case .success(_):
                            self.toast(String.cap_nhat_thanh_cong)
                            let navigationController = self.navigationController;
                            navigationController?.popToRootViewController(animated: false)
                            let updateInforVC = ContractPendingViewController(1, reason: "")
                            navigationController?.pushViewController(updateInforVC, animated: true)
                        case .failure(let error):
                            self.toast(error.localizedDescription)
                        }
                        self.hideHude()
                }
                
            case .failure(let error):
                self.toast(error.localizedDescription)
                self.hideHude()
            }
        }
    }
    
    func updateVTPInfor(){
        let vtpPhone = self.tfVTPPhone.text
        if (!self.tfVTPPhone.hasText)
        {
            self.toast(String.EnterVTPPhone)
            self.tfVTPPhone.becomeFirstResponder()
            return
        }
        
        let bankAddress = self.tfVTPAddress.text
        if (!self.tfVTPAddress.hasText)
        {
            self.toast(String.EnterBankAddress)
            self.tfVTPAddress.becomeFirstResponder()
            return
        }
        
        let taxCode = self.tfVTPMST.text
        if (!self.tfVTPMST.hasText)
        {
            self.toast(String.EnterMST)
            self.tfVTPMST.becomeFirstResponder()
            return
        }
        
        
        self.showHud()
        
        service.updateVTPPaymentInfor(phoneNumber: vtpPhone!, address: bankAddress!, taxCode: taxCode!)
            { (result) in
            switch result {
            case .success(_):
                self.service.confirmContract(self.contractInfor.status)
                { (result) in
                    switch result {
                    case .success(_):
                        self.toast(String.cap_nhat_thanh_cong)
                        let navigationController = self.navigationController;
                        navigationController?.popToRootViewController(animated: false)
                        let updateInforVC = ContractPendingViewController(1, reason: "")
                        navigationController?.pushViewController(updateInforVC, animated: true)
                    case .failure(let error):
                        self.toast(error.localizedDescription)
                    }
                    self.hideHude()
                }
            case .failure(let error):
                self.toast(error.localizedDescription)
                self.hideHude()
            }
        }
    }
    
    @IBAction func onClickBankInfor(_ sender: Any) {
        if(bankInforView.isHidden){
            contraintVTPInforHeight.constant = 0
            vtpInforView.isHidden = true

            contraintBankInforHeight.constant = 260
            bankInforView.isHidden = false
            
            if(contractInfor.paymentType.count > 0){
                    tfBankName.text = contractInfor.bankName
                    tfBankBranche.text = contractInfor.bankDepartment
                    tfAddress.text = contractInfor.address
                    tfMSTNumber.text = contractInfor.taxCode
                    tfAccountNo.text = contractInfor.accountNumber
                    rdButtonBank.isSelected = true
            
            }
        }
    }
    
    @IBAction func onClickVTPayInfor(_ sender: Any) {
        if(vtpInforView.isHidden){
            contraintVTPInforHeight.constant = 260
            vtpInforView.isHidden = false
            
            contraintBankInforHeight.constant = 0
            bankInforView.isHidden = true
            
            if(contractInfor.paymentType.count > 0){
                tfVTPPhone.text = contractInfor.msisdnPay
                tfVTPMST.text = contractInfor.taxCode
                tfVTPAddress.text = contractInfor.address
                rdButtonVTPay.isSelected = true
            }
        }
    }
    
}

