//
//  PackofDataCollectionViewCell.swift
//  5dmax
//
//  Created by admin on 8/15/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PackofDataCollectionViewCellDelegate: NSObjectProtocol {
    func didRegisterPrice(cell: PackofDataCollectionViewCell, sender: UIButton)
}

class PackofDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewPackofData: UIView!
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var shortDescriptionLabel: UILabel!
    @IBOutlet weak var priceDataLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    weak var delegate: PackofDataCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.layer.cornerRadius = 15
        nameLabel.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.sizeToFit()
    }
    func bindingWithData(model: PackageModel) {
        nameLabel.text = model.name.uppercased()
//        shortDescriptionLabel.text = String.mien_phi_luu_luong_3G_4G
        descriptionLabel.text = model.desc
        //hortDescriptionLabel.text = model.shortDescription
        priceDataLabel.text = "\(model.fee)" //\(model.cycle.lowercased())"
        if model.status {
//            desLabel.text = String.goi_cuoc_dang_su_dung
            registerButton.setTitle(String.huy.uppercased(), for: .normal)
            registerButton.backgroundColor = .darkGray
            nameLabel.backgroundColor = UIColor.colorFromHexa("ffec04")
            nameLabel.textColor = .black
        } else {
//            desLabel.text = String.goi_cuoc_vip_khong_gioi_han
            registerButton.setTitle(String.dang_ky_sub.uppercased(), for: .normal)
            registerButton.backgroundColor = UIColor.colorFromHexa("ffec04")
            registerButton.titleLabel?.font = AppFont.museoSanFont(style: .bold, size: 15)
            nameLabel.backgroundColor = .darkGray
            nameLabel.textColor = .white
        }
    }
    
    @IBAction func btnRegisterPressed(_ sender: Any) {
        delegate?.didRegisterPrice(cell: self, sender: sender as! UIButton)
    }
}
