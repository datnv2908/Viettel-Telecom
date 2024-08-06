//
//  MenuTableViewCell.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MenuTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var titiPaddingLeft: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        statusView.layer.masksToBounds = true
        statusView.layer.cornerRadius = statusView.frame.size.height/2
        selectView.backgroundColor = AppColor.hexfded00Color()
    }
    
    func bindingData(_ model: MenuRowModel) {
        statusView.isHidden = true
        titleLabel?.text = model.title.capitalizingFirstLetter()
        descLabel?.text = model.desc
        thumbImageView?.image = model.image
        titiPaddingLeft.constant = model.image == nil ? 18.0 : 40.0
        
        switch model.menuType {
        case .notificationHeader:
            topView.backgroundColor = .black
            break
        case .home:
            topView.backgroundColor = .black
            break
        case .watchLater:
            titleLabel?.textColor = .white
            topView.backgroundColor = .black
            break
        case .charges:
            topView.backgroundColor = .black
            break
        case .package:
            topView.backgroundColor = .clear
            titleLabel?.textColor = AppColor.green()
            break
        default:
            statusView.backgroundColor = .clear
            topView.backgroundColor = .clear
            titleLabel?.textColor = .white
            break
        }
    }
    
    func checkStatus(_ model: [NotificationModel]) {
        if model.count > 0 {
            for i in model {
                if i.isRead == false {
                    statusView.isHidden = false
                    statusView.backgroundColor = .red
                } else {
                    statusView.isHidden = true
                    statusView.backgroundColor = .clear
                }
            }
        } else {
            statusView.isHidden = true
            statusView.backgroundColor = .clear
        }
    }
    
    func setSelectedCell(_ isSelected: Bool) {
        self.selectView.isHidden = !isSelected
        if isSelected {
            self.titleLabel?.font = AppFont.museoSanFont(style: .bold, size: 14.0)
        } else {
            self.titleLabel?.font = AppFont.museoSanFont(style: .regular, size: 14.0)
        }
    }
}

