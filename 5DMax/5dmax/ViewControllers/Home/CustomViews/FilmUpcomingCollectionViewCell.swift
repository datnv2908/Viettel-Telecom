//
//  FilmUpcomingCollectionViewCell.swift
//  5dmax
//
//  Created by admin on 9/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Nuke
import UIKit
import AVFoundation
import MediaPlayer
import AVKit
import SnapKit

class FilmUpcomingCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var playTrailerView: UIView!
    @IBOutlet weak var watchLatedButton: UIButton!
    @IBOutlet weak var mediaView: UIView!
    @IBOutlet weak var btnVolume: UIButton!
    @IBOutlet weak var lblPlayTrailer: UILabel!
    
    fileprivate var player: AVPlayer?
    fileprivate var playerLayer: AVPlayerLayer?
    
    var playTrailerClosure: ((Any) ->Void)?
    var watchLatedClosure: ((Any) ->Void)?
    var volumeClosure: ((Any) -> Void)?
    var setVolumeStatus: Bool = true
    let service: FilmService = FilmService()
    private var mRowModel: RowModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblPlayTrailer.text = String.phat_trailer.uppercased()
        watchLatedButton.setTitle(String.xem_sau.uppercased(), for: .normal)
        playTrailerView.layer.cornerRadius = 2
        watchLatedButton.layer.cornerRadius = 2
        playTrailerView.layer.masksToBounds = true
        watchLatedButton.layer.masksToBounds = true
        playerLayer?.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: mediaView.frame.size.height)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(stopLayerTrailer(notification:)),
                                               name: NSNotification.Name(rawValue: LocalNotificationType.stopPlayTrailer.value),
                                               object: nil)
    }

    @objc private func stopLayerTrailer(notification: Notification) {
        player?.pause()
    }
    
    @IBAction func onPlayTrailer(_ sender: Any) {
        if let closure = playTrailerClosure {
            closure(sender)
        }
    }
    
    @IBAction func onWatchLated(_ sender: Any) {
        if let closure = watchLatedClosure {
            closure(sender)
        }
    }
    
    @IBAction func onSetVolume(_ sender: Any) {
        if let item = player {
            item.isMuted = !item.isMuted
            btnVolume.isSelected = !item.isMuted
        }
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        
        if let url = URL(string: model.imageUrl),
            let thumb = thumbImageView {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
        
        if let rowModel = model as? RowModel {
            mRowModel = rowModel
            if mRowModel?.trailerItem == nil {
                playerLayer?.isHidden = true
                btnVolume.isHidden = true
                player?.isMuted = true
                btnVolume.isSelected = false
            } else {
                playerLayer?.isHidden = false
                btnVolume.isHidden = false
            }
        }
    }
    
    func startPlayTrailer() {
        if player == nil {
            self.player = AVPlayer()
            self.player?.isMuted = true
            let layer = AVPlayerLayer(player: self.player)
            layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            layer.backgroundColor = UIColor.black.cgColor
            layer.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: mediaView.frame.size.height)
            layer.isHidden = true
            playerLayer = layer
            mediaView.layer.addSublayer(layer)
            playerLayer?.needsDisplayOnBoundsChange = true
        }
        
        weak var weakSelf = self
        if let rowModel = mRowModel {
            rowModel.getTrailerComplete(comletion: { (item: AVPlayerItem) in
                weakSelf?.btnVolume.isHidden = false
                weakSelf?.player?.replaceCurrentItem(with: item)
                weakSelf?.playerLayer?.isHidden = false
                weakSelf?.player?.play()
            }) {
                weakSelf?.btnVolume.isHidden = true
                weakSelf?.playerLayer?.isHidden = true
            }
        }
    }
    
    func stopPlayTrailer() {
        self.player?.pause()
        mRowModel?.trailerItem = self.player?.currentItem
    }
    
    deinit {
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: LocalNotificationType.stopPlayTrailer.value), object: nil)
    }
}
