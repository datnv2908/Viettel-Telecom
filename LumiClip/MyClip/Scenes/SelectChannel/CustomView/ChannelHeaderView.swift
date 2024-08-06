//
//  ChannelHeaderView.swift
//  MyClip
//
//  Created by Os on 8/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelHeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    func bindingWithModel(_ title: String) {
        titleLabel.text = title
    }
}
