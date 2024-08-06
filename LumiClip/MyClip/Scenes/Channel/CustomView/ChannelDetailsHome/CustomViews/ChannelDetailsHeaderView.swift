//
//  ChannelDetailsHeaderView.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol ChannelDetailsHeaderViewDelegate: NSObjectProtocol {
    func channelDetailsHeaderView(_ view: ChannelDetailsHeaderView, toggleFollow sender: UIButton)
    func channelDetailsHeaderView(_ view: ChannelDetailsHeaderView, toggleBell sender: UIButton)
    func channelDetailsHeaderView(_ view: ChannelDetailsHeaderView, toggleEdit sender: UIButton)
}

class ChannelDetailsHeaderView: BaseTableHeaderView {
    weak var delegate: ChannelDetailsHeaderViewDelegate?
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var viewFollow: UIView!
    
   @IBOutlet weak var followBgView: UIView!
   @IBOutlet weak var bellButton: UIButton!
    @IBOutlet weak var followCountLabel: UILabel!
   @IBOutlet weak var bgView: UIView!
   @IBOutlet weak var followLabel: UILabel!
    @IBOutlet weak var editChannelView: UIView!
    @IBOutlet weak var officalImg: UIImageView!
   @IBOutlet weak var flowBtnBg: UIView!
   @IBOutlet weak var officalWidthConstrant: NSLayoutConstraint!
    var isMyChannel : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if isMyChannel {
//            followLabel?.text = String.chinh_sua
//            unFollowButton.setTitle(String.chinh_sua, for: .normal)
//
//        }else{
//            followLabel?.text = String.theo_doi
//            unFollowButton.setTitle(String.unFollow, for: .normal)
//        }
        //        self.editChannelView.isHidden = !isMyChannel
      self.bgView.backgroundColor = UIColor.setViewColor()
      self.viewFollow.backgroundColor = UIColor.setViewColor()
      self.flowBtnBg.backgroundColor = UIColor.setViewColor()
      self.followBgView.backgroundColor = UIColor.setViewColor()
    }
    func getData(myChannel : Bool, viewModel : ChannelDetailsModel){
//        if viewModel.isOfficial {
//            self.officalImg.image = UIImage(named: "officalIcon")
//            self.officalWidthConstrant.constant = 30
//        }else{
//            self.officalImg.image = nil
//            self.officalWidthConstrant.constant = 0
//        }
       
        isMyChannel = myChannel
        if myChannel {
            followLabel?.text = String.chinh_sua
            unFollowButton.setTitle(String.chinh_sua, for: .normal)
         followLabel.textColor = .blue
        }else{
            followLabel?.text = String.theo_doi
            unFollowButton.setTitle(String.unFollow, for: .normal)
        }
    }
    override func bindingWithModel(_ model: PBaseHeaderModel, section index: Int) {
        if let headerModel = model as? ChannelDetailHeaderModel {
            if let url = URL(string: headerModel.avatarImage) {
                avatarImageView.kf.setImage(with: url,
                                            placeholder: #imageLiteral(resourceName: "iconUserLarge"),
                                            options: nil,
                                            progressBlock: nil,
                                            completionHandler: nil)
            }
            if let url = URL(string: headerModel.coverImage) {
                coverImageView.kf.setImage(with: url,
                                           placeholder: #imageLiteral(resourceName: "bitmap"),
                                           options: nil,
                                           progressBlock: nil,
                                           completionHandler: nil)
            }
            titleLabel?.text = headerModel.title
            followCountLabel.text = "\(headerModel.followCount) \(String.luot_theo_doi.lowercased())"
            if(headerModel.isFollow){
               if isMyChannel {
                  
               }else{
                  unFollowButton.isHidden = false
                  viewFollow.isHidden = true
               }
            }else{
               if isMyChannel {
                  
               }else{
                  unFollowButton.isHidden = true
                  viewFollow.isHidden = true
               }
            }
            bellButton.isSelected = !headerModel.isReceiveNotitication
           
        }
    }
    
    @IBAction func onToggleFollow(_ sender: UIButton) {
        if isMyChannel {
        delegate?.channelDetailsHeaderView(self, toggleEdit: sender)
        }else{
        delegate?.channelDetailsHeaderView(self, toggleFollow: sender)
        }
    }
    
    @IBAction func onToggleBell(_ sender: UIButton) {
        delegate?.channelDetailsHeaderView(self, toggleBell: sender)
    }
}
