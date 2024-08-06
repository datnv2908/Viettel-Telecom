//
//  TextFieldFormView.swift
//  MyClip
//
//  Created by sunado on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class TextFieldFormView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: BaseTextField!
    @IBOutlet weak var textFieldBottomView: UIView!
    @IBOutlet weak var textFieldBottomViewContraint: NSLayoutConstraint!
   @IBOutlet weak var bgView: UIView!
   @IBOutlet weak var lineView: UIView!
   @IBOutlet weak var conatiner: UIView!
   
    open var mode: BaseTextFieldMode {
        get {
            return textField.mode
        }
        
        set (new) {
            textField.mode = new
        }
    }
    
    open var title: String? {
        get {
            return titleLabel.text
        }
        set (new) {
            titleLabel.text = new
        }
    }
    
    open var titleTextColor: UIColor {
        get {
            return titleLabel.textColor
        }
        
        set (new) {
            titleLabel.textColor = new
        }
    }
    
    func setLabelFontSize(size: Int) {
        titleLabel.font = titleLabel.font.withSize(CGFloat(size))
    }
    
    open var bottomBorderSelectedColor: UIColor {
        get {
            return textField.borderSelectedColor
        }
        
        set (new) {
            textField.borderSelectedColor = new
        }
    }
    
    open var bottomBorderWaringColor: UIColor {
        get {
            return textField.borderWarningColor
        }
        
        set (new) {
            textField.borderWarningColor = new
        }
    }
    
    open var bottomBorderUnselectedColor: UIColor {
        get {
            return textField.borderUnselectedColor
        }
        
        set (new) {
            textField.borderUnselectedColor = new
        }
    }
    
    open var bottomBorderHeight: CGFloat {
        get {
            return textFieldBottomViewContraint.constant
        }
        
        set (new) {
            textFieldBottomViewContraint.constant = new
        }
    }
    
    open var minNumberCharacters: Int {
        get {
            return textField.minNumberChars
        }
        set (new) {
            textField.minNumberChars = new
        }
    }
    
    open var maxNumberCharracters: Int {
        get {
            return textField.maxNumberChars
        }
        
        set (new) {
            textField.maxNumberChars = new
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    // Performs the initial setup.
    private func setupView() {
        let view = viewFromNibForClass()
        self.backgroundColor = UIColor.setViewColor()
      bgView.backgroundColor = UIColor.setViewColor()
      self.textField.textColor = UIColor.settitleColor()
      self.backgroundColor = UIColor.setViewColor()
      self.textField.backgroundColor = UIColor.setViewColor()
      self.titleLabel.backgroundColor = UIColor.setViewColor()
      textFieldBottomView.backgroundColor = UIColor.setDarkModeColor(color1: UIColor.colorFromHexa("1c1c1e").withAlphaComponent(0.5), color2: .white)
        view.frame = bounds
        
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]

        // Show the view.
        addSubview(view)
        
        //set bottom view
        textField.border = textFieldBottomView
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        /* Usage for swift < 3.x
         let bundle = NSBundle(forClass: self.dynamicType)
         let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
         let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
         */
        
        return view
    }

}
