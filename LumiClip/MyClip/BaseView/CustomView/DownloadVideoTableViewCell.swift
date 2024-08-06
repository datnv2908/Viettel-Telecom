//
//  VideoSmallImageTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol DownloadVideoTableViewCellDelegate: NSObjectProtocol {
    func donwloadTableViewCell(_ cell: DownloadVideoTableViewCell, didSelectActionButton sender: UIButton)
    func donwloadTableViewCell(_ cell: DownloadVideoTableViewCell, didSelectRetryButton sender: UIButton)
}

class DownloadVideoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryButtonWidth: NSLayoutConstraint!
    
    weak var delegate: DownloadVideoTableViewCellDelegate?
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        retryButton.setTitle(String.tai_lai, for: .normal)
        
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
            durationLabel.text = rowModel.duration            
            if rowModel.downloadStatus == .error {
                postedByLabel.text = String.tai_xuong_loi
                retryButton.isHidden = false
                retryButtonWidth.constant = 40
            } else {
                postedByLabel.text =  rowModel.downloadPercent
                retryButton.isHidden = true
                retryButtonWidth.constant = 0
            }
        }
    }
    
    @IBAction func onClickEditButton(_ sender: UIButton) {
        delegate?.donwloadTableViewCell(self, didSelectActionButton: sender)
    }
    
    @IBAction func onRetry(_ sender: UIButton) {
        delegate?.donwloadTableViewCell(self, didSelectRetryButton: sender)
    }
}
