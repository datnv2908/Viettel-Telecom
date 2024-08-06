//
//  AccountTableViewCell.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    var actionHandle: (() -> (Void))?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font     = AppFont.museoSanFont(style: .light, size: 17.0)
        valueTextField.font = AppFont.museoSanFont(style: .light, size: 17.0)
        button.titleLabel?.font = AppFont.museoSanFont(style: .light, size: 17.0)
        button.tintColor    = AppColor.blue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func buttonPressed(_ sender: Any) {

        if let handle = actionHandle {
            handle()
        }
    }

    func bindData(model: AccountViewModel, isEdit: Bool) {

        titleLabel.text = model.title
        valueTextField.text = model.value
        valueTextField.isEnabled = isEdit
        button.isHidden = true
        valueTextField.isHidden = false
        button.setTitle(model.value, for: .normal)

        switch model.type {
        case .password:
            valueTextField.isHidden = false
            valueTextField.isSecureTextEntry = true
            break
        case .none:
            titleLabel.textColor = AppColor.blue()
            titleLabel.font = AppFont.museoSanFont(style: .light, size: 17.0)
            valueTextField.isHidden = false
            break

        case .button:
            button.isHidden = false
            valueTextField.isHidden = true
            break

        case .buttonLink:
            button.isHidden = false
            valueTextField.isHidden = true
            break

        case .text, .email, .phone:
            break
        }

    }
}
