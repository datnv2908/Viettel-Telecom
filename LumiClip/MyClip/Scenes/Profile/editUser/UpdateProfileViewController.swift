//
//  UpdateProfileViewController.swift
//  UClip
//
//  Created by zohan on 6/27/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import AssetsLibrary
import CropViewController

class UpdateProfileViewController: BaseViewController {

    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbFullName: UILabel!
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var tfDesc: UITextField!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var lbStatusValue: UILabel!
    
    @IBOutlet weak var lbNote: UILabel!
    @IBOutlet weak var lbNoteAvatar: UILabel!
    @IBOutlet weak var lbNoteBanner: UILabel!
    
    let picker = UIImagePickerController()
    var selectImage: UIImage?
    var isChangeAvatar = false
    let service = UserService()
    
    var viewModel : UpdateProfileViewModel!
    var avatarUpdate =  UIImage()
    var coverUpdate =  UIImage()
    
    override func viewDidLoad() {
        setupView()
        setupData()
    }
    init(viewModel : UpdateProfileViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: "UpdateProfileViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setupView() {
        self.navigationItem.title = String.user_settings
        let finishButton = UIBarButtonItem.saveBarButton(target: self, selector: #selector(uploadPhoto))
        self.navigationItem.rightBarButtonItem = finishButton
        
        lbFullName.text = String.ten_day_du
        lbDesc.text = String.mo_ta
        
        self.imgCover.kf.setImage(with: URL(string: viewModel.coverImage),
                                      placeholder: #imageLiteral(resourceName: "bitmap"),
                                      options: nil,
                                      progressBlock: nil,
                                      completionHandler: nil)
        tfFullName.text = viewModel.fullName
        tfDesc.text = viewModel.description
        lbStatusValue.text = viewModel.status == 1 ? String.da_duyet : String.dang_cho_duyet
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillLayoutSubviews() {
        imgAvatar.layer.cornerRadius = imgAvatar.bounds.size.width/2.0
    }

    
    func setupData() {
    }
    
    @IBAction func onClickChangeAvatar(_ sender: Any) {
        NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
        isChangeAvatar = true
        picker.delegate = self
        let alertController = UIAlertController(title: String.chon_hinh_dai_dien,
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
    
    @IBAction func onSelectChangeCover(_ sender: Any) {
        NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
        isChangeAvatar = false
        picker.delegate = self
        let alertController = UIAlertController(title: String.chon_hinh_dai_dien,
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
            if isChangeAvatar {
                picker.allowsEditing = true
            } else {
                picker.allowsEditing = false
            }
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

   @objc func uploadPhoto() {
    guard let userId = DataManager.getCurrentMemberModel()?.userId else {
        return
    }
   
      guard let nameUpdate = self.tfFullName.text else{
         return
      }
      guard let descUpdate = self.tfDesc.text else{return}
    
    self.showHud()
    APIRequestProvider.shareInstance.updateProfile(name: nameUpdate, desc: descUpdate, self.avatarUpdate, coverImage: self.coverUpdate, id: userId) {
            (result) in
                   switch result {
                   case .success(_):
                    self.toast(String.update_Sucess)
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Change `2.0` to the desired number of seconds.
                       self.navigationController?.popViewController(animated: true)
                   }
                   case .failure(let error):
                       self.toast(error.localizedDescription)
                   }
                   self.hideHude()
        }
    }
}

extension UpdateProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage) else { return }
        let croppingStyle = CropViewCroppingStyle.default
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        if isChangeAvatar {
            cropController.customAspectRatio = CGSize(width: 1, height: 1)
        } else {
            cropController.customAspectRatio = CGSize(width: 6, height: 1)
        }
        cropController.aspectRatioPreset = .presetCustom;
        cropController.aspectRatioLockEnabled = true
        cropController.resetAspectRatioEnabled = false
        cropController.aspectRatioPickerButtonHidden = true
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            cropViewController.dismiss(animated: true, completion: nil)
            if isChangeAvatar {
                self.avatarUpdate = image.resizeImage(targetSize: CGSize(width: 160, height: 160))!
                self.imgAvatar.image = image
            }else{
                self.coverUpdate = image.resizeImage(targetSize: CGSize(width: 1920, height: 330))!
                self.imgCover.image = image
        }
//        } else {
//            cropViewController.dismiss(animated: true, completion: nil)
//            self.toast(String.khong_the_tai_anh)
//        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
