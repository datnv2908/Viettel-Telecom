//
//  DarkTextField.swift
//  MyClip
//
//  Created by Hoang on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    var tintedClearImage: UIImage?
    
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            } else {
                return nil
            }
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
        self.textColor = AppColor.imBlackColor()
    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
    }

    override func prepareForInterfaceBuilder() {
        self.setUpView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setUpTintClearImage()
        self.setUpPlaceHodler()
    }

    private func setUpPlaceHodler() {
        if let att = self.attributedPlaceholder {
            if att.length > 0 {

                let font = AppFont.font(size: 15)
                let placeHodlerColor = AppColor.imWarmGrey()
                let myAttribute = [NSAttributedString.Key.font: font,
                                   NSAttributedString.Key.foregroundColor: placeHodlerColor]
                let attStr = NSAttributedString(string: att.string, attributes: myAttribute)
                self.attributedPlaceholder = attStr
            }
        }
    }

    private func setUpView() {

        let paddingView         = UIView(frame: CGRect(x: 15, y: 15, width: 15, height: 15))
        self.leftView           = paddingView
        self.leftViewMode       = .always
//        self.keyboardAppearance = .dark
        self.clipsToBounds      = true
    }

    private func setUpTintClearImage() {
        for view in subviews where view is UIButton {
            let button = view as! UIButton
            if let uiImage = button.image(for: .highlighted) {
                if tintedClearImage == nil {
                    tintedClearImage = tintImage(image: uiImage, color: AppColor.imWarmGrey())
                }
                button.setImage(tintedClearImage, for: .normal)
                button.setImage(tintedClearImage, for: .highlighted)
            }
        }
    }

    private func tintImage(image: UIImage, color: UIColor) -> UIImage {
        let size = image.size

        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        image.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)

        context!.setFillColor(color.cgColor)
        context!.setBlendMode(CGBlendMode.sourceIn)
        context!.setAlpha(1.0)

        let rect = CGRect(x: 0, y:  0, width: image.size.width, height: image.size.height)
        UIGraphicsGetCurrentContext()!.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return tintedImage!
    }
}
