//
//  VolumeSlider.swift
//  5dmax
//
//  Created by Gem on 4/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class VolumeSlider: UISlider {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setThumbImage(UIImage(named: "volumne_slider.png"), for: .normal)
    }

}
