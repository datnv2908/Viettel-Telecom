//
//  FollowTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol AddChannelTableViewCellDelegate: NSObjectProtocol {
    func followTableViewCell(_ cell: AddChannelTableViewCell, didTapOnFollow sender: UIButton)
}

class AddChannelTableViewCell: BaseTableViewCell {
    @IBOutlet weak var numberFollowLabel: UILabel!
   @IBOutlet weak var detailComtentView: UIView!
   @IBOutlet weak var addChannelBtn: UIButton!
   @IBOutlet weak var BtnAddView: UIView!
   
    var delegate: AddChannelTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      BtnAddView.backgroundColor =  UIColor.setViewColor()
      detailComtentView.backgroundColor  = UIColor.setViewColor()
       self.backgroundColor = UIColor.setViewColor()
        addChannelBtn.setTitle(String.them_kenh, for: .normal)
      addChannelBtn.backgroundColor = UIColor.setViewColor()
      addChannelBtn.setTitleColor(UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("0081FF"), color2: UIColor.white), for: .normal)
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
        }
    }

    
    @IBAction func onClickAddChannel(_ sender: UIButton) {
        delegate?.followTableViewCell(self, didTapOnFollow: sender)
    }
}
