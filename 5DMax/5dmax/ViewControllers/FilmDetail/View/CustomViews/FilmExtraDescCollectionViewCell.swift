//
//  FilmTitleCollectionViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/18/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit


class FilmExtraDescCollectionViewCell: BaseCollectionViewCell {
    
    var pbaseModel: PBaseRowModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        pbaseModel = model 
        guard let rowModel = pbaseModel as? FilmDetailViewModel.FilmTitleRowModel else {
            descLabel?.text = ""
            self.backgroundColor = UIColor.clear
            return
        }
        
        descLabel?.text = rowModel.extraDesc
        if rowModel.extraDesc.isEmpty {
            self.backgroundColor = UIColor.clear
        }
        
    }
}

