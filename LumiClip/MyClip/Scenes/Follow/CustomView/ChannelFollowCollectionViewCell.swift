//
//  ChannelFollowCollectionViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelFollowCollectionViewCell: BaseCollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        if let url = URL(string: model.image) {
            thumbImageView?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
    }
    func bindingWithModel(_ model: PBaseRowModel,_ isEmpty: Bool) {
        if(isEmpty){
            thumbImageView?.kf.setImage(with: nil,
                                        placeholder: #imageLiteral(resourceName: "iconPlusBlue"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
            thumbImageView?.layer.borderColor = UIColor.colorFromHexa("eeeeee").cgColor
            thumbImageView?.layer.borderWidth = 2.0
            thumbImageView?.contentMode = .center
        }else{
            if let url = URL(string: model.image) {
                thumbImageView?.kf.setImage(with: url,
                                            placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                            options: nil,
                                            progressBlock: nil,
                                            completionHandler: nil)
            }
            thumbImageView?.layer.borderColor = UIColor.clear.cgColor
            thumbImageView?.layer.borderWidth = 0.0
            thumbImageView?.contentMode = .scaleAspectFill
        }
    }
}
