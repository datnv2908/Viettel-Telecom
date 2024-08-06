//
//  RelateVideoHeaderView.swift
//  MyClip
//
//  Created by hnc on 10/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol RelateVideoHeaderViewDelegate: NSObjectProtocol {
    func relatedVideoHeaderView(_ view: RelateVideoHeaderView, toggleAutoPlay sender: UISwitch)
}

class RelateVideoHeaderView: BaseTableHeaderView {
    
    weak var delegate: RelateVideoHeaderViewDelegate?
    
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var watchNextLabel: UILabel!
    @IBOutlet weak var autoLabel: UILabel!
    @IBOutlet weak var contentBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);
        watchNextLabel.text = String.xem_tiep
        autoLabel.text = String.tu_dong_phat
        self.contentBgView.backgroundColor = UIColor.setDarkModeColor(color1: .white, color2: UIColor.colorFromHexa("1c1c1e"))
        watchNextLabel.textColor = UIColor.settitleColor()
        autoLabel.textColor = UIColor.settitleColor()
    }
    
    override func bindingWithModel(_ model: PBaseHeaderModel, section index: Int) {
        if let headerModel = model as? RelateVideoHeaderModel {
            switchView.isOn = headerModel.isAutoPlay
        }
    }
    
    @IBAction func toggleAutoPlay(_ sender: UISwitch) {
        delegate?.relatedVideoHeaderView(self, toggleAutoPlay: sender)
    }
}
