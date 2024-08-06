//
//  CreateChannelVc.swift
//  UClip
//
//  Created by Toan on 5/20/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import AssetsLibrary
import CropViewController

class CreateChannelVc: BaseViewController {
    
    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var tfvNameChannel: TextFieldFormView!
    @IBOutlet weak var tfvDescChannel: TextFieldFormView!
    var selectAvatarImage: UIImage?
    var  selectImage : UIImage?
    var selectCoverImage: UIImage?
    let picker = UIImagePickerController()
    var isChangeAvatar = false
    var channelCurrent = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func setupView() {
        self.title = String.Creat_Channel
        self.tfvNameChannel.titleLabel.text = String.full_Name
        self.tfvDescChannel.titleLabel.text = String.mo_ta
        self.tfvNameChannel.textField.maxNumberChars = 1000
        self.tfvDescChannel.textField.maxNumberChars = 1000
      tfvNameChannel.backgroundColor = UIColor.setViewColor()
      tfvDescChannel.backgroundColor = UIColor.setViewColor()
//      tfvNameChannel.bottomBorderUnselectedColor = UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("1c1c1e"), color2: .white)
      tfvNameChannel.mode = .normal
      tfvNameChannel.mode = .normal
//      tfvDescChannel.bottomBorderUnselectedColor =  UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("1c1c1e"), color2: .white)
      self.view.backgroundColor = UIColor.setViewColor()
        self.coverImg.image = #imageLiteral(resourceName: "bitmap")
        self.avatarImg.image = #imageLiteral(resourceName: "bitmap")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.luu, style: .done, target: self, action: #selector(uploadChannel))
    }
    @IBAction func onPickerCoverImg(_ sender: Any) {
        picker.delegate = self
        self.isChangeAvatar = false
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
    
    
    @IBAction func onPickerAvatarImg(_ sender: Any) {
        picker.delegate = self
        self.isChangeAvatar = true
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
    @objc func uploadChannel() {
        guard let nameChannel =  tfvNameChannel.textField.text else {
            self.toast(String.require_Name)
            return
        }
        if nameChannel.count > 100 {
            self.toast(String.maxNameCharacter)
            return
        }
        guard let descChannel = self.tfvDescChannel.textField.text else {
            self.toast(String.require_Desc)
            return
        }
        if nameChannel.count ==  0 {
            self.toast(String.require_Name)
            return
        }
        if descChannel.count == 0 {
            self.toast(String.require_Desc)
         return
        }
      if descChannel.count > 1000 {
         self.toast(String.maxDescCharacter)
      }
      if channelCurrent > 10 {
         self.toast(String.max_channel)
            return
        }
//        if self.hubVisible() {
//            return
//        }
        self.showHud()
        APIRequestProvider.shareInstance.CreateChannel(self.selectAvatarImage,self.selectCoverImage, nameChannel:nameChannel, descChannel: descChannel) { (resurt) in
            self.hideHude()
            
            switch resurt {
            case .success(let data):
                self.channelCurrent += 1
                let alertController = UIAlertController(title: String.add_Channel_Sucess , message: nil , preferredStyle: .alert)
                let okAction = UIAlertAction(title: String.dong_y, style: .default, handler: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                //                    self.toast(String.add_Channel_Sucess)
                //                }
                //                 self.navigationController?.popViewController(animated: true)
                break
            case .failure(let err) :
                self.toast(err.localizedDescription)
                break
            }
        }
    }
    
    func noCamera() {
        alertWithTitle(nil, message: String.thiet_bi_cua_ban_khong_the_chup_anh)
    }
}
extension CreateChannelVc : UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    
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
        cropController.aspectRatioLockEnabled = true
        cropController.resetAspectRatioEnabled = false
        cropController.aspectRatioPickerButtonHidden = true
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.selectImage = image
        
        if selectImage != nil {
            cropViewController.dismiss(animated: true, completion: nil)
            if isChangeAvatar {
                self.avatarImg.image =  image
                self.selectAvatarImage = image
            }else{
                self.coverImg.image =  image
                self.selectCoverImage = image
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
