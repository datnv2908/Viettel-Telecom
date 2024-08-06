//
//  UpdateAccountInforViewController.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import AssetsLibrary
import CropViewController

import DatePickerDialog

class UpdateAccountInforViewController: BaseViewController, UIGestureRecognizerDelegate {
    
    let eventService = EventService()
    let picker = UIImagePickerController()
    var idFrontImage: UIImage?
    var idBackImage: UIImage?
    var isPickForFrontId = false
    let service = AppService()
   var fromNoti : Bool = false
   
    @IBOutlet var bgView: [UIView]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfIDNo: UITextField!
    @IBOutlet weak var tfIDAddress: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfIDCreateAt: UITextField!
    @IBOutlet weak var imgIDFront: UIImageView!
    @IBOutlet weak var imgIDBack: UIImageView!
    @IBOutlet weak var tfOTP: UITextField!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var personInfoLabel: UILabel!
    @IBOutlet weak var pictureBeforeLabel: UILabel!
    @IBOutlet weak var pictureAfterLabel: UILabel!
    
    @IBOutlet weak var getOTPBtn: UIButton!
    @IBOutlet weak var okBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var contraintHeightIDFront: NSLayoutConstraint!
    @IBOutlet weak var contraintHeightIDBack: NSLayoutConstraint!
    var currentPage: Int = 0
    var accountInfor = AccountContractInfor()
   var backTofirst : (()-> Void)?
    @IBOutlet weak var cbTermOfCondition: CCheckbox!
    @IBOutlet weak var tvTermOfCondition: UITextView!
    
