//
//  UploadViewController.swift
//  MyClip
//
//  Created by Huy Nguyen on 8/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos
import TPKeyboardAvoiding

class UploadViewController: BaseViewController {
   var videoURL: URL?
   var videoLength = 0.0
   var videoMode = VideoMode.kPublic
   var titleString = ""
   var desc = ""
   var isLiveVideo: Bool = false
   
   @IBOutlet weak var numCharDesLabel: UILabel!
   @IBOutlet weak var numCharTitleLabel: UILabel!
   @IBOutlet weak var heightAvatarViewConstraint: NSLayoutConstraint!
   @IBOutlet weak var titleTextField: UITextField!
   @IBOutlet weak var descTextView: UIPlaceHolderTextView!
   @IBOutlet weak var heightTextViewConstraint: NSLayoutConstraint!
   @IBOutlet weak var avatarImageView: UIImageView!
   @IBOutlet weak var avatarView: UIView!
   @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
   @IBOutlet weak var modeLabel: UILabel!
   @IBOutlet weak var avatarBtn: UIButton!
   @IBOutlet weak var levelBtn: UIButton!
   @IBOutlet weak var cameraImageView: UIImageView!
   @IBOutlet weak var ChannelTl: UILabel!
    @IBOutlet weak var categoryLb: UILabel!
   @IBOutlet weak var contentBGView: UIView!
   @IBOutlet weak var contentViewBg: UIView!
   @IBOutlet var lineView2: [UIView]!
   let picker = UIImagePickerController()
   var selectImage: UIImage?
   var channelUploadID : String!
   var categoryUploadID : String!
   var channelsUser : ChannelDetailsModel?
   var moreContent = [ContentModel]()
   let service = AppService()
   //MARK: - Life Cycle
   override func viewDidLoad() {
      super.viewDidLoad()
      titleTextField.attributedPlaceholder = NSAttributedString(
         string: String.tieu_de,
         attributes: [NSAttributedString.Key.foregroundColor: UIColor.settitleColor()]
     )
      for item in lineView2 {
         item.backgroundColor = UIColor.setSeprateViewColor()
      }
      titleTextField.textColor = UIColor.settitleColor()
      titleTextField.backgroundColor = UIColor.setViewColor()
      descTextView.backgroundColor = UIColor.setViewColor()
      contentBGView.backgroundColor = UIColor.setViewColor()
      avatarView.backgroundColor = UIColor.setViewColor()
      contentViewBg.backgroundColor = UIColor.setViewColor()
      avatarBtn.setTitleColor(UIColor.settitleColor(), for: .normal)
      descTextView.textColor = UIColor.settitleColor()
      titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
      setupForVideo()
      logScreen(GoogleAnalyticKeys.upload.rawValue)
      avatarBtn.setTitle(String.hinh_dai_dien, for: .normal)
      levelBtn.setTitle(String.che_do, for: .normal)
    ChannelTl.text =  String.chooseChannel
    categoryLb.text = String.chooseCategory
   }
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.getMutiChannel()
   }
   //MARK: - Setup View
   override func setupView() {
      self.navigationItem.title = String.daang_tai_video
//      titleTextField.placeholder =
      descTextView.placeholder = String.mo_ta
      descTextView.placeholderColor = AppColor.imWarmGrey()
      let uploadBarButton = UIBarButtonItem.uploadBarButton(target: self,
                                                            selector: #selector(uploadVideo(_ :)))
      self.navigationItem.rightBarButtonItem = uploadBarButton
      heightAvatarViewConstraint.constant = 0
      descTextView.textContainerInset = UIEdgeInsets(top: 14, left: 11, bottom: 0, right: 0)
      descTextView.delegate = self
   }
   
   func requestAuthor() {
      if !(AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized) {
         AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
               
            } else {
            }
         }
      }
      if (AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.denied) {
         openSettingScene()
      }
      let photos = PHPhotoLibrary.authorizationStatus()
      if photos == .notDetermined {
         PHPhotoLibrary.requestAuthorization({status in
            if status == .authorized{
            } else {
            }
         })
      }
      
      if photos == .denied {
         openSettingScene()
      }
   }
   
   func openSettingScene() {
      //        let dialog = DialogViewController(title: String.bat_dau_chuong_trinh,
      //                                          message: String.requestAccessConfirm,
      //                                          confirmTitle: String.mo_cai_dat,
      //                                          cancelTitle: String.huy)
      //        dialog.confirmDialog = { button in
      //            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
      //                return
      //            }
      //            if UIApplication.shared.canOpenURL(settingsUrl) {
      //                if #available(iOS 10.0, *) {
      //                    UIApplication.shared.open(settingsUrl)
      //                } else {
      //                    UIApplication.shared.openURL(settingsUrl)
      //                }
      //            }
      //        }
      //        presentDialog(dialog, animated: true, completion: nil)
      
      self.showAlert(title: String.bat_dau_chuong_trinh, message: String.requestAccessConfirm, okTitle: String.mo_cai_dat, onOk: { [weak self] _ in
         guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
         }
         if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
               UIApplication.shared.open(settingsUrl)
            } else {
               UIApplication.shared.openURL(settingsUrl)
            }
         }
      })
   }
   
   func checkRequestAuthor() -> Bool {
      if !(AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized) {
         return false
      }
      let photos = PHPhotoLibrary.authorizationStatus()
      if photos == .notDetermined {
         return false
      }
      if photos == .denied {
         return false
      }
      return true
   }
   
   @objc func textFieldDidChange(_ textField: UITextField) {
      if (textField.text?.count)! < 100 {
         titleString = textField.text!
      }
      let num:Int = (textField.text?.count)!
      numCharTitleLabel.text = "\(num)/100"
      textField.text = titleString
   }
   
   @IBAction func onClickSelectAvatarButton(_ sender: Any) {
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
   
   @IBAction func onClickModeButton(_ sender: Any) {
      let actionController = ActionSheetViewController()
      actionController.addSection(Section())
      actionController.addAction(Action(ActionData(title: VideoMode.kPublic.stringValue(),
                                                   image: UIImage()),
                                        style: .default,
                                        handler: { _ in
                                            self.videoMode = .kPublic
                                            self.modeLabel.text = self.videoMode.stringValue()
                                        }))
      actionController.addAction(Action(ActionData(title: VideoMode.kPrivate.stringValue(),
                                                   image: UIImage()),
                                        style: .default,
                                        handler: { _ in
                                            self.videoMode = .kPrivate
                                            self.modeLabel.text = self.videoMode.stringValue()
                                        }))
      present(actionController, animated: true, completion: nil)
   }
   @IBAction func onChooseChannel(_ sender: Any) {
      let actionController = ActionSheetViewController()
      if let model = channelsUser?.channels{
         for i in 0 ... model.count-1 {
            actionController.addSection(Section())
            let actionData = ActionData(title: model[i].title)
            let action = Action(actionData, style: .default, handler: { (_) in
               self.ChannelTl.text = model[i].title
               self.channelUploadID = model[i].objectID
            })
            actionController.addAction(action)
         }
      }
      present(actionController, animated: true, completion: nil)
   }
    
    @IBAction func onClickChoseCategory(_ sender: Any) {
       let actionController = ActionSheetViewController()
      if  moreContent.count > 0 {
         for i in 0 ... moreContent.count-1 {
               actionController.addSection(Section())
            let actionData = ActionData(title: moreContent[i].name)
               let action = Action(actionData, style: .default, handler: { (_) in
                  self.categoryLb.text = self.moreContent[i].name
                  self.categoryUploadID = self.moreContent[i].id
               })
               actionController.addAction(action)
            }
      }
       present(actionController, animated: true, completion: nil)
    }
    
   
   func takePhotoFromLibrary(_ sender: UIButton) {
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
   
   @objc func uploadVideo(_ sender: UIButton) {
      if !DataManager.isLoggedIn() {
         performLogin(completion: { (result) in
            
         })
      } else {
         let title = titleTextField.text ?? ""
         let desc = descTextView.text ?? ""
         guard let url = videoURL else {
            self.toast(String.chua_chon_video)
            return
         }
         if title.isEmpty {
            self.toast(String.tieu_de_khong_duoc_de_trong)
            titleTextField.becomeFirstResponder()
            return
         }
         guard let thumbImage = selectImage else {
            self.toast(String.anh_dai_dien_khong_duoc_de_trong)
            return
         }
         guard let channelId = self.channelUploadID else {
             self.toast(String.channel_not_null)
             return
         }
         
         do {
            let videoData = try Data(contentsOf: videoURL!)
            DLog("file size: \(videoData.fileSize())")
            if videoData.count > 1073741824 {
               self.toast(String.dung_luong_khong_duoc_vuot_qua_1gb)
               return
            }
         } catch {
            print(error.localizedDescription)
         }
         view.endEditing(true)
         let model = UploadModel(videoUrl: url,
                                 title: title,
                                 desc: desc,
                                 thumbImage: thumbImage,
                                 videoMode: videoMode.intValue(),channelID: channelId,categoryID: self.categoryUploadID ?? "" )
         UploadService.sharedInstance.uploadVideo(model)
         self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: .kNotificationUploadStarted,
                                            object: nil,
                                            userInfo: nil)
         })
      }
   }
   
   func setupForVideo() {
      guard let url = videoURL else { return  }
      selectImage = thumbnailForVideoAtURL(url: url)?.fixedOrientation()
      self.cameraImageView.image = #imageLiteral(resourceName: "iconCameraSelected")
      avatarImageView.image = selectImage
      self.heightAvatarViewConstraint.constant = Constants.videoPlayerHeight
      self.scrollView.contentSizeToFit()
      var value: String
      if isLiveVideo {
         value = Date().toString()
      } else {
         value = (self.videoURL?.deletingPathExtension().lastPathComponent)!
      }
      
      let set = CharacterSet(charactersIn: "@#$%_.^*()[]{}!&-+=~`?/><.")
      let title = value.components(separatedBy: set).joined(separator: " ")
      numCharTitleLabel.text = "\(title.count)/100"
      if (self.titleTextField.text?.isEmpty)! {
         self.titleTextField.text = title.condensedWhitespace
      }
   }
   func getMutiChannel() {
       self.showHud()
         let userID = DataManager.getCurrentMemberModel()?.userId
       service.getMutilChannelDetails(userID!,getActiveChannel: .allChannel) {(result) in
               switch result {
               case .success(let  response) :
                   let model = response.data
                   self.channelsUser = ChannelDetailsModel(model)
                   self.hideHude()
                   break
               case .failure(let err) :
                   self.toast(err.localizedDescription)
                   self.hideHude()
                   break
                   
               }
           }
   }
   func replaceString() {
      
   }
   
   func showSelectVideo() {
      NotificationCenter.default.post(name: .kShouldPausePlayer, object: nil)
      let selectVideoVC = SelectVideoViewController.initWithNib()
      present(selectVideoVC, animated: true, completion: nil)
   }
   
   deinit {
      DLog("")
   }
}

