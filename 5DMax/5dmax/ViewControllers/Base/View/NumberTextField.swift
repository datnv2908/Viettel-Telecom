//
//  NumberTextField.swift
//  5dmax
//
//  Created by Hoang on 3/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class NumberTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    private func setUpView() {

    }
}
