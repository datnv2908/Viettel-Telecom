//
//  CustomNumberTextField.swift
//  UserMenu
//
//  Created by sunado on 9/7/17.
//  Copyright © 2017 sunado. All rights reserved.
//

import UIKit

enum BaseTextFieldMode {
    case normal
    case password
    case number
}

class BaseTextField: UITextField {
    internal var currentText = ""
    open var maxNumberChars = 24
    open var minNumberChars = 2
    open var count = 0
    open var border: UIView?
    open var borderSelectedColor: UIColor = UIColor(red: 0.0/255.0, green: 129.0/255.0, blue: 255.0/255.0, alpha: 0.9)
    open var borderUnselectedColor: UIColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1)
    open var borderWarningColor: UIColor = UIColor.red
    open var mode: BaseTextFieldMode = .normal {
        didSet {
            switch mode {
            case .normal:
                maxNumberChars = 50
                minNumberChars = 0
                isSecureTextEntry = false
                keyboardType = .default
                break
            case .number:
                maxNumberChars = 11
                minNumberChars = 0
                isSecureTextEntry = false
                keyboardType = .decimalPad
            case .password:
                maxNumberChars = 50
                minNumberChars = 8
                isSecureTextEntry = true
                keyboardType = .default
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        addTarget(self, action: #selector(beginEdit(_:)), for: .editingDidBegin)
        addTarget(self, action: #selector(endEdit(_:)), for: .editingDidEnd)
        self.textColor  = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    @objc private func didChange(_ textField: UITextField){
        let text = textField.text ?? ""
        switch mode {
        case .normal:
            if text.count > maxNumberChars  {
                textField.text = currentText
            } else {
                count = text.count
                currentText = text
            }
            
            if text.count < minNumberChars {
                border?.backgroundColor = borderWarningColor
            } else {
                border?.backgroundColor = borderSelectedColor
            }
            
            break
        case .number:
            if text.count > maxNumberChars || text.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil{
                textField.text = currentText
            } else{
                count = text.count
                currentText = text
            }

            if text.count < minNumberChars {
                border?.backgroundColor = borderWarningColor
            } else {
                border?.backgroundColor = borderSelectedColor
            }
            
            break
        case .password:
            if text.count < minNumberChars {
                border?.backgroundColor = borderWarningColor
                currentText = text
            } else if text.count <= maxNumberChars {
                border?.backgroundColor = borderSelectedColor
                currentText = text
            } else {
                border?.backgroundColor = borderSelectedColor
                textField.text = currentText
            }
        }
    }

    @objc internal func beginEdit(_ textField: UITextField) {
        border?.backgroundColor = borderSelectedColor
    }
    
    @objc internal func endEdit(_ textField: UITextField) {
        if (textField.text?.isEmpty)! {
            border?.backgroundColor = borderUnselectedColor
        } else if (textField.text?.count)! < minNumberChars {
            border?.backgroundColor = borderWarningColor
        } else {
            border?.backgroundColor = borderUnselectedColor
        }
    }
}
