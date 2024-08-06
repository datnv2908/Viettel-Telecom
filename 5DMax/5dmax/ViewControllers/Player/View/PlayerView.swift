//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import UIKit
import Nuke
import AVFoundation
import MBProgressHUD
import MediaPlayer
import AVKit
import MessageUI

protocol PlayerViewDelegate: NSObjectProtocol {
    func didSelectPart(_ model: PartModel)
}

@objcMembers
class PlayerView: BaseViewController, PlayerViewProtocol, MFMessageComposeViewControllerDelegate {
    weak var delegate: PlayerViewDelegate?
    var presenter: PlayerPresenterProtocol?
    weak var filmDetailVC: FilmDetailViewProtocol?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var btnRewin10s: UIButton!
    @IBOutlet weak var btnNext10s: UIButton!
    @IBOutlet weak var topControlView: UIView!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var titleLabel: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var episodeListBtn: UIButton!
    @IBOutlet weak var qualityBtn: UIButton!
    @IBOutlet weak var bottomControlView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var movieSlider: MoviePlayerSlider!
    @IBOutlet weak var playPauseBtn: UIButton!
    @IBOutlet weak var bufferingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var timeSliderContainerView: UIView!
    @IBOutlet weak var btnPreviousEp: UIButton!
    
    fileprivate var player: AVPlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    fileprivate var playerItem: AVPlayerItem?
    fileprivate var sliderTimer: Timer?
    fileprivate var hideControlBarsTimer: Timer?
    fileprivate var isControlBarHiddden = false
    fileprivate var allowToChangeMovieSlider = true
    fileprivate var timeSecondToSeek: Float64 = 0
    fileprivate var streamUrl: URL!
    fileprivate var previewImage: String = ""
    fileprivate var seekFrameView: SeekFrameView?
    fileprivate var alertView: UIAlertController?
    fileprivate var service: FilmService = FilmService()
    fileprivate var firstTimeSeenFromNoti : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name:NSNotification.Name(rawValue: Constants.kNotificationResignActive), object: nil)
        
        self.episodeListBtn.setTitle(String.danh_sach_tap, for: .normal)
        self.qualityBtn.setTitle(String.chat_luong, for: .normal)
        self.btnNext.setTitle(String.tap_tiep_theo, for: .normal)
        UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        setUpSeekFrameView()
        self.setupUI()
        presenter?.viewDidLoad()
        
        self.view.stopSnowing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logViewEvent(Constants.fire_base_play_movie, Constants.fire_base_play_movie_event)
        presenter?.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.player?.status == .readyToPlay {
            self.playPlayer()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            UIDevice.current.setValue(Int(UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
            UINavigationController.attemptRotationToDeviceOrientation()
        }
        pausePlayer()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isBeingDismissed {
            reset()
            presenter?.deallocView()
        }
    }
    
    @objc func resignActive() {
        self.alertView?.dismiss(animated: true, completion: nil)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.playerLayer?.frame = self.contentView.bounds
    }
    
//    func prefersHomeIndicatorAutoHidden() -> Bool {
//        return true
//    }

    func setUpSeekFrameView() {
        let frameView: SeekFrameView = Bundle.main.loadNibNamed("SeekFrameView", owner: nil, options: nil)?.first as! SeekFrameView
        frameView.frame = CGRect(x: 0, y: 0, width: SeekFrameView.kSeekFrameWidth, height: SeekFrameView.kSeekFrameHeight)
        frameView.layer.borderWidth = 2.0
        frameView.layer.borderColor = UIColor.white.cgColor
        frameView.isHidden = true
        frameView.backgroundColor = UIColor.black
        self.view.addSubview(frameView)
        seekFrameView = frameView
    }
    
    func setupUI() {
        self.btnPreviousEp.setTitle(String.previous, for: .normal)
        view.backgroundColor = UIColor.black
        self.player = AVPlayer()
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect//AVLayerVideoGravityResizeAspectFill
        self.playerLayer?.backgroundColor = UIColor.black.cgColor
        self.contentView.layer.addSublayer(self.playerLayer!)
        addPlayerObserver()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PlayerView.playerPlaybackDidFinish(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PlayerView.applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PlayerView.applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        let touch = UITapGestureRecognizer(target: self,
                                           action: #selector(PlayerView.showHideControlBars))
        self.contentView.addGestureRecognizer(touch)
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: .main, using: { [self] (time) in
            if let player = self.player {
                let currentTime = CMTimeGetSeconds(player.currentTime())
                guard !(currentTime.isNaN || currentTime.isInfinite) else {
                    return
                }
                let secs = Int(currentTime) ?? 0
                self.presenter?.setCurrentTime(currentTimePlaying: currentTime)
                if self.firstTimeSeenFromNoti == false {
                 if secs - Int(self.timeSecondToSeek)  > 10 {
                        if let model = self.presenter?.viewModel.playListModel {
                            service.getPlaylist(playListID: model.detail.filmId, videoID: model.detail.getCurrentVideoId(), profileID: nil, noti: self.presenter?.viewModel.fromNoti ?? false,sendNoti: self.presenter?.viewModel.sendView ?? false) { (_ result) in
                            }
                        }
                       
                        self.firstTimeSeenFromNoti = true
                    }
                }
                
            
            
            }
            
        }
            )
            
        episodeListBtn.isEnabled = false
        btnNext.isEnabled = false
        btnPreviousEp.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(PlayerView.timeSliderTap(tap:)))
        self.timeSliderContainerView.addGestureRecognizer(tap)
    }

    fileprivate func addPlayerObserver() {
        self.player?.addObserver(self, forKeyPath: #keyPath(AVPlayer.rate),
                                 options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }

    fileprivate func removePlayerObserver() {
        self.player?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.rate), context: nil)
    }

    fileprivate func addPlayerItemObserver() {
        self.player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status),
                                              options: [.new], context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty),
                                              options: [.new], context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath:#keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp
            ),options: [.new], context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(note:)), name:  NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        self.player?.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferFull),  options: [.new], context: nil)
    }

    fileprivate func removePlayerItemObserver() {
        if self.playerItem?.observationInfo != nil {
            self.playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), context: nil)
            self.playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferEmpty),
                                            context: nil)
            self.playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp),
                                            context: nil)
            self.playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.isPlaybackBufferFull),
                                            context: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
