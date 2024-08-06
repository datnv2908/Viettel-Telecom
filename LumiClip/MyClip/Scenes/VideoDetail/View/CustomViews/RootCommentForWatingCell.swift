//
//  RootCommentForWatingCell.swift
//  MeuClip
//
//  Created by mac on 31/10/2021.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

class RootCommentForWatingCell: BaseTableViewCell {
   @IBOutlet weak var addCommentLabel: UILabel!
   @IBOutlet weak var postedAtLabel: UILabel!
   
   
   override func bindingWithModel(_ model: PBaseRowModel) {
       super.bindingWithModel(model)
   }
   
    
}
