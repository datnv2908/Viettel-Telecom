//
//  FilmCoverCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmCoverCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradienHeight = gradientView.frame.size.height
        let frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: gradienHeight)
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        gradientView?.layer.insertSublayer(gradient, at: 0)
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
            setNeedsLayout()
            layoutIfNeeded()
            var frame = layoutAttributes.frame
            frame.size = FilmDetailSectionType.sizeForItem(.cover)()
            layoutAttributes.frame = frame
            
            return layoutAttributes
        }
    @IBAction func onPlay(_ sender: Any) {
    }
}