//            NotificationCenter.default.removeObserver(self, selector: Selector("playerDidFinishPlaying:"), name:  NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        }
    }

    fileprivate func resetPlayerItemIfNeeded() {
        removePlayerItemObserver()
        playerItem = nil
        player?.seek(to: CMTime.zero)
        self.movieSlider.value = 0.0
        self.timeLabel.text = "--:--:--"
    }

    override var prefersStatusBarHidden: Bool {
        return self.isControlBarHiddden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func playerDidFinishPlaying(note: NSNotification) {
    
        self.resetPlayerItemIfNeeded()
         presenter?.nextSeason()
    }
    
    func canRotate() {}

    func reset() {
        player?.pause()

        if sliderTimer != nil {
            sliderTimer?.invalidate()
            sliderTimer = nil
        }

        if hideControlBarsTimer != nil {
            hideControlBarsTimer?.invalidate()
            hideControlBarsTimer = nil
        }

        playerItem = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        removePlayerObserver()
        resetPlayerItemIfNeeded()
        self.player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(
                                                    rawValue: "AVSystemController_SystemVolumeDidChangeNotification"),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
        player = nil
    }
    
    //mark: --PlayerViewProtocol
    func reloadView() {
        if let model = presenter?.viewModel {
            let isShow = model.isShowEpisodeButton()
            self.episodeListBtn.isEnabled = isShow
            self.btnNext.isEnabled = isShow
            self.btnPreviousEp.isEnabled = isShow
            titleLabel.setTitle(model.playerName(), for: .normal)
            
            if let urlStr = model.coverImage {
                if let url = URL(string: urlStr),
                    let thumb = coverImageView {
                    let request = ImageRequest(url: url)
                    Nuke.loadImage(with: request, into: thumb)
                }
            }
        }
    }

    func playStreaming(_ url: URL, previewImage: String, timeToSeek: Float64 = 0, changeQuality: Bool = false) {
        if self.player == nil {
            return
        }
        
        if self.playerLayer == nil {
            self.playerLayer = AVPlayerLayer(player: self.player)
            self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.contentView.layer.addSublayer(self.playerLayer!)
        }
        
        self.streamUrl = url
        self.previewImage = previewImage
        self.timeSecondToSeek = timeToSeek
        if changeQuality {
            if let time = player?.currentTime() {
                let currentPlayedTime = CMTimeGetSeconds(time)
                if currentPlayedTime.isNaN == false {
                    self.timeSecondToSeek = currentPlayedTime
                }
            }
        } else {
            self.movieSlider.value = 0.0
            self.timeLabel.text = "--:--:--"
        }

        self.pausePlayer()
        self.doShowBuffering(true)
        self.loadAssetWithURLStr(streamUrl: self.streamUrl, seekTime: self.timeSecondToSeek)
    }
    
    func loadAssetWithURLStr(streamUrl: URL, seekTime: Float64) {
        let asset = AVAsset(url: streamUrl)
        asset.loadValuesAsynchronously(forKeys: ["duration"], completionHandler: {
            DispatchQueue.main.async {
                self.resetPlayerItemIfNeeded()
                let movieItem = AVPlayerItem(asset: asset)
                self.playerItem = movieItem
                self.player?.replaceCurrentItem(with: movieItem)
                self.addPlayerItemObserver()
                let timeScale = asset.duration.timescale
                if CMTIME_IS_VALID(asset.duration) {
                    let time = CMTimeMakeWithSeconds(seekTime, preferredTimescale: timeScale)
                    self.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
                }
                self.playPlayer()
            }
        })
    }

    func checkCurrentTime() -> Float64 {
        if let time = player?.currentTime() {
            let currentPlayedTime = CMTimeGetSeconds(time)
            return currentPlayedTime
        }
        return 0.0
    }

    deinit {
        DLog("release player")
        self.player?.replaceCurrentItem(with: nil)
        playerItem = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    func showSMSConfirm(_ fromView: PlayerViewProtocol?, message: String, number: String, content: String){
        let fromViewController = fromView as! UIViewController
        let alertController = UIAlertController(title: String.registerSubTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: String.okString, style: .default) { (_) in
            if MFMessageComposeViewController.canSendText() == true {
                let recipients:[String] = [number]
                let messageController = MFMessageComposeViewController()
                messageController.messageComposeDelegate  = self
                messageController.recipients = recipients
                messageController.body = content
                fromViewController.present(messageController, animated: true, completion: nil)
            } else {
                //handle text messaging not available
                fromViewController.toast(String.thiet_bi_khong_ho_tro_nhan_tin)
            }
        }
        let cancelAction = UIAlertAction(title: String.ignore, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        alertController.setValue(NSAttributedString(html: message), forKey: "attributedMessage")
        fromViewController.present(alertController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult){
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnPrevious(_ sender: Any) {
        self.resetPlayerItemIfNeeded()
       presenter?.previousSeason()
    }
    
}

//mark: - AVPlayer
extension PlayerView {
    @objc func showHideControlBars() {
        if self.isControlBarHiddden {
            self.showControlBars()
            self.hideControlBarsAfterMinutes()
        } else {
            self.hideControlBars()
        }
    }

    @objc func hideControlBars() {
        self.btnNext10s.isHidden = true
        self.btnRewin10s.isHidden = true
        self.playPauseBtn.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            self.topControlView.alpha = 0.0
            self.bottomControlView.alpha = 0.0
            self.isControlBarHiddden  = true
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    func showControlBars() {
        self.btnNext10s.isHidden = false
        self.btnRewin10s.isHidden = false
        self.playPauseBtn.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.topControlView.alpha = 1.0
            self.bottomControlView.alpha = 1.0
            self.isControlBarHiddden  = false
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }

    func hideControlBarsAfterMinutes() {
        if self.hideControlBarsTimer != nil {
            self.hideControlBarsTimer?.invalidate()
            self.hideControlBarsTimer = nil
        }

        self.hideControlBarsTimer = Timer.scheduledTimer(timeInterval: 5,
                                                         target: self,
                                                         selector: #selector(PlayerView.hideControlBars),
                                                         userInfo: nil, repeats: false)
    }

    func stopHideControlBarsAfterMinutes() {
        if self.hideControlBarsTimer != nil {
            self.hideControlBarsTimer?.invalidate()
            self.hideControlBarsTimer = nil
        }
    }

    //Notificaions
    @objc func playerPlaybackDidFinish(notification: Notification) {

        self.sliderTimer?.invalidate()
        self.sliderTimer = nil
        //Reset Control Bar
        self.pausePlayer()
        self.player?.seek(to: CMTime.zero)
        self.movieSlider.value = 0.0
        self.timeLabel.text = self.convertPlayerTime(time: (self.player?.currentItem?.duration)!)
        self.showControlBars()
        presenter?.didFinishPlayback()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayer.rate) {
            if self.player?.rate == 0.0 {
                //Paused
                self.sliderTimer?.invalidate()
                self.sliderTimer = nil

                self.hideControlBarsTimer?.invalidate()
                self.hideControlBarsTimer = nil

                self.showControlBars()
            } else {
                //Playing
                self.bufferingIndicator.stopAnimating()
                if  self.player?.currentItem?.duration.isValid == true &&
                    self.player?.currentItem?.duration.isIndefinite == false {
                    if self.sliderTimer == nil {
                        self.sliderTimer =
                            Timer.scheduledTimer(timeInterval: 0.2,
                                                 target: self,
                                                 selector: #selector(PlayerView.updateMovieProgressTime),
                                                 userInfo: nil, repeats: true)
                    }
                    self.hideControlBarsAfterMinutes()
                }
            }
        } else if keyPath == #keyPath(AVPlayerItem.status) {
            if self.player?.currentItem?.status == .readyToPlay {
                if self.sliderTimer == nil {
                    self.sliderTimer =
                        Timer.scheduledTimer(timeInterval: 0.2,
                                             target: self,
                                             selector: #selector(PlayerView.updateMovieProgressTime),
                                             userInfo: nil, repeats: true)
                }
                self.hideControlBarsAfterMinutes()
                presenter?.startKPITimer()
                print("start send time ")
                presenter?.onPlay()
            } else {
                
//                self.alertView = self.alertWithTitle(nil, message: self.player?.currentItem?.error?.localizedDescription)
            }
        } else if keyPath == #keyPath(AVPlayerItem.isPlaybackBufferEmpty) {
            let item = object as? AVPlayerItem
            if item?.isPlaybackBufferEmpty == true {
                self.stopHideControlBarsAfterMinutes()
                self.contentView.bringSubviewToFront(self.bufferingIndicator)
                self.doShowBuffering(false)
                presenter?.onBuffering()
            } else {
                self.doShowBuffering(false)
            }
        } else if keyPath == #keyPath(AVPlayerItem.isPlaybackLikelyToKeepUp) {
            let item = object as? AVPlayerItem
            if item?.isPlaybackLikelyToKeepUp == true {
                self.doShowBuffering(true)
                presenter?.onFinishBuffering()
            } else {
                self.doShowBuffering(false)
            }
        } else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    @objc func applicationDidEnterBackground() {
        self.pausePlayer()
        presenter?.didEnterBackground()
    }

    @objc func applicationWillEnterForeground() {
        self.showControlBars()
    }
    
    func doShowBuffering(_ isShow: Bool) {
        if isShow {
            self.bufferingIndicator.startAnimating()
        } else {
            self.bufferingIndicator.stopAnimating()
        }
    }
}

//MARK:-
//MARK: - IBAction
extension PlayerView {
    @IBAction func backAction(_ sender: Any) {
        presenter?.didTapOnClose(sender)
    }

    @IBAction func episodeAction(_ sender: Any) {
        presenter?.didTapOnEpisode(sender)
    }

    @IBAction func playPauseAction(_ sender: Any) {
        if self.player?.rate != 0.0 {
            presenter?.onPause()
            self.pausePlayer()
        } else {
            presenter?.onPlay()
            self.playPlayer()
        }
    }

    @IBAction func rewind10secAction(_ sender: Any) {
        if self.player?.currentItem?.duration.isValid == true &&
            self.player?.currentItem?.duration.isIndefinite == false {
            var currentTime = 0.0
            if let time = player?.currentTime() {
                currentTime = CMTimeGetSeconds(time)
            }
            let seekTime = max(0, currentTime - 10.0)
            let timeScale = (self.player?.currentItem?.duration.timescale)!
            let time = CMTimeMakeWithSeconds(seekTime, preferredTimescale: timeScale)
            self.player?.seek(to: time)
        }
    }
    
    @IBAction func next10secAction(_ sender: Any) {
        if self.player?.currentItem?.duration.isValid == true &&
            self.player?.currentItem?.duration.isIndefinite == false {
            var currentTime = 0.0
            if let time = player?.currentTime() {
                currentTime = CMTimeGetSeconds(time)
            }
            let seekTime = max(0, currentTime + 10.0)
            let timeScale = (self.player?.currentItem?.duration.timescale)!
            let time = CMTimeMakeWithSeconds(seekTime, preferredTimescale: timeScale)
            self.player?.seek(to: time)
        }
    }

    @IBAction func movieSliderTouched(_ sender: Any) {
        if self.sliderTimer != nil {
            self.sliderTimer?.invalidate()
            self.sliderTimer = nil
        }
        self.allowToChangeMovieSlider = false
        self.stopHideControlBarsAfterMinutes()
    }
    
    @IBAction func movieSliderTouchUp(_ sender: Any) {
        seekFrameView?.isHidden = true
    }

    @IBAction func movieSliderValueChanged(_ sender: Any) {
        if self.player?.currentItem?.duration.isValid == true && self.player?.currentItem?.duration.isIndefinite == false {
            let seekTime = CMTimeGetSeconds((self.player?.currentItem?.duration)!) * Double(self.movieSlider.value)
            let timeScale = (self.player?.currentItem?.duration.timescale)!
            let time = CMTimeMakeWithSeconds(seekTime, preferredTimescale: timeScale)
            self.player?.seek(to: time)
            self.allowToChangeMovieSlider = true
            self.hideControlBarsAfterMinutes()
            presenter?.onSeeked()
            updateSeekFrame(seekTime)
        } else {
            self.movieSlider.value = 0.0
        }
    }
    
    func updateSeekFrame(_ second: Double) {
        if previewImage.isEmpty {
            seekFrameView?.isHidden = true
            return
        }
        
        guard let seekView = seekFrameView else {
            return
        }
        
        let width = movieSlider.frame.size.width
        let point = movieSlider.convert(movieSlider.frame.origin, to: self.view)
        let originX = CGFloat(movieSlider.value)*width + point.x
        
        var frame = seekView.frame
        frame.origin.x = originX - frame.size.width/2
        frame.origin.x = frame.origin.x < 15.0 ? 15.0 : frame.origin.x
        frame.size.width = CGFloat(SeekFrameView.kSeekFrameWidth)
        frame.size.height = CGFloat(SeekFrameView.kSeekFrameHeight)
        if frame.origin.x + frame.size.width > self.view.frame.size.width {
            frame.origin.x = self.view.frame.size.width - 15.0 - frame.size.width
        }
        
        frame.origin.y = bottomControlView.frame.origin.y - frame.size.height
        seekView.frame = frame
        seekView.isHidden = false
        seekView.displayFrameAt(second: second, frameLink: previewImage)
        self.view.bringSubviewToFront(seekView)
    }
    
    @IBAction func bnNextPressed(_ sender: Any) {
        self.resetPlayerItemIfNeeded()
        presenter?.nextSeason()
        
    }
    
    @IBAction func btnQualityPressed(_ sender: Any) {
       presenter?.doShowSelectQuality()
    }

    @objc func timeSliderTap(tap: UITapGestureRecognizer) {
        let location = tap.location(in: self.timeSliderContainerView)
        let time = location.x / self.timeSliderContainerView.frame.size.width

        if self.player?.currentItem?.duration.isValid == true &&
            self.player?.currentItem?.duration.isIndefinite == false {
            self.movieSlider.value = Float(time)

            let seekTime = CMTimeGetSeconds((self.player?.currentItem?.duration)!) * Double(self.movieSlider.value)
            let timeScale = (self.player?.currentItem?.duration.timescale)!
            let time = CMTimeMakeWithSeconds(seekTime, preferredTimescale: timeScale)
            self.player?.seek(to: time)
            self.allowToChangeMovieSlider = true
            self.hideControlBarsAfterMinutes()
            presenter?.onSeeked()
        }
    }
    
    fileprivate func doPlayPart(_ part: PartModel) {
        resetPlayerItemIfNeeded()
        self.player?.replaceCurrentItem(with: nil)
        presenter?.didSelectPart(part)
        delegate?.didSelectPart(part)
    }
}

//mark: - Utilities
extension PlayerView {
    func makeGadientBackground(view: UIView!, fromTop: Bool) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let width = max(Constants.screenWidth, Constants.screenHeight)
        gradient.frame.size.width = width

        let black = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

        if fromTop {
            gradient.colors = [black.cgColor, UIColor.clear.cgColor]
        } else {
            gradient.colors = [UIColor.clear.cgColor, black.cgColor]
        }
        view.layer.insertSublayer(gradient, at: 0)
    }

    @objc func updateMovieProgressTime () {
        if let assetItem = self.player?.currentItem {
            self.timeLabel.text = self.convertPlayerTime(time: assetItem.duration - assetItem.currentTime())
            if self.allowToChangeMovieSlider {
                let duration = CMTimeGetSeconds(assetItem.duration)
                let playTime = CMTimeGetSeconds(assetItem.currentTime())
                self.movieSlider.value = Float(playTime / duration)
            }
            
            if let rate = self.player?.rate, rate > 0 {
                self.doShowBuffering(false)
            }
        }
    }

    func convertPlayerTime(time: CMTime) -> String {
        if time.isValid == false || time.isIndefinite == true {
            return "--:--:--"
        }
        let timeValue = CMTimeGetSeconds(time)
        return Int(timeValue).durationString()
    }

    func playPlayer() {
        self.player?.play()
        self.playPauseBtn.setImage(UIImage(named: "icPauseCast"), for: .normal)
    }

    func pausePlayer() {
        self.player?.pause()
        self.playPauseBtn.setImage(UIImage(named: "icPlayMovie"), for: .normal)
    }
    
    func getCurrentTime() -> Float64 {
        if let assetItem = self.player?.currentItem {
            let time = assetItem.currentTime()
            return CMTimeGetSeconds(time)
        }
        return 0
    }
}

extension PlayerView: ListEpisodeViewDelegate {
    func listEpisodeView(_ viewcontroller: ListEpisodeViewController, didSelectPart part: PartModel) {
        self.doPlayPart(part)
    }
}
