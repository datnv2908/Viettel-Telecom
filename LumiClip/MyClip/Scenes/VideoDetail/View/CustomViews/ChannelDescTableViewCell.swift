//
//  ChannelDescTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChannelDescTableViewCell: BaseTableViewCell {

    @IBOutlet weak var channelTitle: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.backgroundColor = UIColor.setViewColor()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        channelTitle.text = model.title
        descTextView.text = model.desc
    }
    
}
