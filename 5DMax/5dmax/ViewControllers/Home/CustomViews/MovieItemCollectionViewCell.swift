//
//  MovieNormalCollectionViewCell.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MovieItemCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    var leftMargin: CGFloat!
    var rightMargin: CGFloat!
    var numberOfItems : CGFloat!
    var itemSpacing  : CGFloat!
    var additionalSpacing : CGFloat!
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPrice.text = ""
   
    }   
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        var frame = layoutAttributes.frame
        frame.size = FilmDetailSectionType.sizeForItem(.related)()
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? RowModel {
            if rowModel.isShowPrice, let price = rowModel.price {
                lblPrice.text = "\(String.price)\(price)"
            } else {
                lblPrice.text = ""
            }
        } else {
            lblPrice.text = ""
        }
    }
}
