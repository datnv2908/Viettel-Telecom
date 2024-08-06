//
//  UserAwardHeaderView.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/22/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

protocol UserAwardHeaderViewDelegate: NSObjectProtocol {
    func onClickSeeMoreAction(type:String)
}

class UserAwardHeaderView: UIView {
    @IBOutlet weak var lbTitleAward: UILabel!
    @IBOutlet weak var lbTimeAward: UILabel!
    @IBOutlet weak var awardLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var btnSeeMore: UIButton!
    
    static let MONTH = "month"
    static let WEEK = "week"
    var type: String
    weak var delegate: UserAwardHeaderViewDelegate?
    
    override init(frame: CGRect) {
        self.type = UserAwardHeaderView.MONTH
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.type = UserAwardHeaderView.MONTH
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("UserAwardHeaderView",
                                 owner: self,
                                 options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    func bindWithData(type: String, timeAward: String){
        self.type = type
        
        self.phoneLabel.text = String.so_thue_bao
        self.awardLabel.text = String.giai_thuong
        self.btnSeeMore.setTitle(String.xem_them, for: .normal)
        
        if(type == UserAwardHeaderView.MONTH){
            lbTitleAward.text = String.giai_thuong_thang
        }else{
            lbTitleAward.text = String.giai_thuong_tuan
        }
        
        lbTimeAward.text = timeAward
    }
    
    @IBAction func seeMoreAction(_ sender: Any) {
        delegate?.onClickSeeMoreAction(type: type)
    }
    
}
