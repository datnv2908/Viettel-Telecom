
//
//  ActionSheetCollectionViewCell.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ActionSheetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
   @IBOutlet weak var ViewBgICon: UIView!
   @IBOutlet weak var seperatorView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
      self.backgroundColor = UIColor.setViewColor()
      self.titleLabel.textColor = UIColor.settitleColor()
      self.iconImageView.backgroundColor = UIColor.setViewColor()
      self.ViewBgICon.backgroundColor = UIColor.setViewColor()
      self.seperatorView.backgroundColor = UIColor.setSeprateViewColor()
    }
}
