//
//  ProfileHeaderPersonal.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/6/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ProfileHeaderPersonal: BaseTableHeaderView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var linkAccountButton: UIButton!
    
    @IBOutlet weak var separateView: UIView!
    @IBOutlet weak var coverImageVIew: UIImageView!
    
   @IBOutlet weak var editLb: UILabel!
   weak var delegate: ProfilePushViewProtocol?
    
    @IBAction func performLinkAccount(_ sender: UIButton) {
        delegate?.performLinkAccount()
    }
   override func awakeFromNib() {
      super.awakeFromNib()
      editLb.text = String.user_settings
   }

    @IBAction func performEditMyChannel(_ sender: UIButton) {
        delegate?.performEditMyChannel()
    }
    @IBAction func performOpenMyChannel(_ sender: Any) {
        delegate?.performOpenMyChannel()
    }
}

protocol ProfilePushViewProtocol: NSObjectProtocol {
    func performLinkAccount()
    func performEditMyChannel()
    func performOpenMyChannel()
}
