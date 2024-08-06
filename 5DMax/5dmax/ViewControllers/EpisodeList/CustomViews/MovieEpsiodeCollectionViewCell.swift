//
//  MovieEpsiodeCollectionViewCell.swift
//  5dmax
//
//  Created by Gem on 3/29/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Nuke

class MovieEpsiodeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var timeProgress: UIProgressView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeProgress.isHidden = true
    }

    func bindData(_ model: PartModel, _ isActive: Bool) {
        self.movieTitleLabel?.text = model.name
        let currentDuration = String.init(format: "%dm", model.duration/60)
        self.timeLabel?.text = currentDuration
        
        if let url = URL(string: model.coverImage),
            let thumb = coverImage {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
        
        if isActive {
            self.movieTitleLabel.textColor = UIColor.white
        } else {
            self.movieTitleLabel.textColor = AppColor.warmGrey()
        }
    }

    class func sizeOfCell() -> CGSize {
        return CGSize(width: 224, height: 211)
    }
}
