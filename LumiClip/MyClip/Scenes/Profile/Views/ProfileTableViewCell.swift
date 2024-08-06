//
//  ProfileTableViewCell.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/6/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ProfileTableViewCell: BaseTableViewCell {
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var viewIConBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor.setViewColor()
        viewIConBg.backgroundColor = UIColor.setViewColor()
        seperatorView.backgroundColor = UIColor.setViewColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? ProfileRowModel {
            thumbImageView?.image = rowModel.thumbImage
        }
    }
}
