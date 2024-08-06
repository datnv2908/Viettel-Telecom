//
//  FollowTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol MyFollowTableViewCellDelegate: NSObjectProtocol {
    func followTableViewCell(_ cell: MyFollowTableViewCell, didTapOnFollow sender: UIButton)
}

class MyFollowTableViewCell: BaseTableViewCell {
    @IBOutlet weak var numberFollowLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
   @IBOutlet weak var detailContentView: UIView!
   @IBOutlet weak var deleteBg: UIView!
   
    var delegate: MyFollowTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        deleteBtn.setTitle(String.xoa, for: .normal)
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        detailContentView.backgroundColor = UIColor.setViewColor()
       contentView.backgroundColor = UIColor.setViewColor()
      deleteBg.backgroundColor = UIColor.setViewColor()
      deleteBtn.backgroundColor = UIColor.setViewColor()
      deleteBtn.setTitleColor(UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("9B9B9B"), color2: UIColor.white), for: .normal)
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
        }
    }

    
    @IBAction func onClickDeleteButton(_ sender: UIButton) {
        delegate?.followTableViewCell(self, didTapOnFollow: sender)
    }
}
