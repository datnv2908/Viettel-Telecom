//
//  TrailerCollectionViewCell.swift
//  5dmax
//
//  Created by admin on 8/22/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Nuke
import UIKit

protocol TrailerCollectionViewCellDelegate: NSObjectProtocol {
    func didSelectPlayTrailer(cell: TrailerCollectionViewCell, sender: Any)
}
class TrailerCollectionViewCell: BaseCollectionViewCell {
    
    weak var delegate: TrailerCollectionViewCellDelegate?
    @IBOutlet weak var playtrailerButton: UIButton!
    @IBOutlet weak var lblTitle: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    @IBAction func didPlayTrailerPressed(_ sender: Any) {
        delegate?.didSelectPlayTrailer(cell: self, sender: sender)
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        lblTitle?.text = model.title
        DLog("trailer: \(model.title)")
        
        if let url = URL(string: model.imageUrl),
            let thumb = thumbImageView {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
    }
}
