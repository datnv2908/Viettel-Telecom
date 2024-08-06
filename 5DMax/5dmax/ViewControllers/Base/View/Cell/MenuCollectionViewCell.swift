//
//  MenuCollectionViewCell.swift
//  5dmax
//
//  Created by Hoang on 3/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.font = AppFont.museoSanFont(style: .semibold, size: 12.0)
    }

}
