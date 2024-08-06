//
//  TrailerUpdatingCollectionViewCell.swift
//  5dmax
//
//  Created by Admin on 9/10/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class TrailerUpdatingCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var lblUpdating: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblUpdating?.text = String.dang_cap_nhat
    }
}
