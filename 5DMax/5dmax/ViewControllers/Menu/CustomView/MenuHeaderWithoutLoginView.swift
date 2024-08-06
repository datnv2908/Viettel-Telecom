//
//  MenuHeaderWithoutLoginView.swift
//  5dmax
//
//  Created by Os on 4/5/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MenuHeaderWithoutLoginView: UITableViewHeaderFooterView {
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var loginButton: UIButton!
    var selectHeaderClore: ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.loginButton.layer.cornerRadius = 3
        self.loginButton.setTitle(String.dang_nhap, for: .normal)
    }
    
    @IBAction func clickButtonLogin(_ sender: Any) {
        if let closure = selectHeaderClore {
            closure(sender as! UIButton)
        }
    }
}
