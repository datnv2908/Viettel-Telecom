//
//  EarningHistoryTableViewCell.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/29/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class EarningHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var lbMsisdn: UILabel!
    @IBOutlet weak var lbPoint: UILabel!
    @IBOutlet weak var lbAwardName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      lbMsisdn.textColor = UIColor.settitleColor()
      lbPoint.textColor = UIColor.settitleColor()
      lbAwardName.textColor = UIColor.settitleColor()
      contentView.backgroundColor = UIColor.setViewColor()
      
        // Configure the view for the selected state
    }
    
    func bindingWithModel(_ model: EarningItemModel) {
        lbMsisdn?.text = model.month
        lbPoint?.text =  model.revenueStr
        lbAwardName?.text = model.status
    }
    
}
