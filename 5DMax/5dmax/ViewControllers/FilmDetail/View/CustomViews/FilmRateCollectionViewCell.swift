//
//  FilmTitleCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/18/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmRateCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var metaLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var ratingView: FloatRatingView!
    var pbaseModel: PBaseRowModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.delegate = self as? FloatRatingViewDelegate
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .floatRatings
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width + 100, height: self.frame.size.height))
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, at: 0)
        self.insertSubview(view, at: 0)
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        descLabel?.sizeToFit()
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        pbaseModel = model
        guard let rowModel = pbaseModel as? FilmDetailViewModel.FilmTitleRowModel else {
            return
        }
        
        if rowModel.rating.isEmpty {
            ratingView.rating = 0.0
        } else {
            ratingView.rating = Double(rowModel.rating)! / 2
        }
        
        metaLabel.text = rowModel.metaData
    }
}

