//
//  UploadHeaderView.swift
//  MyClip
//
//  Created by hnc on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class UploadHeaderView: BaseTableHeaderView {

    @IBOutlet weak var containerBg: UIView!
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.containerBg.backgroundColor = UIColor.setViewColor()
    }
}
