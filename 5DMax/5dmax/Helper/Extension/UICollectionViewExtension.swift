//
//  UICollectionViewExtension.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func addNoDataLabel(_ noDataString: String) {
        let label = UILabel()
        label.text = noDataString
        label.textAlignment = .center
        label.font = AppFont.museoSanFont(style: .regular, size: 17)
        label.textColor = AppColor.brownishGrey()
        self.backgroundView = label
    }

    func removeNoDataLabel() {
        self.backgroundView = nil
    }
}