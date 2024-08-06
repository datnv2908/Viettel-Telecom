//
//  BaseCustomButton.swift
//  5dmax
//
//  Created by admin on 10/1/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class BaseCustomButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat {
        set{
            layer.cornerRadius = newValue
        } get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWith: CGFloat {
        set {
            layer.borderWidth = newValue
        } get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        } get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            } else {
                return nil
            }
        }
    }
}
