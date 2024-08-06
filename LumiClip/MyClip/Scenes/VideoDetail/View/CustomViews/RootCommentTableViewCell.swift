//
//  RootCommentTableViewCell.swift
//  MyClip
//
//  Created by hnc on 11/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
protocol RootCommentTableViewCellDelegate: NSObjectProtocol {
    func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectShowComment sender: UIButton)
    func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectLikeButton sender: UIButton)
    func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectCommentButton sender: UIButton)
   func rootCommentTableViewCell(_ cell: RootCommentTableViewCell, didSelectDisLikeButton sender: UIButton)
}

class RootCommentTableViewCell: BaseTableViewCell {
    @IBOutlet weak var addCommentLabel: UILabel!
    @IBOutlet weak var postedAtLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
   @IBOutlet weak var btnComment: UIButton!
   @IBOutlet weak var widthOfDislikeBtn: NSLayoutConstraint!
    @IBOutlet var backgroundInforView: [UIView]!
    @IBOutlet weak var disLikeBtn: UIButton!
    
    weak var delegate: RootCommentTableViewCellDelegate?
    
   override func awakeFromNib() {
      super.awakeFromNib()
      contentView.backgroundColor = UIColor.setViewColor()
    for item in backgroundInforView {
        item.backgroundColor = UIColor.setViewColor()
    }
   }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? CommentInfoRowModel {
            commentButton.setTitle(rowModel.numberComment, for: .normal)
            likeButton.setTitle(rowModel.numberLike, for: .normal)
            likeButton.isSelected = rowModel.isLike
            postedAtLabel.text = rowModel.postedAt
         postedAtLabel.textColor = UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("1c1c1e"), color2: .white)
            addCommentLabel.text = String.them_cau_tra_loi
           disLikeBtn.setTitle(rowModel.numberDisLike, for: .normal)
           disLikeBtn.setImage(rowModel.isDisLike ? UIImage(named: "iconDisliked") : UIImage(named: "iconDislike"), for: .normal)
            if let model = DataManager.getCurrentMemberModel() {
                avatarImageView.kf.setImage(with: URL(string: model.avatarImage), placeholder: #imageLiteral(resourceName: "iconUserCopy"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
    }
   func blindingModel (model : CommentDisPlay){
      commentButton.setTitle("", for: .normal)
      likeButton.setTitle(model.likeCount, for: .normal)
      likeButton.isSelected = model.isLike
      postedAtLabel.text = model.createdAt
      addCommentLabel.text = String.them_cau_tra_loi
      if let model = DataManager.getCurrentMemberModel() {
          avatarImageView.kf.setImage(with: URL(string: model.avatarImage), placeholder: #imageLiteral(resourceName: "iconUserCopy"), options: nil, progressBlock: nil, completionHandler: nil)
      }
   }
    @IBAction func onSelectShowComment(_ sender: UIButton) {
        delegate?.rootCommentTableViewCell(self, didSelectShowComment: sender)
    }
    
    @IBAction func onClickLikeButton(_ sender: UIButton) {
        delegate?.rootCommentTableViewCell(self, didSelectLikeButton: sender)
    }
    
    @IBAction func onClickCommentButton(_ sender: UIButton) {
        delegate?.rootCommentTableViewCell(self, didSelectCommentButton: sender)
    }
   
    @IBAction func onClickDisLikeBtn(_ sender: UIButton) {
       delegate?.rootCommentTableViewCell(self, didSelectDisLikeButton: sender)
    }
    
}
