//
//  BaseCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Nuke

protocol PBaseCollectionViewCell {
    func bindingWithModel(_ model: PBaseRowModel)
}

class BaseCollectionViewCell: UICollectionViewCell, PBaseCollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var thumbImageView: UIImageView?
    @IBOutlet weak var descFilm: UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView?.contentMode = .scaleToFill
        thumbImageView?.backgroundColor = UIColor.colorFromHexa("282828")
        contentView.autoresizingMask = .flexibleWidth
        contentView.translatesAutoresizingMaskIntoConstraints = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        descFilm?.text = model.descFilm
        if let url = URL(string: model.imageUrl),
            let thumb = thumbImageView {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
    }
}
