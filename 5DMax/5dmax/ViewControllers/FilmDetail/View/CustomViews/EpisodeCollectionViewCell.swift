//
//  EpisodeCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class EpisodeCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var lineView: UIView!

    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        let rowModel = model as! PartRowModel
        if rowModel.isActive {
            titleLabel?.textColor = UIColor.white
        } else {
            titleLabel?.textColor = AppColor.warmGrey()
        }
        lineView.isHidden = !rowModel.isActive
    }
}
