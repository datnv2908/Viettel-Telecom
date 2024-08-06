//
//  VideoPlaylistItemTableViewCell.swift
//  MyClip
//
//  Created by hnc on 12/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol VideoPlaylistTableViewCellDelegate: NSObjectProtocol{
    func didClickOnAction(_ cell: VideoPlaylistItemTableViewCell)
}

class VideoPlaylistItemTableViewCell: BaseTableViewCell {

    weak var delegate: VideoPlaylistTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? VideoRowModel {
            if rowModel.isSelected {
                contentView.backgroundColor = UIColor.colorFromHexa("222222")
            } else {
                contentView.backgroundColor = UIColor.colorFromHexa("111111")
            }
        }
    }
    @IBAction func onClickEdit(_ sender: Any) {
        delegate?.didClickOnAction(self)
    }
}
