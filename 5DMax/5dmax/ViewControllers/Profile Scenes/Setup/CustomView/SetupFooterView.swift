//
//  SetupFooterView.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SetupFooterView: UIView {

    var selectLogoutClosure: ((UIButton?) -> Void)?

    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.logoutBtn.setTitle(String.dang_xuat, for: .normal)
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        self.appVersionLabel.text = "App Version \(version) (Build \(buildVersion))"
    }
    
    @IBAction func onLogout(_ sender: UIButton) {
        if let closure = selectLogoutClosure {
            closure(sender)
        }
    }

}
