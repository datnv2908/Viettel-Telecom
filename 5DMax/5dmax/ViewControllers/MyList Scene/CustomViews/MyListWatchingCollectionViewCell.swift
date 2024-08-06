//
//  MyListWatchingCollectionViewCell.swift
//  5dmax
//
//  Created by Gem on 4/11/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MyListWatchingCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var progressView: UIProgressView!

    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        let rowModel = model as! RowModel
        progressView.progress = Float(rowModel.percent/100.0)
    }
}
