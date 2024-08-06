
//
//  LoadMoreTableViewCell.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 10/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol LoadMoreTableViewCellDelegate: NSObjectProtocol {
    func loadMoreTableViewCell(_ cell: LoadMoreTableViewCell, didSelectLoadMore sender: UIButton)
}

class LoadMoreTableViewCell: BaseTableViewCell {
    weak var delegate: LoadMoreTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onClickLoadmoreButton(_ sender: Any) {
        delegate?.loadMoreTableViewCell(self, didSelectLoadMore: sender as! UIButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
