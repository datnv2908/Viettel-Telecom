//
//  SetupHeaderView.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol SetupHeaderViewDelegate: class {

    func headerViewDidSelectRegisterService(headerView: SetupHeaderView?)
}

class SetupHeaderView: UIView {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var notRegisterLabel: UILabel!
    @IBOutlet weak var packageView: UIView!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var lblPackageDesc: UILabel!

    weak var delegate: SetupHeaderViewDelegate?

    @IBAction func didSelectRegister(_ sender: Any) {

        delegate?.headerViewDidSelectRegisterService(headerView: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        packageView.isHidden = true
        registerView.isHidden = true
    }

    func billData(user: MemberModel?, package: PackageModel?) {

        notRegisterLabel.text = String.chua_dang_ky
//        notRegisterLabel.text = ""
        
        if let _user = user {
            userLabel.text = _user.getName()
        }

        if package == nil {

            registerView.isHidden = false
            packageView.isHidden = true

        } else {

            registerView.isHidden = true
            packageView.isHidden = false

            var packageDesc = ""
            if let name = package?.name {

                if name.characters.count > 0 {
                    packageDesc = name
                }
            }
//            
//            if let date = package?.expiredStr {
//                
//                if date.characters.count > 0 {
//                    packageDesc +=  " | " + date
//                }
//            }
//            
//            if let data = package?.capacityFree {
//                
//                if data.characters.count > 0 {
//                    packageDesc +=  " | " + data
//                }
//            }

            lblPackageDesc.text = packageDesc
        }
    }
}
