//
//  CommentTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol CommentTableViewCellDelegate: NSObjectProtocol {
    func commentTableViewCell(_ cell: CommentTableViewCell,
                              didClickComment sender: UIButton)
}
class CommentTableViewCell: BaseTableViewCell {
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var writeCommentLabel: UILabel!
   @IBOutlet weak var CommentBtn: UIButton!
    @IBOutlet weak var bottomLineView: UIView!
    weak var delegate: CommentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commentLabel.text = String.binh_luan
        writeCommentLabel.text = String.viet_binh_luan
//         CommentBtn.isUserInteractionEnabled = false
      topLineView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
      bottomLineView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
      
    }
    
    func setImageAvatar() {
        if let memberModel = DataManager.getCurrentMemberModel() {
            thumbImageView?.kf.setImage(with: URL(string: memberModel.avatarImage), placeholder: #imageLiteral(resourceName: "iconUserCopy"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    @IBAction func onClickCommentButton(_ sender: Any) {
        delegate?.commentTableViewCell(self, didClickComment: sender as! UIButton)
    }
}
