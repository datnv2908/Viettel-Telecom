

//
//  NotificationTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol NotificationTableViewCellDelegate: NSObjectProtocol {
    func notificationTableViewCell(_ cell: NotificationTableViewCell, didSelectEditButton sender: UIButton)
}

class NotificationTableViewCell: BaseTableViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var isReadStatusView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    weak var delegate: NotificationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.contentView.backgroundColor = UIColor.setViewColor()
    }

    override func bindingWithModel(_ model: PBaseRowModel) {
        if let rowModel = model as? NotificationRowModel {
            titleLabel?.text = rowModel.title
            descLabel?.text = rowModel.desc
            isReadStatusView.isHidden = true
            editButton.isHidden = true
//            isReadStatusView.isHidden = rowModel.isRead
            if let url = URL(string: rowModel.avatarImage) {
                thumbImageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "iconUserLarge"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            if let url = URL(string: rowModel.coverImage) {
                coverImageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder_video"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
   
   func bindingWithModel(_ model: CommentModelDisplay) {
      titleLabel?.text = model.name
      descLabel?.text = model.published_time
//      if let url = URL(string: model.listComment.avatarImage) {
//          thumbImageView?.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "iconUserLarge"), options: nil, progressBlock: nil, completionHandler: nil)
//      }
      if  let url = URL(string: model.coverImage) {
         self.coverImageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
      }
   }
   
    @IBAction func onClickEditButton(_ sender: Any) {
        delegate?.notificationTableViewCell(self, didSelectEditButton: sender as! UIButton)
    }
    
}
