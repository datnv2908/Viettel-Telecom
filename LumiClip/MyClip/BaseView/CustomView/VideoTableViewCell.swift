//
//  VideoTableViewCell.swift
//  MyClip
//
//  Created by hnc on 8/16/17.
//  Copyright © 2017 GEM. All rights reserved.
//

import UIKit
import SDWebImage

protocol VideoTableViewCellDelegate: NSObjectProtocol {
    func videoTableViewCell(_ cell: VideoTableViewCell, didTapOnAction sender: UIButton)
    func videoTableViewCell(_ cell: VideoTableViewCell, didTapOnChannel sender: UIButton)
}

class VideoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    weak var delegate: VideoTableViewCellDelegate?
   @IBOutlet weak var freeIconImg: UIImageView!
    @IBOutlet weak var seprateView: UIView!
    var videoId = ""
    var displayAnimation: Bool = false
    
    @IBOutlet weak var contentBgView: UIView!
    
   override func awakeFromNib() {
      super.awakeFromNib()
      freeIconImg.transform = freeIconImg.transform.rotated(by: .pi / 4)
   }
    override func bindingWithModel(_ model: PBaseRowModel) {
        freeIconImg.isHidden = !model.freeVideo
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.layer.masksToBounds = true        
        self.seprateView.backgroundColor = UIColor.setSeprateViewColor()
      self.contentBgView.backgroundColor = UIColor.setViewColor()
        if let url = URL(string: model.image) {
            self.thumbImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_video"))
        }
        
        if let rowModel = model as? VideoRowModel {
            if let image = UIImage(named: rowModel.avatarImage) {
                avatarImageView?.image = image
            } else {
                if let url = URL(string: rowModel.avatarImage) {
                    avatarImageView?.kf.setImage(with: url,
                                                placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                                options: nil,
                                                progressBlock: nil,
                                                completionHandler: nil)
                }else{
                    avatarImageView?.kf.setImage(with: nil,
                                                 placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                                 options: nil,
                                                 progressBlock: nil,
                                                 completionHandler: nil)
                }
            }
            authorNameLabel.text = rowModel.postedBy
            viewCountLabel.text = rowModel.viewCount
            postedTimeLabel.text = rowModel.postedAt
            videoId = rowModel.objectID
            durationLabel.text = rowModel.duration
        }
    }
    
    func displayAnimationPicture(_ model: PBaseRowModel){
        if(self.displayAnimation)
        {
            return
        }
        displayAnimation = true
        
         if let rowModel = model as? VideoRowModel {
            if let url = URL(string: rowModel.animatedImage) {
                if let image = SDImageCache.shared().imageFromDiskCache(forKey: model.image) {
                    thumbImageView?.sd_setImage(with: url, placeholderImage: image, options:
                        SDWebImageOptions.progressiveDownload, completed: { (img, err, cacheType, imgURL) in
                            if err != nil{
                                if let url = URL(string: model.image) {
                                    self.thumbImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_video"))
                                }
                            }
                    })
                }else{
                    thumbImageView?.sd_setImage(with: url, placeholderImage: nil, options:
                        SDWebImageOptions.progressiveDownload, completed: { (img, err, cacheType, imgURL) in
                            if err != nil{
                                if let url = URL(string: model.image) {
                                    self.thumbImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_video"))
                                }
                            }
                    })
                }
                
            }else{
                if let url = URL(string: model.image) {
                    self.thumbImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_video"))
                }
            }
        }
    }
    
    func hideAnimationPicture(_ model: PBaseRowModel){
        if(!self.displayAnimation)
        {
            return
        }
        displayAnimation = false
        
        if let url = URL(string: model.image) {
            self.thumbImageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder_video"))
        }
    }
    
    @IBAction func onActionTapped(_ sender: UIButton) {
        delegate?.videoTableViewCell(self, didTapOnAction: sender)
    }
    
    @IBAction func onViewChannelDetails(_ sender: UIButton) {
        delegate?.videoTableViewCell(self, didTapOnChannel: sender)
    }
    
}
