//
//  WaitAprroveCommentCell.swift
//  MeuClip
//
//  Created by mac on 25/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class WaitAprroveCommentCell: BaseTableViewCell,PBaseCommentCell {
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameUserTl: UILabel!
    @IBOutlet weak var commentTl: UILabel!
    @IBOutlet weak var contentMoreSubsCommentHeight: NSLayoutConstraint!
    @IBOutlet weak var moreSubsCommentView: UIView!
    @IBOutlet weak var moreSubCommentBtn: UIButton!
    @IBOutlet weak var lineBelowView: UIView!
    @IBOutlet weak var lineAprove: UIView!
    @IBOutlet weak var dateLb: UILabel!
    @IBOutlet weak var aprovedLabel: UILabel!
    @IBOutlet weak var bgVBtnView: UIView!
    @IBOutlet weak var rejectLabel: UILabel!
    @IBOutlet weak var heightTopLine: NSLayoutConstraint!
    
    var approveComment  : (() -> Void)?
    var rejectComment  : (() -> Void)?
    var moreAction  : (() -> Void)?
    var moreSubComment  : (() -> Void)?
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImg.layer.cornerRadius = self.userImg.frame.size.width / 2
        self.backgroundColor = UIColor.setViewColor()
        self.nameUserTl.textColor = UIColor.settitleColor()
        self.commentTl.textColor = UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("1c1c1e"), color2: .white)
        self.moreSubCommentBtn.backgroundColor =  UIColor.setViewColor()
        self.moreSubsCommentView.backgroundColor =  UIColor.setViewColor()
        bgVBtnView.backgroundColor = UIColor.setViewColor()
        aprovedLabel.text = String.Aprrove
        rejectLabel.text = String.Reject
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        self.lineAprove.isHidden = true
        self.nameUserTl.text = model.title
        if  let url = URL(string: model.image) {
            self.userImg.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        self.commentTl.text = model.desc
        self.moreSubsCommentView.isHidden = true
        self.lineBelowView.isHidden = true
//        self.dateLb.isHidden = true
      
    }
    
    func bindingWithModel(_ model: CommentDisPlay) {
        self.lineAprove.isHidden = true
        self.nameUserTl.text = model.fullName
        self.commentTl.text  = model.comment
        if  let url = URL(string: model.avatarImage) {
            self.userImg.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        dateLb.text = model.createdAtFormat
        if model.childcomment.count >= 1 {
         let title = String(format: String.WatchMore, model.childcomment.count)
            moreSubsCommentView.isHidden = false
            self.moreSubCommentBtn.setTitle(title, for: .normal)
            
        }else{
            moreSubsCommentView.isHidden = true
        }
    }
    
    @IBAction func onAprrove(_ sender: Any) {
        self.approveComment?()
    }
    
    @IBAction func onReject(_ sender: Any) {
        self.rejectComment?()
    }
    
    @IBAction func moreSubCommentAction(_ sender: Any) {
        self.moreSubComment?()
    }
}
