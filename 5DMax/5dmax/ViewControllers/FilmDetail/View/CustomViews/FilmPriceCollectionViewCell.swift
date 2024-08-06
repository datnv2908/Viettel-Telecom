//
//  FilmPriceCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/18/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FilmPriceCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPrice.layer.cornerRadius = 3
        lblPrice.layer.masksToBounds = true
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        if let rowModel = model as? FilmDetailViewModel.FilmTitleRowModel {
            if rowModel.price.count > 0 {
                lblPrice.text = String.thue_phim.uppercased() + ": \(String.price) \(rowModel.price)"
            } else {
                lblPrice.text = String.thue_phim.uppercased() + ": -"
            }
        }
    }
}
