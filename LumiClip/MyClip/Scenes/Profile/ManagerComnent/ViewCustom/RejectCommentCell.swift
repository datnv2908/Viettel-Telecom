//
//  RejectCommentCell.swift
//  MeuClip
//
//  Created by mac on 31/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

 class RejectCommentCell: BaseTableViewCell,PBaseCommentCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameUserTl: UILabel!
    @IBOutlet weak var commentTl: UILabel!
    @IBOutlet weak var approveLb: UILabel!
    @IBOutlet weak var btnContentView: UIView!
    @IBOutlet var lineView: [UIView]!
    @IBOutlet weak var dateLb: UILabel!
    
    //MARK: - Properties
    var onClickApproved: (() -> Void)?
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2;
        btnContentView.backgroundColor = UIColor.setViewColor()
        for item in lineView {
            item.backgroundColor = UIColor.setSeprateViewColor()
        }
      self.selectionStyle = .none
      self.backgroundColor = UIColor.setViewColor()
      approveLb.text = String.Aprrove
      self.nameUserTl.textColor = UIColor.settitleColor()
      self.commentTl.textColor = UIColor.settitleColor()
      self.dateLb.textColor = UIColor.settitleColor()
    }
      
    func bindingWithModel(_ model: CommentDisPlay) {
        self.nameUserTl.text = model.fullName
        self.commentTl.text  = model.comment
        if  let url = URL(string: model.avatarImage) {
            self.userImg.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        dateLb.text = model.createdAtFormat
    }
   override func bindingWithModel(_ model: PBaseRowModel) {
      if let rowModel = model as? CommentInfoRowModel {
       self.nameUserTl.text = model.title
       if  let url = URL(string: model.image) {
           self.userImg.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
       }
       self.commentTl.text = model.desc
       
//       self.dateLb.isHidden = true
         self.dateLb.text = rowModel.postedAt
      for item in lineView {
         item.isHidden = true
      }
      }
   }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func onApproved(_ sender: Any) {
        onClickApproved?()
    }
    
}
