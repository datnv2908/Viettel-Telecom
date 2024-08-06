//
//  ChannelDetailVideoGroupHeaderView.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelDetailVideoGroupHeaderView: BaseTableHeaderView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lineView: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.backgroundColor = UIColor.setViewColor()
        lineView.backgroundColor = UIColor.setViewColor()
        self.titleLabel?.text = String.moi_nhat
    }

}
