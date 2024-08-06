//
//  TitleHeaderView.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class TitleHeaderView: UIView {

    @IBOutlet weak var lblTitle: UILabel!

    class func initWithDefaultNib() -> TitleHeaderView {

        let view = Bundle.main.loadNibNamed("TitleHeaderView", owner: self, options: nil)?.first as! TitleHeaderView
        return view
    }

}
