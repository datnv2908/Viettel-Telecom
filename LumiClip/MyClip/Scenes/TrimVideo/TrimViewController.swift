//
//  TrimViewController.swift
//  MyClip
//
//  Created by Os on 8/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CoreMedia
import AssetsLibrary
import Photos
import SwiftyJSON

class TrimViewController: BaseViewController {
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var frameContainerView: UIView!

    @IBOutlet weak var videoRangeSliderView: ABVideoRangeSlider!
    var isPlaying = true
    var isSliderEnd = true
    var player = AVPlayer()
    var playerLayer: AVPlayerLayer!
    var asset: AVAsset?
    var assetUrl: URL?
    var startTime: CGFloat = 0.0
    var stopTime: CGFloat  = 0.0
    var timerCount: CGFloat = 0.0
    var thumbTime: CMTime!
    var thumbtimeSeconds: Int!
    var videoPlaybackPosition: CGFloat = 0.0
    var rangeSlider: RangeSlider! = nil
    var timer:Timer?
    var parentVC: BaseViewController?
    var isNeedCropVideo = false
    var isLiveVideo: Bool = false
    var isFirstTime = true
    var exportSession: AVAssetExportSession?
    var nextBarButton: UIBarButtonItem!
   let service = AppService()
   var moreContent = [ContentModel]()
   //MARK:- lifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        setupView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapFrame(sender:)))
        self.frameContainerView.addGestureRecognizer(tapGesture)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerPlaybackDidFinish(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        if isFirstTime {
            isFirstTime = false
            self.setupSlider()
            DispatchQueue.main.async {
                self.showHud(in: nil, with: 0, style: .normal)
            }
            guard let asset = asset else {
                self.hideHude()
                return
            }
            assetUrl = (asset as? AVURLAsset)?.url
            asset.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: {
                DispatchQueue.main.async {
                    self.thumbTime = asset.duration
                    self.thumbtimeSeconds      = Int(CMTimeGetSeconds(self.thumbTime))
                    self.player.replaceCurrentItem(with: nil)
                    let item: AVPlayerItem = AVPlayerItem(asset: asset)
                    self.player.replaceCurrentItem(with: item)
                    self.playerLayer           = AVPlayerLayer(player: self.player)
                    self.playerLayer.frame     = self.videoContainerView.bounds
                    self.playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                    self.player.actionAtItemEnd   = AVPlayer.ActionAtItemEnd.none
                    self.player.volume = 1.0
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnVideoLayer(tap:)))
                    self.videoContainerView.addGestureRecognizer(tap)
                    self.videoContainerView.layer.addSublayer(self.playerLayer)
                    self.createImageFrames()
                    self.videoRangeSliderView.setVideoURL(videoURL: self.assetUrl!)
                    self.player.play()
                    self.startTime = 0.0
                    self.stopTime = CGFloat(CMTimeGetSeconds((self.player.currentItem?.asset.duration)!))
                    self.startTimer()
                    self.hideHude()
                }
            })
        } else {
            // don't setup player again
        }
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        player.pause()
    }
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
    
      self.getMoreContent()
      
   }
   
   override func viewWillDisappear(_ animated: Bool) {
       timer = nil
   }
    
    override func setupView() {
        navigationItem.title = String.chinh_sua_video
        nextBarButton = UIBarButtonItem(title: String.tiep_tuc.uppercased(),
                                        style: .plain,
                                        target: self,
                                        action: #selector(didSelectNextButton(_:)))
        navigationItem.rightBarButtonItem = nextBarButton
        navigationItem.backBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didSelectBackButton(_:)))
    }
    
    @objc func tapFrame(sender: UITapGestureRecognizer) {
        self.videoRangeSliderView.progressIndicator.isHidden = false
        self.videoRangeSliderView.progressTimeView.isHidden = false
        
        let point = sender.location(in: self.frameContainerView)
        if point.x > self.videoRangeSliderView.startIndicator.frame.origin.x &&
            point.x < self.videoRangeSliderView.endIndicator.frame.origin.x {
            let second = (point.x/self.frameContainerView.frame.size.width)*CGFloat(CMTimeGetSeconds((self.player.currentItem?.asset.duration)!))
            self.videoRangeSliderView.updateProgressIndicator(position: point.x)
            self.player.seek(to: CMTimeMake(value: Int64(second), timescale: 1))
        }
    }
    
    @IBAction func didSelectBackButton(_ sender: Any) {
//        let dialog = DialogViewController(title: String.chinh_sua_video,
//                                          message: String.loai_bo_nhung_thay_doi,
//                                          confirmTitle: String.dong_y,
//                                          cancelTitle: String.huy)
//        weak var wself = self
//        dialog.confirmDialog = { button in
//            wself?.stopTimer()
//            _ = wself?.navigationController?.popViewController(animated: true)
//        }
//        present(dialog, animated: true, completion: nil)
        
        self.showAlert(title: String.chinh_sua_video, message: String.loai_bo_nhung_thay_doi, okTitle: String.dong_y, onOk: { [weak self] _ in
            self?.stopTimer()
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func didSelectNextButton(_ sender: Any) {
        guard let url = assetUrl else {
            return
        }
        cropVideo(sourceURL1: url as NSURL, startTime: Float(startTime), endTime: Float(stopTime))
    }
    
   
    
    func setupSlider() {
        videoRangeSliderView.delegate = self
        videoRangeSliderView.minSpace = 1.0
        videoRangeSliderView.setStartIndicatorImage(image: #imageLiteral(resourceName: "rec1"))
        videoRangeSliderView.setEndIndicatorImage(image: #imageLiteral(resourceName: "rec1"))
        videoRangeSliderView.setBorderImage(image: #imageLiteral(resourceName: "rec2"))
        videoRangeSliderView.startTimeView.isHidden = true
        videoRangeSliderView.endTimeView.isHidden = true
        perform(#selector(hiddenProgressTimeView), with: nil, afterDelay: Constants.kDelaytime)
    }
    
    //Tap action on video player
    @objc func tapOnVideoLayer(tap: UITapGestureRecognizer) {
        print(self.player.currentTime())
        if !isPlaying {
            isPlaying = true
            self.player.play()
            startTimer()
        }
        else {
            isPlaying = false
            self.player.pause()
        }
    }

    //MARK: CreatingFrameImages
    func createImageFrames() {
        //creating assets
        guard let asset = asset else {
            return
        }
        let assetImgGenerate : AVAssetImageGenerator    = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.requestedTimeToleranceAfter    = CMTime.zero;
        assetImgGenerate.requestedTimeToleranceBefore   = CMTime.zero;

        assetImgGenerate.appliesPreferredTrackTransform = true
        let thumbTime: CMTime = asset.duration
        let thumbtimeSeconds  = Int(CMTimeGetSeconds(thumbTime))
        let maxLength         = "\(thumbtimeSeconds)" as NSString
        
        let thumbAvg  = thumbtimeSeconds/6
        var startTime = 1
        var startXPosition:CGFloat = 0.0
        for _ in 0...5 {
            
            let imageButton = UIButton()
            let xPositionForEach = CGFloat(self.frameContainerView.frame.width)/6
            imageButton.frame = CGRect(x: CGFloat(startXPosition), y: CGFloat(0), width: xPositionForEach, height: CGFloat(self.frameContainerView.frame.height))
            do {
                let time:CMTime = CMTimeMakeWithSeconds(Float64(startTime),preferredTimescale: Int32(maxLength.length))
                let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: img)
                imageButton.setImage(image, for: .normal)
            }
            catch (let error) {
                print("Image generation failed with error \(error)")
            }
            startXPosition = startXPosition + xPositionForEach
            startTime = startTime + thumbAvg
            imageButton.isUserInteractionEnabled = false
            frameContainerView.addSubview(imageButton)
        }
    }
    //MARK: - get mutilChanel

   
   //MARK: - Get More Content
   func getMoreContent() {
      self.showHud()
      let category = "category_parent"
      let page = Pager(offset: 0, limit: 15)
      videoService.getMoreContents(for: category, pager: page ) { (result) in
         switch result {
         case .success (let response):
            let model = response.data
            self.moreContent = model
            self.hideHude()
         case .failure(let err):
            self.toast(err.localizedDescription)
            self.hideHude()
         }
         
      }
   }
    //Trim Video Function
    func cropVideo(sourceURL1: NSURL, startTime: Float, endTime: Float) {
        guard let asset = asset else {
            return
        }
        nextBarButton.isEnabled = false
        showHud(in: nil, with: 0, style: .normal)
        let manager                 = FileManager.default
        guard let documentDirectory = try? manager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true) else {return}
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")
        let start = startTime
        let end = endTime
        print(documentDirectory)
        var outputURL = documentDirectory.appendingPathComponent("output")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            //let name = hostent.newName()
            var name = ""
            if let value = sourceURL1.lastPathComponent {
                name = value
            } else {
                name = String(NSDate().timeIntervalSince1970)
            }
            outputURL = outputURL.appendingPathComponent("\(name)")

        } catch let error {
            print(error)
        }
        _ = try? manager.removeItem(at: outputURL)
        exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL
        exportSession?.outputFileType = AVFileType.mp4

        let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
        let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)

        exportSession?.timeRange = timeRange
        exportSession?.exportAsynchronously {
            switch self.exportSession?.status {
            case .completed?:
                print("exported at \(outputURL)")
                DispatchQueue.main.async(execute: {
                    let uploadVC = UploadViewController.initWithNib()
                    uploadVC.videoURL = outputURL
                    uploadVC.isLiveVideo = self.isLiveVideo

                   uploadVC.moreContent = self.moreContent
                    self.navigationController?.pushViewController(uploadVC, animated: true)
                })
            case .failed?:
                print("failed \(String(describing: self.exportSession?.error))")
            case .cancelled?:
                print("cancelled \(String(describing: self.exportSession?.error))")
            default: break
            }
            self.hideHude()
            self.nextBarButton.isEnabled = true
        }
    }
    
    @objc func playerPlaybackDidFinish(_ notification: Notification) {
        print(self.player.currentTime())
        self.videoRangeSliderView.updateProgressIndicator(seconds: Float64(startTime))
        self.player.seek(to: CMTimeMake(value: Int64(startTime), timescale: 1))
        print(self.player.currentTime())
        self.player.pause()
        self.videoRangeSliderView.progressIndicator.isHidden = false
        isPlaying = false
    }
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(update(_:)),
                                         userInfo: nil,
                                         repeats: true)
            timer?.fire()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func update(_ timer: Timer) {
        if !isPlaying {
            return
        }
        
        if player.currentItem != nil && CMTIME_IS_VALID((player.currentItem?.duration)!) {
            self.videoRangeSliderView.updateProgressIndicator(seconds: CMTimeGetSeconds(player.currentTime()))
            if self.videoRangeSliderView.progressIndicator.frame.origin.x >= self.videoRangeSliderView.endIndicator.frame.origin.x {
                self.player.seek(to: CMTimeMake(value: Int64(startTime), timescale: (player.currentItem?.duration.timescale)!))
                isPlaying = false
                self.player.pause()
            }
        }
    }
    
    deinit {
        player.pause()
        player.replaceCurrentItem(with: nil)
        asset = nil
        exportSession?.cancelExport()
        DLog("")
    }
    
    @objc func hiddenProgressTimeView() {
        self.videoRangeSliderView.progressTimeView.isHidden = true
    }
}

//MARK: - ABVideoRangeSliderDelegate
extension TrimViewController: ABVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: ABVideoRangeSlider, startTime: Float64, endTime: Float64) {
        self.isNeedCropVideo = true
        self.player.seek(to: CMTimeMake(value: Int64(startTime), timescale: 1))
        self.startTime = CGFloat(startTime)
        self.stopTime = CGFloat(endTime)
        self.videoRangeSliderView.updateProgressIndicator(position: CGFloat(startTime))
        self.videoRangeSliderView.progressTimeView.isHidden = false
        perform(#selector(hiddenProgressTimeView), with: nil, afterDelay: Constants.kDelaytime)
        timerCount = 0
    }
    
    func sliderGesturesBegan() {
        self.videoRangeSliderView.progressIndicator.isHidden = true
    }
    
    func sliderGesturesEnded() {
        self.videoRangeSliderView.progressIndicator.isHidden = false
    }
    
    func indicatorDidChangePosition(videoRangeSlider: ABVideoRangeSlider, position: Float64) {
        self.player.seek(to: CMTimeMake(value: Int64(position), timescale: 1))
        self.videoRangeSliderView.progressTimeView.isHidden = false
        perform(#selector(hiddenProgressTimeView), with: nil, afterDelay: Constants.kDelaytime)
        self.player.pause()
        self.isPlaying = false
    }
}
