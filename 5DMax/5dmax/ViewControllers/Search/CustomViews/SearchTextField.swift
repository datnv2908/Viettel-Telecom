//
//  SearchTextField.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol SearchTextFieldDelegate: NSObjectProtocol {
    func textFieldShouldReturn(_ textField: UITextField)
}

class SearchTextField: UIView {
    @IBOutlet weak var textField: UITextField!
    weak var delegate: SearchTextFieldDelegate?

    @IBAction func onClear(_ sender: Any) {
        textField.text = nil
        if let delegate = self.delegate {
            delegate.textFieldShouldReturn(textField)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        textField.placeholder = String.nhap_ten_phim_dien_vien
        if let string = textField.placeholder {
            textField.attributedPlaceholder =
                NSAttributedString(string: string,
                                   attributes: [NSAttributedString.Key.foregroundColor: AppColor.warmGreyThreeColor()])
        }
        textField.delegate = self
    }
}

extension SearchTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let delegate = self.delegate {
            delegate.textFieldShouldReturn(textField)
        }
        return true
    }
}
