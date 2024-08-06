//
//  ApprovedSubCommentCell.swift
//  MeuClip
//
//  Created by Toannx on 18/12/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class ApprovedSubCommentCell: BaseTableViewCell {

   @IBOutlet weak var postedAtLabel: UILabel!
   @IBOutlet weak var commentButton: UIButton!
   @IBOutlet weak var likeButton: UIButton!
   @IBOutlet weak var disLikeBtn: UIButton!
   @IBOutlet weak var spacingLeadingImage: NSLayoutConstraint!
   @IBOutlet weak var btnReject: UIButton!
   @IBOutlet weak var widthConstrantCommentView: NSLayoutConstraint!
   var isManagerComment : Bool = false
   var rejectComment  : (() -> Void)?
   var likeComment  : (() -> Void)?
   var disLikeComment  : (() -> Void)?
    var clickComment  : (() -> Void)?
  
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
         postedAtLabel.textColor = UIColor.settitleColor()
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
   
   
   @IBAction func onClickLikeButton(_ sender: Any) {
    self.likeComment?()
   }
   
   @IBAction func onClickCommentButton(_ sender: Any) {
    self.clickComment?()
   }
   
   
   @IBAction func onDislike(_ sender: Any) {
    self.disLikeComment?()
   }
   @IBAction func rejectAction(_ sender: Any) {
     self.rejectComment?()
   }
    
}
