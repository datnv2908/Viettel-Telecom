//
//  MoviePlayerSlider.swift
//  MoviePlayerDemo
//
//  Created by Gem on 3/27/17.
//  Copyright © 2017 Gem. All rights reserved.
//

import UIKit

class MoviePlayerSlider: UISlider {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setThumbImage(UIImage(named: "sliderImg"), for: .normal)
    }
}
