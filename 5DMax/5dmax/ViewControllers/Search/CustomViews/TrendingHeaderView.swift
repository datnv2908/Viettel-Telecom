//
//  TrendingHeaderView.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class TrendingHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var lblTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.text = String.xu_huong
    }
}
