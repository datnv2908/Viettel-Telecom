//
//  ProfileHeaderLogin.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/6/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ProfileHeaderLogin: BaseTableHeaderView {
    
    @IBOutlet weak var signinLabel: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    var delegate: LoginProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        signInBtn.setTitle(String.dang_nhap, for: .normal)
        signinLabel.text = String.signin_now_to_upload
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        delegate.loginButtonTapped()
    }
}

protocol LoginProtocol {
    func loginButtonTapped()
}
