//
//  NotifiCommentTableViewCell.swift
//  MeuClip
//
//  Created by Tú on 15/11/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class NotifiCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var imgVideo: UIImageView!
    @IBOutlet weak var dateLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
   func bindingWithModel(_ model: CommentModelDisplay) {
      titleLb?.text = model.name
      dateLb.text = model.published_time
      if  let url = URL(string: model.coverImage) {
         self.imgVideo.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder_video"), options: nil, progressBlock: nil, completionHandler: nil)
      }else{
         self.imgVideo.image = UIImage(named: "placeholder_video")
      }
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
