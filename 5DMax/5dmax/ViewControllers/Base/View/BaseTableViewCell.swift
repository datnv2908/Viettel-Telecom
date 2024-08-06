//
//  BaseTableViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Nuke

protocol PBaseTableViewCell {
    func bindingWithModel(_ model: PBaseRowModel)
}

class BaseTableViewCell: UITableViewCell, PBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descLabel: UILabel?
    @IBOutlet weak var thumbImageView: UIImageView?
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var imageSearchButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc

        if let url = URL(string: model.imageUrl),
            let thumb = thumbImageView {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
    }
    
    func bindingData(title: String) {
        titleLabel?.text = title
        imageSearchButton.setImage(#imageLiteral(resourceName: "icClockTime1"), for: .normal)
    }
    
    func bindingWithModelObject(_ model: SearchHistoryObject) {
        titleLabel?.text = model.keySearch
    }
}
