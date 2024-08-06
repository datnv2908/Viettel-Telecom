//
//  FollowTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol FollowTableViewCellDelegate: NSObjectProtocol {
    func followTableViewCell(_ cell: FollowTableViewCell, didTapOnFollow sender: UIButton)
}

class FollowTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var numberFollowLabel: UILabel!
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet var bgView: [UIView]!
    
    
    var delegate: FollowTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followLabel.text = String.theo_doi
        unFollowButton.setTitle(String.unFollow, for: .normal)
      self.followLabel.textColor = UIColor.settitleColor()
      self.unFollowButton.setTitleColor(UIColor.settitleColor(), for: .normal)
      self.backgroundColor = UIColor.setViewColor()
      self.numberFollowLabel.textColor = UIColor.settitleColor()
        for item in bgView {
            item.backgroundColor = UIColor.setViewColor()
        }
      viewFollow.backgroundColor = UIColor.setViewColor()
      contentView.backgroundColor = UIColor.setViewColor()
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        if let url = URL(string: model.image) {
            thumbImageView?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
        if let rowModel = model as? FollowRowModel {
            numberFollowLabel.text = rowModel.followCount
            if(rowModel.isFollow){
                unFollowButton.isHidden = false
                viewFollow.isHidden = true
            }else{
                unFollowButton.isHidden = true
                viewFollow.isHidden = false
            }
        }
    }
    

    @IBAction func onClickFollowButton(_ sender: UIButton) {
        delegate?.followTableViewCell(self, didTapOnFollow: sender)
    }
}
