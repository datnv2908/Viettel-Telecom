//
//  headerUserChannelView.swift
//  UClip
//
//  Created by Toan on 5/19/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

protocol headerUserDelegate {
    func onCrateChannel()
}
class headerUserChannelView: BaseTableHeaderView {


    @IBOutlet weak var userBannerImg: UIImageView!
    @IBOutlet weak var avatarUserImg: UIImageView!
    @IBOutlet weak var nameUserlb: UILabel!
    @IBOutlet weak var btnAddChannel: UIButton!
    @IBOutlet weak var userFollowerlb: UILabel!
    @IBOutlet weak var followTl: UILabel!
   @IBOutlet weak var BgView: UIView!
   
   @IBOutlet weak var contentBgView: UIView!
   var delegate : headerUserDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarUserImg.image = #imageLiteral(resourceName: "iconUserLarge")
        followTl.text = String.them_kenh
      self.backgroundColor = UIColor.setViewColor()
      self.contentBgView.backgroundColor =  UIColor.setViewColor()
      self.BgView.backgroundColor =  UIColor.setViewColor()
    }
     
    func blindingData (userInfo : ChannelDetailsModel ){
        if let url = URL(string: userInfo.coverImage) {
            self.userBannerImg?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserLarge"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
        if let url = URL(string: userInfo.avatarImage) {
            self.avatarUserImg?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserLarge"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
        self.nameUserlb?.text = DataManager.getCurrentMemberModel()?.msisdn
        self.userFollowerlb?.text = String.init(format: "%@ %@", String(userInfo.numFollow),String.luot_theo_doi)
        
    
    }
    @IBAction func onCreatChannel(_ sender: Any) {
        delegate?.onCrateChannel()
    }
    
    
}
