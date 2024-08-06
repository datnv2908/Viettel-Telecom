//
//  SetupFacebookTableViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SetupFacebookTableViewCell: UITableViewCell {

    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func bindingData() {
        
        facebookLabel.text = String.facebook
        
        if let model = DataManager.getCurrentMemberModel() {
            if model.msisdn.isEmpty {
                linkLabel.text = String.chua_lien_ket
                linkLabel.textColor = AppColor.warmGrey()
            } else {
                linkLabel.text = model.msisdn
                linkLabel.textColor = AppColor.darkSkyBlue()
            }
        }
    }
}
