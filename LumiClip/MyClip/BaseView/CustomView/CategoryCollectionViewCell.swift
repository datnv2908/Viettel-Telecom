//
//  ChannelFollowCollectionViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: BaseCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindingWithModel(_ model: CategoryModel) {
        if let url = URL(string: model.avatarImageHX) {
            thumbImageView?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
        
        thumbImageView?.layer.borderColor = UIColor.colorFromHexa("eeeeee").cgColor
        thumbImageView?.layer.borderWidth = 2.0
        thumbImageView?.contentMode = .scaleAspectFill
        
        titleLabel?.text = model.name
        
//        if(model.isEvent == 1){
//            titleLabel?.textColor = UIColor.colorFromHexa("cd2d4b")
//        }else{
//            titleLabel?.textColor = UIColor.black
//        }
    }
}
