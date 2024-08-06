//
//  BaseCollectionViewCell.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Kingfisher

protocol PBaseCollectionViewCell {
    func bindingWithModel(_ model: PBaseRowModel)
}

class BaseCollectionViewCell: UICollectionViewCell, PBaseCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var thumbImageView: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        if let url = URL(string: model.image) {
            thumbImageView?.kf.setImage(with: url)
        }
    }
}