extension UploadViewController: UITextViewDelegate {
   func textViewDidChange(_ textView: UITextView) {
      if textView.text.count < 1000 {
         desc = textView.text
      }
      let num:Int = textView.text.count
      numCharDesLabel.text = "\(num)/900"
      textView.text = desc
      let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
      if size.height > CGFloat(44.0) {
         heightTextViewConstraint.constant = size.height + 14
         descTextView.textContainerInset = UIEdgeInsets(top: 14, left: 11, bottom: 0, right: 0)
      } else {
         heightTextViewConstraint.constant = 44.0
      }
   }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [String : Any]) {
      self.cameraImageView.image = #imageLiteral(resourceName: "iconCameraSelected")
      dismiss(animated: true, completion: nil)
      if let chosenImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
         avatarImageView.image = chosenImage
         self.selectImage = chosenImage
         self.heightAvatarViewConstraint.constant = Constants.videoPlayerHeight
         self.avatarImageView.isHidden = false
         self.scrollView.contentSizeToFit()
      } else {
         if let assetUrl = info[UIImagePickerController.InfoKey.referenceURL.rawValue] as? URL {
            let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
            if let photo = fetchResult.firstObject {
               // retrieve the image for the first result
               let options = PHImageRequestOptions()
               options.version = .current
               options.resizeMode = .exact
               options.deliveryMode = .highQualityFormat
               options.isNetworkAccessAllowed = true
               options.isSynchronous = true
               PHImageManager.default().requestImage(for: photo,
                                                     targetSize: PHImageManagerMaximumSize,
                                                     contentMode: .aspectFit,
                                                     options: options) { (image, _) in
                  if image != nil {
                     self.avatarImageView.image = image
                     self.selectImage = image
                     self.heightAvatarViewConstraint.constant = Constants.videoPlayerHeight
                     self.avatarImageView.isHidden = false
                     self.scrollView.contentSizeToFit()
                     
                  } else {
                     self.toast(String.khong_the_tai_anh)
                  }
               }
            }
         }
      }
   }
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      self.dismiss(animated: true, completion: nil)
   }
   
   func thumbnailForVideoAtURL(url: URL) -> UIImage? {
      
      let asset = AVAsset(url: url)
      let assetImageGenerator = AVAssetImageGenerator(asset: asset)
      assetImageGenerator.appliesPreferredTrackTransform = true
      var time = asset.duration
      time.value = min(time.value, 2)
      
      do {
         let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
         return UIImage(cgImage: imageRef)
      } catch {
         print("error")
         return nil
      }
   }
}
