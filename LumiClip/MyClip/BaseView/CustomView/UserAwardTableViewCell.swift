//
//  UserAwardTableViewCell.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class UserAwardTableViewCell: UITableViewCell {

    @IBOutlet weak var lbMsisdn: UILabel!
    @IBOutlet weak var lbAwardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindingWithModel(_ model: UserAwardModel) {
        lbMsisdn?.text = model.msisdn
        lbAwardName?.text = model.awardName
    }
    
}
