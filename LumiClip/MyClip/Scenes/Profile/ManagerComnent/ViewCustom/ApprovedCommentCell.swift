//
//  CommentCell.swift
//  MeuClip
//
//  Created by mac on 22/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PBaseCommentCell {
   func bindingWithModel(_ model: CommentDisPlay)
}
class ApprovedCommentCell: UITableViewCell,PBaseCommentCell {
   
   @IBOutlet weak var userImg: UIImageView!
   @IBOutlet weak var nameUserTl: UILabel!
   @IBOutlet weak var commentTl: UILabel!
   @IBOutlet weak var likeBtn: UIButton!
   @IBOutlet weak var dislikeBtn: UIButton!
   @IBOutlet weak var commentBtn: UIButton!
   @IBOutlet weak var numberComment: UILabel!
   @IBOutlet weak var numberDisLike: UILabel!
   @IBOutlet weak var numberLike: UILabel!
   @IBOutlet weak var showMoreCommentBtn: UIButton!
   @IBOutlet weak var contentBg: UIView!
   @IBOutlet weak var heightBtnMoreComment: NSLayoutConstraint!
    @IBOutlet weak var dateLb: UILabel!
    
   @IBOutlet var btnBacground: [UIView]!
   
   var onLikeActionIndex : (() -> Void)?
   var dissLikeActionIndex  : ((UITableViewCell) -> Void)?
   var commentActionIndex  : ((ApprovedCommentCell) -> Void)?
   var moreActionIndex  : ((UITableViewCell) -> Void)?
   var moreCommentActionIndex  : ((UITableViewCell) -> Void)?
   var rejectComment : (()->Void)?
   var CommentModel : CommentDisPlay?
   
   override func awakeFromNib() {
      super.awakeFromNib()
      self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2;
      for item in btnBacground {
         item.backgroundColor = UIColor.setViewColor()
      }
      dateLb .textColor = UIColor.settitleColor()
      commentTl.textColor = UIColor.settitleColor()
      nameUserTl.textColor = UIColor.settitleColor()
      numberComment.textColor = UIColor.settitleColor()
      numberDisLike.textColor = UIColor.settitleColor()
      numberLike.textColor = UIColor.settitleColor()
      
   }
   
   
   func bindingWithModel(_ model: CommentDisPlay) {
      contentBg.backgroundColor = UIColor.setViewColor()
      contentView.backgroundColor = UIColor.setViewColor()
      self.CommentModel = model
      self.nameUserTl.text = model.fullName
      self.commentTl.text  = model.comment
      if  let url = URL(string: model.avatarImage) {
         self.userImg.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
      }
    dateLb.text =  model.createdAtFormat
      if model.childcomment.count > 0 {
         let title = "\(String.WatchMore) \(model.childcomment.count) \(String.More)"
         self.showMoreCommentBtn.setTitle(title, for: .normal)
         self.heightBtnMoreComment.constant = 45
      }else{
         self.heightBtnMoreComment.constant = 0
         let title = ""
         self.showMoreCommentBtn.setTitle(title, for: .normal)
      }
         likeBtn.isSelected = model.isLike
         numberLike.text = model.likeCount
      let image = model.isDisLike ? UIImage(named: "iconDisliked") :UIImage(named: "iconDislike")
      dislikeBtn.setImage(image, for: .normal)
      numberDisLike.text = model.disLikeCount
      self.numberComment.text = "\(model.childcomment.count)"
   }
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      
   }
   @IBAction func showMoreComment(_ sender: Any) {
      self.moreCommentActionIndex?(self)
   }
   
   @IBAction func onLikeAction(_ sender: Any) {
      self.onLikeActionIndex?()
   }
   
   @IBAction func onDislikeAction(_ sender: Any) {
      self.dissLikeActionIndex?(self)
   }
   
   @IBAction func commentAction(_ sender: Any) {
      self.commentActionIndex?(self)
   }
   
   @IBAction func onMoreAction(_ sender: Any) {
      self.moreActionIndex?(self)
   }
    @IBAction func onRejectComment(_ sender: Any) {
       self.rejectComment?()
    }
}
