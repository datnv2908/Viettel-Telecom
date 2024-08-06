//
//  NormalHeaderView.swift
//  MyClip
//
//  Created by Os on 9/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class NormalHeaderView: BaseTableHeaderView {
    @IBOutlet weak var contentBg: UIView!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.contentBg.backgroundColor = UIColor.setViewColor()
    }
}
