//
//  ServicePackageTableViewCell.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ServicePackageTableViewCell: BaseTableViewCell {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pakageTitle: UILabel!
    @IBOutlet weak var pakageDetail: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var delegate: ServicePackageProtocol!
    var rowModel: ServicePackageRowModel?
    @IBOutlet weak var statusView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.text = String.da_dang_ky
        registerButton.setTitle(String.daang_ky, for: .normal)
        cancelButton.setTitle(String.unregisterPackage, for: .normal)
      statusView.backgroundColor = UIColor.setViewColor()
      self.contentView.backgroundColor = UIColor.setViewColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        if let rowModel = model as? ServicePackageRowModel {
            self.rowModel = rowModel
            if rowModel.status == true {
                registerButton.isHidden = true
                cancelButton.isHidden = false
                statusView.isHidden = false
            } else {
                statusView.isHidden = true
                cancelButton.isHidden = true
                registerButton.isHidden = false
            }
        }
    }
    
    @IBAction func onRegisterButton(_ sender: UIButton) {
        delegate.registerButtonTapped(rowModel: rowModel)
    }
    
    @IBAction func onCancelButton(_ sender: UIButton) {
        delegate.unregisterButtonTapped(rowModel: rowModel)
    }
}

protocol ServicePackageProtocol {
    func registerButtonTapped(rowModel: ServicePackageRowModel?)
    func unregisterButtonTapped(rowModel: ServicePackageRowModel?)
}
