//
//  FilmNumberSessionCollectionViewCell.swift
//  5dmax
//
//  Created by Macintosh on 8/28/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmPartNumberCollectionViewCell: BaseCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let font1 = AppFont.museoSanFont(style: .regular, size: Constants.isIpad ? 20.0 : 14.0)
        let font2 = AppFont.museoSanFont(style: .regular, size: Constants.isIpad ? 15.0 : 12.0)
        titleLabel?.font = font1
        descLabel?.font = font2
//        contentView.autoresizingMask = .flexibleWidth
//        contentView.translatesAutoresizingMaskIntoConstraints = true
//        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 10 ).isActive = true
    }
    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let size = systemLayoutSizeFitting(layoutAttributes.size)
        let frame = CGRect(origin: layoutAttributes.frame.origin, size: CGSize(width: size.width, height: size.height))
        layoutAttributes.frame = frame
        return layoutAttributes
    }
}
