//
//  ViewExtension.swift
//  MyClip
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Toast

extension UIView {

    class func nibDefault() -> UINib {
        let nibName = String(describing: self)
        let nib = UINib.init(nibName: nibName, bundle: nil)
        return nib
    }        
    
    func toast(_ message: String) {
        let style = CSToastStyle(defaultStyle: ())
        style?.messageAlignment = .center
        if !message.isEmpty {
            self.makeToast(message,
                           duration: TimeInterval(Constants.kToastDuration),
                           position: CSToastPositionCenter,
                           style: style)
        }
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
//        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
