//
//  SelectVideoViewController.swift
//  MyClip
//
//  Created by Os on 8/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Photos
import AssetsLibrary
import MobileCoreServices

class SelectVideoViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previewCameraView: UIView?
    @IBOutlet weak var bottomCollectionViewContraint: NSLayoutConstraint!
    
    @IBOutlet weak var onCameraButton: UIButton!
    @IBOutlet weak var onCameraLabel: UILabel!
    let picker = UIImagePickerController()
    
    var videos : [PHAsset] = []
    var avseet: [AVAsset] = []
    //Camera Capture requiered properties
    var videoDataOutput: AVCaptureVideoDataOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer:AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?  = {
        if #available(iOS 10, *) {
            return AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        else {
            for device in AVCaptureDevice.devices(for: AVMediaType.video) {
                if let _device = device as? AVCaptureDevice , _device.position == AVCaptureDevice.Position.back {
                    return _device
                }
            }
        }
        return nil
    }()
    let session = AVCaptureSession()
    var currentFrame: CIImage!
    var done = false
    var offCameraButton = UIBarButtonItem()
    var isLoadedScreen: Bool = false
    
    var isOnCamera: Bool = false {
        didSet {
            if isOnCamera {
                constraintForCameraOn()
                UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
            } else {
                constraintForCameraOff()
                UIView.animate(withDuration: 0.2, animations: {self.view.layoutIfNeeded()})
            }
        }
    }
    
    @IBAction func onClickDissmiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onCameraLabel.text = String.quay_video
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                // Already Authorized
                self.onCameraButton.isHidden = false
                self.setupAVCapture()
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        // User granted
                        self.onCameraButton.isHidden = false
                        self.setupAVCapture()
                    } else {
                        // User rejected
                        DLog("Đoạn này là người dùng không cấp quyền sử dụng camera")
                        self.onCameraButton.isHidden = true
                        self.noCamera()
                    }
                })
            }
        } else {
            noCamera()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isLoadedScreen == false {
            isLoadedScreen = true
            getVideoFromCameraRoll()
        }
    }
    
    func dismissController() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        previewLayer?.frame = previewCameraView?.bounds ?? .zero
    }
    
    func noCamera() {
        alertWithTitle(nil, message: String.thiet_bi_cua_ban_khong_ho_tro_camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !done {
            session.startRunning()
        }
        Constants.appDelegate.rootTabbarController.tabController.setBar(hidden: true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Constants.appDelegate.rootTabbarController.tabController.setBar(hidden: false, animated: false)
    }
    
    override func setupView() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(onDismiss))
        collectionView.register(UINib(nibName: VideoCollectionViewCell.nibName(),
                                      bundle: nil),
                                forCellWithReuseIdentifier: VideoCollectionViewCell.nibName())
        
        collectionView.addNoDataLabel(String.khong_co_video_trong_bo_nho_dien_thoai, UIColor.colorFromHexa("9b9b9b"))
        
        offCameraButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(performOnCameraButton(_:)))
    }

    @objc override func onDismiss() {
        dismiss(animated: true, completion: nil)
    }

    func getVideoFromCameraRoll() {
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.fetchAllVideoInPhoneLocal()
                } else {
                }
            })
        } else {
            self.fetchAllVideoInPhoneLocal()
        }
    }
    
    func fetchAllVideoInPhoneLocal() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        options.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.video.rawValue)
        
        let result: PHFetchResult<PHAsset>  = PHAsset.fetchAssets(with: options)
        self.videos.removeAll()
        self.avseet.removeAll()
        self.collectionView.reloadData()
        if result.count > 0 {
            self.getVideoAVAssetWithIndex(i: 0, result: result)
        }
    }
    
    func getVideoAVAssetWithIndex(i: Int, result: PHFetchResult<PHAsset>) {
        if i >= result.count {
            DispatchQueue.main.async {
                if(self.videos.count > 0){
                    self.collectionView.removeNoDataLabel()
                }else{
                    self.collectionView.addNoDataLabel(String.khong_co_video_trong_bo_nho_dien_thoai, UIColor.colorFromHexa("9b9b9b"))
                }
                self.collectionView.reloadData()
            }
            return
        }
        
        let asset = result.object(at: i)
        PHCachingImageManager().requestAVAsset(forVideo: asset, options: nil, resultHandler: {(asse: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
            if let item = asse {
                self.videos.append(asset)
                self.avseet.append(item)
            }
            self.getVideoAVAssetWithIndex(i: i+1, result: result)
        })
    }
    
    //MARK: Setup camera on and off
    func constraintForCameraOn() {
        bottomCollectionViewContraint.constant = -collectionView.bounds.height
        onCameraButton.isHidden = true
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = offCameraButton
    }
    
    func constraintForCameraOff() {
        bottomCollectionViewContraint.constant = 0
        onCameraButton.isHidden = false
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = nil
    }
    
    
    @IBAction func performOnCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.cameraCaptureMode = .video
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
    
}

extension SelectVideoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.nibName(),
                                               for: indexPath) as! VideoCollectionViewCell
        let asset = videos[indexPath.row]
        let width: CGFloat = 150
        let height: CGFloat = 150
        let size = CGSize(width:width, height:height)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: nil)
        {   (image, userInfo) -> Void in
            cell.imageView.image = image
            cell.timeLabel.text = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = TrimViewController.initWithNib()
        vc.isLiveVideo = false
        vc.asset = avseet[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SelectVideoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5,
                            left: 0,
                            bottom: 5,
                            right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthItem =
            (Constants.screenWidth - 5*2 - 5*2)/3
        // margin left,right:8 ; spacing title: 10, title: 12, 1/2 check icon : 8
        return CGSize(width: widthItem, height: widthItem)
    }
}

extension SelectVideoViewController:  AVCaptureVideoDataOutputSampleBufferDelegate {
    func setupAVCapture(){
        beginSession()
        done = true
    }
    
    func beginSession(){
        var err : NSError? = nil
        var deviceInput:AVCaptureDeviceInput?
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice!)
        } catch let error as NSError {
            err = error
            deviceInput = nil
        }
        if self.session.canAddInput(deviceInput!){
            self.session.addInput(deviceInput!)
        }
        
        videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.alwaysDiscardsLateVideoFrames=true
        videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
        videoDataOutput.setSampleBufferDelegate(self, queue:self.videoDataOutputQueue)
        if session.canAddOutput(self.videoDataOutput){
            session.addOutput(self.videoDataOutput)
        }
        videoDataOutput.connection(with: AVMediaType.video)?.isEnabled = true
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.frame = previewCameraView?.bounds ?? .zero
        previewCameraView?.layer.addSublayer(self.previewLayer!)
        session.startRunning()
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        currentFrame =   self.convertImageFromCMSampleBufferRef(sampleBuffer)
    }
    
    
    // clean up AVCapture
    func stopCamera(){
        session.stopRunning()
        done = false
    }
    
    func convertImageFromCMSampleBufferRef(_ sampleBuffer:CMSampleBuffer) -> CIImage{
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        if #available(iOS 9.0, *) {
            let ciImage:CIImage = CIImage(cvImageBuffer: pixelBuffer)
            return ciImage
        } else {
            // Fallback on earlier versions
        }
        return CIImage()
    }
}

extension SelectVideoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: false) { 
            if let assetUrl = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL {
                DispatchQueue.main.async {
                    let vc = TrimViewController.initWithNib()
                    vc.isLiveVideo = true
                    vc.asset = AVAsset(url: assetUrl)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
