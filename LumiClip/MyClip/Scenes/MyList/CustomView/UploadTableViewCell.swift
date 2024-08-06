//
//  UploadTableViewCell.swift
//  MyClip
//
//  Created by hnc on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol UploadTableViewCellDelegate: NSObjectProtocol {
    func uploadTableViewCell(_ cell: UploadTableViewCell, didSelectEditButton sender: UIButton)
    func uploadTableViewCell(_ cell: UploadTableViewCell, didSelectRetryButton sender: UIButton)
}
class UploadTableViewCell: BaseTableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentBg: UIView!
    weak var delegate: UploadTableViewCellDelegate?
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryButtonWidthConstrain: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      self.contentView.backgroundColor = UIColor.setViewColor()
        retryButton.setTitle(String.tai_lai, for: .normal)
        contentBg.backgroundColor = UIColor.setViewColor()
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? UploadRowModel {
            timeLabel.text = rowModel.time
            if rowModel.status == .error {
                retryButtonWidthConstrain.constant = 40
                retryButton.isHidden = false
            } else {
                retryButton.isHidden = true
                retryButtonWidthConstrain.constant = 0
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onClickRetryButton(_ sender: Any) {
        delegate?.uploadTableViewCell(self, didSelectRetryButton: sender as! UIButton)
    }
    
    
    @IBAction func onClickEditButton(_ sender: Any) {
        delegate?.uploadTableViewCell(self, didSelectEditButton: sender as! UIButton)
    }
}
