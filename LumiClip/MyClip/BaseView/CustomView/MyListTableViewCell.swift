//
//  VideoSmallImageTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol MyListTableViewCellDelegate: NSObjectProtocol {
    func videoSmallImageTableViewCell(_ cell: MyListTableViewCell, didSelectActionButton sender: UIButton)
    func videoFeedbackRejectReason(_ cell: MyListTableViewCell, didSelectActionButton sender: UIButton)
}

class MyListTableViewCell: BaseTableViewCell {
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var feedbackButton: UIButton! 
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonWidth: NSLayoutConstraint!

    @IBOutlet weak var freeVideoImg: UIImageView!
    weak var delegate: MyListTableViewCellDelegate?
    
   override func awakeFromNib() {
      super.awakeFromNib()
      freeVideoImg.transform = freeVideoImg.transform.rotated(by: .pi/4)
   }
   
   override func bindingWithModel(_ model: PBaseRowModel) {
      self.backgroundColor = UIColor.setViewColor()
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        feedbackButton.setTitle(String.da_gui_y_kien, for: .normal)
        freeVideoImg.isHidden = !model.freeVideo
        
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
            postedByLabel.text = rowModel.viewCount
            viewCountLabel.text = rowModel.postedAt
            progressBar.isHidden = rowModel.durationPercent == 0
            progressBar.progress = Float(rowModel.durationPercent)
            durationLabel.text = rowModel.duration
            durationView.isHidden = false
        } else {
            postedByLabel.text = ""
            viewCountLabel.text = ""
            progressBar.isHidden = true
            durationView.isHidden = true
        }
    }
    
    @IBAction func onClickEditButton(_ sender: Any) {
        delegate?.videoSmallImageTableViewCell(self, didSelectActionButton: sender as! UIButton)
    }
    
    @IBAction func onClickFeedbackButton(_ sender: Any) {
        delegate?.videoFeedbackRejectReason(self, didSelectActionButton: sender as! UIButton)
    }
    
    
}
