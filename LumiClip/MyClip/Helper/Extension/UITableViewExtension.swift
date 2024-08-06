//
//  UITableViewExtension.swift
//  MyClip
//
//  Created by Huy Nguyen on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func addNoDataLabel(_ noDataString: String) {
        let label           = UILabel()
        label.text          = noDataString
        label.textAlignment = .center
        label.font          = AppFont.font(size: 17)
        label.textColor     = AppColor.imBlackColor()
        self.backgroundView = label
    }

    func removeNoDataLabel() {
        self.backgroundView = nil
    }
}
