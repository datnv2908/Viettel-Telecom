
//
//  CommentInfoTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol CommentInfoTableViewCellDelegate: NSObjectProtocol {
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell,
                                  didClickLike sender: UIButton)
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell,
                                  didClickDisLike sender: UIButton)
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell,
                                  didClickComment sender: UIButton)
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell,
                                  didSelectEdit sender: UIButton)
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell,
                                  onSelectShowSubComment sender: UIButton)
    func commentInfoTableViewCell(_ cell: CommentInfoTableViewCell,
                                 onSelectRejectComment sender: UIButton)
}

class CommentInfoTableViewCell: BaseTableViewCell {
    @IBOutlet weak var postedAtLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var showMoreHeightConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var showSubCommentButton: UIButton!
    @IBOutlet weak var spacingTopConstain: NSLayoutConstraint!
    
    @IBOutlet weak var disLikeBtn: UIButton!
    @IBOutlet weak var spacingLeadingImage: NSLayoutConstraint!
    @IBOutlet weak var spacingBottomConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var moreActionBtn: UIButton!
    weak var delegate: CommentInfoTableViewCellDelegate?
    @IBOutlet weak var widthConstrantCommentView: NSLayoutConstraint!
    var rejectComment  : (() -> Void)?
    @IBOutlet weak var btnReject: UIButton!
   var isManagerComment : Bool = false
   
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? CommentInfoRowModel {
            commentButton.setTitle(rowModel.numberComment, for: .normal)
            likeButton.setTitle(rowModel.numberLike, for: .normal)
           likeButton.setImage(rowModel.isLike ?  UIImage(named: "iconLiked") :UIImage(named: "iconLike"), for: .normal)
           disLikeBtn.setImage(rowModel.isDisLike ? UIImage(named: "iconDisliked") : UIImage(named: "iconDislike"), for: .normal)
           disLikeBtn.setTitle(rowModel.numberDisLike, for: .normal)
           disLikeBtn.setTitle(rowModel.numberDisLike, for: .normal)
            postedAtLabel.text = rowModel.postedAt
            if !rowModel.needShowMore {
                showSubCommentButton.setTitle("", for: .normal)
                spacingTopConstain.constant = 0
                spacingBottomConstaint.constant = 10
                showMoreHeightConstaint.constant = 0
            } else {
                showSubCommentButton.setTitle("\(String.xem.uppercased()) \(rowModel.numberComment) \(String.cau_tra_loi.uppercased())", for: .normal)
                spacingTopConstain.constant = 15
               spacingBottomConstaint.constant = 0
               showMoreHeightConstaint.constant = 30
            }
         if rowModel.isManagerComment {
            btnReject.isHidden = false
         }else{
            btnReject.isHidden = true
         }
         if rowModel.isSubComment {
            commentButton.isHidden = true
                widthConstrantCommentView.constant = 0
               spacingLeadingImage.constant = 20
            } else {
                commentButton.isHidden = false
                widthConstrantCommentView.constant = 60
            }
        }
        self.contentView.backgroundColor = UIColor.setViewColor()
    }
    
    @IBAction func onClickEditButton(_ sender: Any) {
        delegate?.commentInfoTableViewCell(self, didSelectEdit: sender as! UIButton)
    }
    
    @IBAction func onClickLikeButton(_ sender: Any) {
        delegate?.commentInfoTableViewCell(self, didClickLike: sender as! UIButton)
    }
    
    @IBAction func onClickCommentButton(_ sender: Any) {
        delegate?.commentInfoTableViewCell(self, didClickComment: sender as! UIButton)
    }
    
    @IBAction func onSelectShowSubComment(_ sender: Any) {
        delegate?.commentInfoTableViewCell(self, onSelectShowSubComment: sender as! UIButton)
    }
    
    @IBAction func onDislike(_ sender: Any) {
        delegate?.commentInfoTableViewCell(self, didClickDisLike: sender as! UIButton)
    }
    @IBAction func rejectAction(_ sender: Any) {
      self.rejectComment?()
    }
}
