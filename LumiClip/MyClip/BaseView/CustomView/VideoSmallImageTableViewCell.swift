//
//  VideoSmallImageTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol VideoSmallTableViewCellDelegate: NSObjectProtocol {
    func videoSmallImageTableViewCell(_ cell: VideoSmallImageTableViewCell, didSelectActionButton sender: UIButton)
}

class VideoSmallImageTableViewCell: BaseTableViewCell {
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var publishedTimeLabel: UILabel! /////for search v2/////
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var freeVideoImg: UIImageView!
    
    weak var delegate: VideoSmallTableViewCellDelegate?
    
   override func awakeFromNib() {
       super.awakeFromNib()
    freeVideoImg.transform = freeVideoImg.transform.rotated(by: .pi/4)
   }
    override func bindingWithModel(_ model: PBaseRowModel) {
        freeVideoImg.isHidden = !model.freeVideo
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        self.backgroundColor = UIColor.setViewColor()
        if let image = UIImage(named: model.image) {
            thumbImageView?.image = image
        } else {
            if let url = URL(string: model.image) {
                thumbImageView?.kf.setImage(with: url,
                                            placeholder: #imageLiteral(resourceName: "placeholder_video"),
                                            options: nil,
                                            progressBlock: nil,
                                            completionHandler: nil)
            }
        }
        if let rowModel = model as? VideoRowModel {
//            postedByLabel.text = rowModel.postedBy
//            viewCountLabel.text = rowModel.viewCount
            postedByLabel.text = rowModel.viewCount
            viewCountLabel.text = rowModel.postedAt
            progressBar.isHidden = rowModel.durationPercent == 0
            progressBar.progress = Float(rowModel.durationPercent)
            durationLabel.text = rowModel.duration
            durationView.isHidden = false
            publishedTimeLabel.text = ""
        } else {
            if let rowModel = model as? RowModel { /////for search v2/////
                if rowModel.isShowAllData {
                    postedByLabel.text = rowModel.channelName
                    viewCountLabel.text = rowModel.timeUpload
                    publishedTimeLabel.text = " • \(String(describing: rowModel.viewNumber)) \(String.luot_xem.lowercased())"
                }else {
                    postedByLabel.text = ""
                    viewCountLabel.text = ""
                    publishedTimeLabel.text = ""
                }
                progressBar.isHidden = true
                durationView.isHidden = true
            }else {
                publishedTimeLabel.text = ""
                postedByLabel.text = ""
                viewCountLabel.text = ""
                progressBar.isHidden = true
                durationView.isHidden = true
            }
        }
    }
    
    @IBAction func onClickEditButton(_ sender: Any) {
        delegate?.videoSmallImageTableViewCell(self, didSelectActionButton: sender as! UIButton)
    }
    
}
