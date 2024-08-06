//
//  ReplyCommentTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ReplyCommentTableViewCell: BaseTableViewCell {

    @IBOutlet weak var postedAtLabel: UILabel!

    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var commentButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onClickLikeButton(_ sender: Any) {
    }
}
