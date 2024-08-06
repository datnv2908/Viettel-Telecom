
//
//  SearchTableViewCell.swift
//  MyClip
//
//  Created by Os on 8/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol SearchTableViewCellDelegate: NSObjectProtocol {
    func searchTableViewCell(_ cell: SearchTableViewCell, didSelectFillButton sender: UIButton)
}

class SearchTableViewCell: BaseTableViewCell {
    @IBOutlet weak var keywordLabel: UILabel!
    weak var delegate: SearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClickFilterButton(_ sender: Any) {
        delegate?.searchTableViewCell(self, didSelectFillButton: sender as! UIButton)
    }
}
