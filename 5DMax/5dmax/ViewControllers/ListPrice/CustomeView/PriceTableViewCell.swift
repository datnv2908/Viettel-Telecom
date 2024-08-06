//
//  PriceTableViewCell.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PriceTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDesc1: UILabel!
    @IBOutlet weak var lblDesc2: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgCheck: UIImageView!
    @IBOutlet weak var viewDesc1: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor  = AppColor.pinkishGrey().cgColor
        imgCheck.isHidden           = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func billData(model: PackageModel, selectedModel: PackageModel?) {

        lblDesc1.text   = model.name
        lblDesc2.text   = model.desc
        mainView.layer.borderWidth = 2.0
//        imgCheck.isHidden = !model.status

        if let model2 = selectedModel {
            if model.packageId == model2.packageId {
                imgCheck.isHidden = false
                mainView.layer.borderColor  = AppColor.blue().cgColor
            } else {
                imgCheck.isHidden = true
                mainView.layer.borderColor  = AppColor.pinkishGrey().cgColor
            }
        } else {
            imgCheck.isHidden = true
            mainView.layer.borderColor  = AppColor.pinkishGrey().cgColor
        }
        if model.status {
            viewDesc1.backgroundColor = AppColor.pinkishGrey()
            lblDesc1.text = "\(String.goi_cuoc_dang_su_dung.uppercased()): " + model.name
        } else {
            viewDesc1.backgroundColor = UIColor.white
        }
    }

//    class func heightWithPackage(package: PackageModel) -> CGFloat {
//    
//        var height = 100
//        let font = AppFont.fontWithStyle(style: .regular, size: 15.0)
//        package.desc.widthOfString(usingFont: font)
//        return height
//    }
}
