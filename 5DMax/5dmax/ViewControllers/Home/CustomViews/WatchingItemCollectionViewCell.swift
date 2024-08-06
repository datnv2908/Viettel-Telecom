//
//  MovieIsWatchingCollectionViewCell.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class WatchingItemCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var progressSlider: UIProgressView!
    var playClosure: ((Any) -> Void)?
    var viewInfoClosure: ((Any) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onPlay(_ sender: Any) {
        if let closure = playClosure {
            closure(sender)
        }
    }

    @IBAction func onViewInfo(_ sender: Any) {
        if let closure = viewInfoClosure {
            closure(sender)
        }
    }

    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        let rowModel = model as! RowModel
        progressSlider.progress = Float(rowModel.percent/100.0)
    }
}
