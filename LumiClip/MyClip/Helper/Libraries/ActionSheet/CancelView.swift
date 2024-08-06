//
//  CancelView.swift
//  MyClip
//
//  Created by ThuongPV-iOS on 10/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class CancelView: UIView {

    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var iconBg: UIView!
    @IBOutlet weak var seprateView: UIView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.setViewColor()
        self.iconBg.backgroundColor = UIColor.setViewColor()
        self.seprateView.backgroundColor = UIColor.setSeprateViewColor()
        self.cancelLabel.text = String.huy_bo
        self.cancelLabel.textColor = UIColor.settitleColor()
    }

}
