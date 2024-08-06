//
//  UICollectionReusableViewExtension.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionReusableView {
    @objc class func nibName() -> String {
        var nibName = String(describing: self)
        if Constants.isIpad {
            if let pathXib = Bundle.main.path(forResource: "\(nibName)_\(Constants.iPad)", ofType: "nib") {
                if FileManager.default.fileExists(atPath: pathXib) {
                    nibName = "\(nibName)_\(Constants.iPad)"
                }
            }
        }
        return nibName
    }
}
