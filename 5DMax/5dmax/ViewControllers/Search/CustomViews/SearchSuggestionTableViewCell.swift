//
//  SearchSuggestionTableViewCell.swift
//  5dmax
//
//  Created by admin on 9/14/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

protocol SearchSuggestionTableViewCellDelegate: NSObjectProtocol {
    func didSelectSearchRow(cell: SearchSuggestionTableViewCell, sender: Any)
}
class SearchSuggestionTableViewCell: BaseTableViewCell {
    
    weak var delegate: SearchSuggestionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onGetSuggestionText(_ sender: Any) {
        delegate?.didSelectSearchRow(cell: self, sender: sender)
    }
}
