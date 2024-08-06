//
//  MyListWatchingTableViewCell.swift
//  5dmax
//
//  Created by Os on 4/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import Nuke

class MyListWatchingTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!

    var deleteClosure: ((Any) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnRemove(_ sender: Any) {
        if let closure = deleteClosure {
            closure(sender)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func bindingWithModel(_ model: PBaseRowModel, isEditing: Bool) {
        let rowModel = model as! RowModel
        progressView.progress = Float(rowModel.percent/100.0)
        lblName.text = rowModel.title
        lblTime.text = rowModel.duration
        
        if let url = URL(string: model.imageUrl),
            let thumb = img {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
        
        btnRemove.isHidden = !isEditing
    }
}
