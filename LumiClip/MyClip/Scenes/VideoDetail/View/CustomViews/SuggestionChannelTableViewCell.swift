//
//  FollowTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol SuggestionChannelTableViewCellDelegate: NSObjectProtocol {
    func suggestionTableViewCell(_ cell: SuggestionChannelTableViewCell, didTapOnFollow sender: UIButton)
}

class SuggestionChannelTableViewCell: UICollectionViewCell {
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var numberFollowLabel: UILabel!
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var viewFollow: UIView!
    @IBOutlet var contentBg: [UIView]!
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var followLabel: UILabel?
    @IBOutlet weak var thumbImageView: UIImageView?
    @IBOutlet weak var followBtn: UIButton!
    var delegate: SuggestionChannelTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followLabel?.text = String.theo_doi_btn
        unFollowButton.setTitle(String.unFollow, for: .normal)
        followBtn.backgroundColor = UIColor.clear
        followLabel?.textColor = UIColor.settitleColor()
    }
    
    func bindingWithModel(_ model: ChannelModel) {
        titleLabel?.text = model.name
        if let url = URL(string: model.avatarImage) {
            thumbImageView?.kf.setImage(with: url,
                                        placeholder: #imageLiteral(resourceName: "iconUserCopy"),
                                        options: nil,
                                        progressBlock: nil,
                                        completionHandler: nil)
        }
        viewFollow.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2:  UIColor.colorFromHexa("1c1c1e"))
        numberFollowLabel.text = String("\(model.num_follow) \(String.theo_doi.lowercased())")
        if(model.isFollow){
            unFollowButton.isHidden = false
            viewFollow.isHidden = true
        }else{
            unFollowButton.isHidden = true
            viewFollow.isHidden = false
        }
        numberFollowLabel.textColor = UIColor.settitleColor()
        for item in contentBg {
            item.backgroundColor = UIColor.setViewColor()
        }
        
        if let url = URL(string: model.coverImage) {
            imgCover.kf.setImage(with: url,
                                       placeholder: #imageLiteral(resourceName: "bitmap"),
                                       options: nil,
                                       progressBlock: nil,
                                       completionHandler: nil)
        }
    }
    

    @IBAction func onClickFollowButton(_ sender: UIButton) {
        delegate?.suggestionTableViewCell(self, didTapOnFollow: sender)
      
    }
}
