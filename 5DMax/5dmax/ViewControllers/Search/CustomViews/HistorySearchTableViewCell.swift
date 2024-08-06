//
//  HistorySearchTableViewCell.swift
//  5dmax
//
//  Created by admin on 10/2/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

protocol HistorySearchTableViewCellDelegate: NSObjectProtocol {
    func didSelectRow(cell: HistorySearchTableViewCell, sender: Any)
    func didDeleteRow(cell: HistorySearchTableViewCell, sender: Any)
}

class HistorySearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    weak var delegate: HistorySearchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func onGetSuggestionPressed(_ sender: Any) {
        delegate?.didSelectRow(cell: self, sender: sender)
    }
    
    @IBAction func onDeleteSuggestionPressed(_ sender: Any) {
        delegate?.didDeleteRow(cell: self, sender: sender)
    }
    
    func bindingWithModelObject(_ model: SearchHistoryObject) {
        titleLabel?.text = model.keySearch
        
    }
}
