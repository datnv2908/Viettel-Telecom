//
//  RelateVideoTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class RelateVideoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var postedAtLabel: UILabel!

    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        let rowModel = model as! RelateVideoRowModel
        postedAtLabel.text = rowModel.postedAt
    }
}