    var isGotoUpdatePayment: Bool
    init(_ isGotoUpdatePayment: Bool) {
        self.isGotoUpdatePayment = isGotoUpdatePayment
        super.init(nibName: "UpdateAccountInforViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = String.xac_nhan_thong_tin_ca_nhan
        backgroundView.backgroundColor = UIColor.setViewColor()
        for item in bgView {
            item.backgroundColor = UIColor.setViewColor()
        }
        tvTermOfCondition.textColor = UIColor.settitleColor()
        okBtn.setTitle(String.xac_nhan, for: .normal)
        cancelBtn.setTitle(String.huy, for: .normal)
        getOTPBtn.setTitle(String.lay_ma_otp, for: .normal)
        noteLabel.text = String.bat_buoc_nhap
        personInfoLabel.text = String.thong_tin_ca_nhan
        pictureBeforeLabel.text = String.anh_mat_truoc
        pictureAfterLabel.text = String.anh_mat_sau
        tvTermOfCondition.text = String.su_dung_thong_tin_co_san
        tfName.placeholder = String.ho_va_ten
        tfEmail.placeholder = String.dia_chi_email
        tfIDNo.placeholder = String.so_cmnd
        tfIDAddress.placeholder = String.noi_cap
        tfIDCreateAt.placeholder = String.ngay_cap
        tfPhoneNumber.placeholder = String.so_dien_thoai_unitel
        tfOTP.placeholder = String.ma_otp
        tvTermOfCondition.backgroundColor = UIColor.setViewColor()
      
        if #available(iOS 12.0, *) {
            tfOTP.textContentType = .oneTimeCode
        }
        contraintHeightIDFront.constant = 0
        contraintHeightIDBack.constant = 0
    
        registerKeyboardNotifications()
        hideKeyboardWhenTappedAround()
        
        if(isGotoUpdatePayment){
            loadPreviouInfor()
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view is UIButton) { // The "clear text" icon is a UIButton
            return false
        }
        return true
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
        tap.delegate = self
        backgroundView.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showIDCreateAtPicker(_ sender: Any) {
      let datePicker = DatePickerDialog(textColor: UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("009DFD"), color2: UIColor.colorFromHexa("1c1c1e")),
                                          buttonColor: UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("009DFD"), color2: UIColor.colorFromHexa("1c1c1e")),
                                          font: UIFont.boldSystemFont(ofSize: 18),
                                          showCancelButton: true)
        datePicker.backgroundColor = UIColor.setViewColor()
        datePicker.show(String.chon_ngay,
                        doneButtonTitle: String.dong_y,
                        cancelButtonTitle: String.huy,
                        defaultDate: Date(),
                        maximumDate: Date(),
                        datePickerMode: .date) { (date) in
                            if let dt = date {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                self.tfIDCreateAt.text = formatter.string(from: dt)
                            }
        }
    }
    
    @IBAction func showPickerFrontId(_ sender: Any) {
        isPickForFrontId = true
        picker.delegate = self
        let alertController = UIAlertController(title: String.chon_anh_mat_truoc,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: String.chon_tu_thu_vien, style: .default) { (_) in
            self.takePhotoFromLibrary(sender as! UIButton)
        }
        let takePhotoAction = UIAlertAction(title: String.chup_anh, style: .default) { (_) in
            self.shootPhoto(sender as! UIButton)
        }
        let cancelAction = UIAlertAction(title: String.huy, style: .cancel) { (_) in
            
        }
        alertController.addAction(galleryAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func showPickerBackId(_ sender: Any) {
        isPickForFrontId = false
        picker.delegate = self
        let alertController = UIAlertController(title: String.chon_anh_mat_sau,
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let galleryAction = UIAlertAction(title: String.chon_tu_thu_vien, style: .default) { (_) in
            self.takePhotoFromLibrary(sender as! UIButton)
        }
        let takePhotoAction = UIAlertAction(title: String.chup_anh, style: .default) { (_) in
            self.shootPhoto(sender as! UIButton)
        }
        let cancelAction = UIAlertAction(title: String.huy, style: .cancel) { (_) in
            
        }
        alertController.addAction(galleryAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        alertController.modalPresentationStyle = .popover
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = sender as? UIView
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func takePhotoFromLibrary(_ sender: UIButton) {
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String]
        picker.modalPresentationStyle = .fullScreen
        picker.popoverPresentationController?.sourceView = view
        let midX = view.bounds.midX
        let midY = view.bounds.midY
        picker.popoverPresentationController?.sourceRect = CGRect(x: midX, y: midY, width: 0, height: 0)
        present(picker, animated: true, completion: nil)
    }
    
    func shootPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            picker.popoverPresentationController?.sourceView = view
            let midX = view.bounds.midX
            let midY = view.bounds.midY
            picker.popoverPresentationController?.sourceRect = CGRect(x: midX, y: midY, width: 0, height: 0)
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        alertWithTitle(nil, message: String.thiet_bi_cua_ban_khong_the_chup_anh)
    }
    
    @IBAction func actionGetOTP(_ sender: Any) {
        if !Singleton.sharedInstance.isConnectedInternet {
            showInternetConnectionError()
            return
        }
        let phoneNumber = self.tfPhoneNumber.text
        if (self.tfPhoneNumber.hasText)
        {
            showHud()
            eventService.getAccountOTP(msisdn: phoneNumber!)
                { (result) in
                    switch result {
                    case .success(let _):
                        self.toast(String.thanh_cong)
                        break
                    case .failure(let error):
                        self.toast(error.localizedDescription)
                    }
                    self.hideHude()
            }
        }else{
            self.toast(String.enterPhoneNumber)
            self.tfPhoneNumber.becomeFirstResponder()
        }
        
    }
    
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpdateInfor(_ sender: Any) {
        let accountName = self.tfName.text
        if (!self.tfName.hasText)
        {
            self.toast(String.EnterName)
            self.tfName.becomeFirstResponder()
            return
        }

        let accountEmail = self.tfEmail.text
        if (!self.tfEmail.hasText)
        {
            self.toast(String.EnterEmail)
            self.tfEmail.becomeFirstResponder()
            return
        }

        let accountIDNo = self.tfIDNo.text
        if (!self.tfIDNo.hasText)
        {
            self.toast(String.EnterIDNo)
            self.tfIDNo.becomeFirstResponder()
            return
        }

        let accountIDAdress = self.tfIDAddress.text
        if (!self.tfIDAddress.hasText)
        {
            self.toast(String.EnterIDAddress)
            self.tfIDAddress.becomeFirstResponder()
            return
        }

        let accountIDDate = self.tfIDCreateAt.text
        if (!self.tfIDCreateAt.hasText)
        {
            self.toast(String.EnterIDDate)
            self.tfIDCreateAt.becomeFirstResponder()
            return
        }

        if(idFrontImage == nil){
            self.toast(String.EnterIDFrontImage)
            return
        }

        if(idBackImage == nil){
            self.toast(String.EnterIDBackImage)
            return
        }

        let accountPhoneNumber = self.tfPhoneNumber.text
        if (!self.tfPhoneNumber.hasText)
        {
            self.toast(String.enterPhoneNumber)
            self.tfPhoneNumber.becomeFirstResponder()
            return
        }

        let accountOTP = self.tfOTP.text
        if (!self.tfOTP.hasText)
        {
            self.toast(String.EnterPhoneOTP)
            self.tfOTP.becomeFirstResponder()
            return
        }
    
        self.showHud()
        APIRequestProvider.shareInstance.updateAccountInformationUpload(rqAccountName: accountName!, rqAccountEmail: accountEmail!, rqAccountIDNo: accountIDNo!, rqAccountIDAddress: accountIDAdress!, rqAccountIDDate: accountIDDate!, rqIDFront: idFrontImage!, rqIDBack: idBackImage!, rqPhoneNumber: accountPhoneNumber!, rqOtp: accountOTP!) { (result) in
            switch result {
            case .success(_):
                self.toast(String.cap_nhat_thanh_cong)
                if(self.isGotoUpdatePayment){
                    let updateInforVC = UpdatePaymentInforViewController(ContractInfor())
                    self.navigationController?.pushViewController(updateInforVC, animated: true)
                }else{
                  if self.fromNoti {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
                        let selectVideoVC = SelectVideoViewController.initWithNib()
                        let nav = BaseNavigationController(rootViewController: selectVideoVC)
                        self.present(nav, animated: true, completion: nil)
                        
                        self.navigationController?.popToRootViewController(animated: false)
                    }
                  }else{
                     self.toast(String.sucessAcountInfor)
                     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                     self.navigationController?.popToRootViewController(animated: true)
                     }
                  }
                }
            case .failure(let error):
                self.toast(error.localizedDescription)
            }
            self.hideHude()
        }
    }
    
    func loadPreviouInfor() {
        if DataManager.isLoggedIn() {
            service.getContractCondition()
                { (result) in
                    switch result {
                    case .success(let response):
                        self.tfEmail.text = response.data.email
                        self.tfName.text = response.data.name
                        self.tfIDNo.text = response.data.idCardNumber
                        self.tfIDAddress.text = response.data.idCardCreatedBy
                        self.tfPhoneNumber.text = response.data.msisdn
                        
                        if(response.data.idCardCreatedAt.contains("/")){
                            self.tfIDCreateAt.text = response.data.idCardCreatedAt
                        }else{
                            if(response.data.idCardCreatedAt.count > 0){
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
                                let date = dateFormatter.date (from: response.data.idCardCreatedAt)
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd/MM/yyyy"
                                self.tfIDCreateAt.text = formatter.string(from: date!)
                            }
                        }
                        
                        if let url = URL(string: response.data.idCardImageFrontSide) {
                            self.imgIDFront.kf.setImage(with: url,
                                                        options: nil,
                                                        progressBlock: nil,
                                                        completionHandler:  {
                                                            image, error, cacheType, imageURL in
                                                            if error == nil {
                                                                self.idFrontImage = image
                                                                self.contraintHeightIDFront.constant = 90
                                                            }
                            })
                        }
                        
                        if let url = URL(string: response.data.idCardImageBackSide) {
                            self.imgIDBack.kf.setImage(with: url,
                                                       options: nil,
                                                       progressBlock: nil,
                                                       completionHandler: {
                                                        image, error, cacheType, imageURL in
                                                        if error == nil {
                                                            self.idBackImage = image
                                                            self.contraintHeightIDBack.constant = 90
                                                        }
                            })
                        }
                        
                    case .failure(_):
                        self.tfEmail.text = ""
                        self.tfName.text = ""
                        self.tfIDNo.text = ""
                        self.tfIDAddress.text = ""
                        self.tfIDCreateAt.text = ""
                        self.tfPhoneNumber.text = ""
                        self.contraintHeightIDFront.constant = 0
                        self.contraintHeightIDBack.constant = 0
                        break
                    }
            }
        }
    }
    
    @IBAction func actionUseExistInfor(_ sender: Any) {
        if(cbTermOfCondition.isCheckboxSelected){
            cbTermOfCondition.isCheckboxSelected = false
            if(isGotoUpdatePayment){
                loadPreviouInfor()
            }else{
                self.tfEmail.text = ""
                self.tfName.text = ""
                self.tfIDNo.text = ""
                self.tfIDAddress.text = ""
                self.tfIDCreateAt.text = ""
                self.tfPhoneNumber.text = ""
                self.contraintHeightIDFront.constant = 0
                self.contraintHeightIDBack.constant = 0
            }
        }else{
            cbTermOfCondition.isCheckboxSelected = true
            if(self.accountInfor.idCardNumber.count > 0){
                self.tfEmail.text = self.accountInfor.email
                self.tfName.text = self.accountInfor.name
                self.tfIDNo.text = self.accountInfor.idCardNumber
                self.tfIDAddress.text = self.accountInfor.idCardCreatedBy
                self.tfPhoneNumber.text = self.accountInfor.msisdn
                
                if(self.accountInfor.idCardCreatedAt.contains("/")){
                    self.tfIDCreateAt.text = self.accountInfor.idCardCreatedAt
                }else{
                    if(self.accountInfor.idCardCreatedAt.count > 0){
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
                        let date = dateFormatter.date (from: self.accountInfor.idCardCreatedAt)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd/MM/yyyy"
                        self.tfIDCreateAt.text = formatter.string(from: date!)
                    }
                }
                
                if let url = URL(string: self.accountInfor.idCardImageFrontSide) {
                    self.imgIDFront.kf.setImage(with: url,
                                                options: nil,
                                                progressBlock: nil,
                                                completionHandler: nil)
                    self.contraintHeightIDFront.constant = 90
                }
                
                if let url = URL(string: self.accountInfor.idCardImageBackSide) {
                    self.imgIDBack.kf.setImage(with: url,
                                               options: nil,
                                               progressBlock: nil,
                                               completionHandler: nil)
                    self.contraintHeightIDBack.constant = 90
                }
            }else{
                if DataManager.isLoggedIn() {
                    service.getAccountInfoUpload()
                        { (result) in
                            switch result {
                            case .success(let response):
                                self.accountInfor = response.data
                                self.tfEmail.text = response.data.email
                                self.tfName.text = response.data.name
                                self.tfIDNo.text = response.data.idCardNumber
                                self.tfIDAddress.text = response.data.idCardCreatedBy
                                self.tfPhoneNumber.text = response.data.msisdn
                                
                                if(response.data.idCardCreatedAt.contains("/")){
                                    self.tfIDCreateAt.text = self.accountInfor.idCardCreatedAt
                                }else{
                                    if(response.data.idCardCreatedAt.count > 0){
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
                                        let date = dateFormatter.date (from: self.accountInfor.idCardCreatedAt)
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "dd/MM/yyyy"
                                        self.tfIDCreateAt.text = formatter.string(from: date!)
                                    }
                                }
                                
                                if let url = URL(string: response.data.idCardImageFrontSide) {
                                    self.imgIDFront.kf.setImage(with: url,
                                                                options: nil,
                                                                progressBlock: nil,
                                                                completionHandler:  {
                                                                    image, error, cacheType, imageURL in
                                                                    if error == nil {
                                                                        self.idFrontImage = image
                                                                        self.contraintHeightIDFront.constant = 90
                                                                    }
                                    })
                                }
                                
                                if let url = URL(string: response.data.idCardImageBackSide) {
                                    self.imgIDBack.kf.setImage(with: url,
                                                           options: nil,
                                                           progressBlock: nil,
                                                           completionHandler: {
                                        image, error, cacheType, imageURL in
                                            if error == nil {
                                                self.idBackImage = image
                                                self.contraintHeightIDBack.constant = 90
                                            }
                                        })
                                }
                                
                            case .failure(let error):
                                self.handleError(error as NSError, automaticShowError: false, completion: {
                                    (result) in
                                    if result.isSuccess {
                                        
                                    }
                                })
                                break
                            }
                    }
                }
            }
        }
    }
    
}

extension UpdateAccountInforViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage) else { return }
        let croppingStyle = CropViewCroppingStyle.default
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        cropController.customAspectRatio = CGSize(width: 16, height: 9)
        cropController.aspectRatioPreset = .presetCustom;
        cropController.aspectRatioLockEnabled = false
        cropController.resetAspectRatioEnabled = false
        cropController.aspectRatioPickerButtonHidden = true
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        if image != nil {
            cropViewController.dismiss(animated: true, completion: nil)
            if(isPickForFrontId){
                idFrontImage = image
                imgIDFront.image = image
                contraintHeightIDFront.constant = 90
            }else{
                idBackImage = image
                imgIDBack.image = image
                contraintHeightIDBack.constant = 90
            }
        } else {
            cropViewController.dismiss(animated: true, completion: nil)
            self.toast(String.khong_the_tai_anh)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

