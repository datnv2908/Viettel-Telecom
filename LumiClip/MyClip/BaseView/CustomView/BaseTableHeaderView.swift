//
//  BaseTableHeaderView.swift
//  MyClip
//
//  Created by Huy Nguyen on 6/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class BaseTableHeaderView: UITableViewHeaderFooterView {
   
   
    @IBOutlet weak var titleLabel: UILabel?
    var sectionIndex: Int = 0
    
   override  func awakeFromNib() {
      super.awakeFromNib()
      self.titleLabel?.textColor  =  UIColor.settitleColor()
   }
    func bindingWithModel(_ model: PBaseHeaderModel, section index: Int) {
        sectionIndex = index
        titleLabel?.text = model.title
      titleLabel?.textColor = UIColor.settitleColor()
      self.backgroundColor = UIColor.setViewColor()
    }
}
