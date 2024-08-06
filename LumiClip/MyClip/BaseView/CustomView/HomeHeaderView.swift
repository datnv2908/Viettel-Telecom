//
//  HomeHeaderView.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/22/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {
    @IBOutlet weak var labelHot: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var touchArea: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("HomeHeaderView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        labelHot.layer.masksToBounds = true
        labelHot.layer.cornerRadius = 4
        labelHot.textAlignment = NSTextAlignment.center;
    }
}
