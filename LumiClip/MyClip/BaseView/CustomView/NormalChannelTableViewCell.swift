
//
//  NormalChannelTableViewCell.swift
//  MyClip
//
//  Created by Os on 9/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class NormalChannelTableViewCell: BaseTableViewCell {
    @IBOutlet weak var numberRegisterLabel: UILabel!
    @IBOutlet weak var numberVideos: UILabel!
    
    /////for search v2/////
    @IBOutlet weak var viewImg: UIView!
    @IBOutlet weak var trailingImgView: NSLayoutConstraint!
    @IBOutlet weak var widthImgView: NSLayoutConstraint!
    @IBOutlet weak var heightImgView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        trailingImgView.constant = 10
        widthImgView.constant = (self.bounds.size.width-51)/2
        heightImgView.constant = ((self.bounds.size.width-51)/2)*9/16
    }

    override func bindingWithModel(_ model: PBaseRowModel) {
        titleLabel?.text = model.title
        descLabel?.text = model.desc
        self.backgroundColor = UIColor.setViewColor()
        if let image = UIImage(named: model.image) {
            thumbImageView?.image = image
        } else {
            if let url = URL(string: model.image) {
                thumbImageView?.kf.setImage(with: url,
                                            placeholder: #imageLiteral(resourceName: "iconUserLarge"),
                                            options: nil,
                                            progressBlock: nil,
                                            completionHandler: nil)
            }
        }
        if let rowModel = model as? ChannelRowModel {
            numberRegisterLabel.text = "\(rowModel.numberRegister) \(String.nguoi_dang_ky.lowercased())"
        }
        
        /////for search v2/////
        if let rowModel = model as? RowModel {
            cellForSearchView(rowModel: rowModel)
        }else {
            trailingImgView.constant = 20
            heightImgView.constant = 54
            widthImgView.constant = 54
        }
    }
    
    func cellForSearchView(rowModel:RowModel) {
        self.layoutSubviews()
        if rowModel.isShowAllData {
            numberRegisterLabel.text = "\(String(describing: Int(rowModel.num_follow) ?? 0)) \(String.theo_doi.lowercased())"
            numberVideos.text = Int(rowModel.num_video) ?? 0 > 1 ? " • \(String(describing: Int(rowModel.num_video) ?? 0)) \(String.videos.lowercased())" : " • \(String(describing: Int(rowModel.num_video) ?? 0)) \(String.video.lowercased())"
        }else {
            numberRegisterLabel.text = ""
            numberVideos.text = ""
        }
    }
}
