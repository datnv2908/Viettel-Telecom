//
//  DarkTextField.swift
//  5dmax
//
//  Created by Hoang on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class DarkTextField: UITextField {

    var tintedClearImage: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
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

                let font = AppFont.museoSanFont(style: .regular, size: 15.0)
                let placeHodlerColor = AppColor.warmGrey()
                let myAttribute = [NSAttributedString.Key.font: font,
                                   NSAttributedString.Key.foregroundColor: placeHodlerColor]
                let attStr = NSAttributedString(string: att.string, attributes: myAttribute)
                self.attributedPlaceholder = attStr
            }
        }
    }

    private func setUpView() {
        let paddingView         = UIView(frame: CGRect(x: 10, y: 15, width: 15, height: 15))
        self.leftView           = paddingView
        self.leftViewMode       = .always
        self.backgroundColor    = UIColor.init(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
        self.keyboardAppearance = .dark
        self.layer.cornerRadius = 4.0
        self.clipsToBounds      = true
        self.textColor = AppColor.warmGrey()
    }

    private func setUpTintClearImage() {
        for view in subviews where view is UIButton {
            let button = view as! UIButton
            if let uiImage = button.image(for: .highlighted) {
                if tintedClearImage == nil {
                    tintedClearImage = tintImage(image: uiImage, color: AppColor.warmGrey())
                }
                button.setImage(tintedClearImage, for: UIControl.State.normal)
                button.setImage(tintedClearImage, for: UIControl.State.highlighted)
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

        let rect = CGRect(x: CGPoint.zero.x, y:  CGPoint.zero.y, width: image.size.width, height: image.size.height)
        UIGraphicsGetCurrentContext()!.fill(rect)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return tintedImage!
    }
}
