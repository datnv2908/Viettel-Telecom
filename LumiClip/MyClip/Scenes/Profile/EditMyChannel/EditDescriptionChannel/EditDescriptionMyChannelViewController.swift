//
//  EditDescriptionMyChannelViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class EditDescriptionMyChannelViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var descriptionText: TextFieldFormView!
    @IBOutlet weak var countLabel: UILabel!
    
    let service = UserService()
    var name: String = ""
    var desc: String = ""
    
    override func setupView() {
        self.title = String.chinh_sua_mo_ta
        
        descriptionText.mode = .normal
        descriptionText.title = String.mo_ta
        descriptionText.maxNumberCharracters = 140
        descriptionText.textField.font = UIFont(name: "SFUIText-Regular", size: 16)
        descriptionText.textField.text = self.desc
        countLabel.text = "\(descriptionText.textField.text?.count ?? 0)/140"
        descriptionText.textField.delegate = self
        
        let finishButton = UIBarButtonItem.saveBarButton(target: self, selector: #selector(finishEdit))
        navigationItem.rightBarButtonItem = finishButton
    }
    
    @objc func finishEdit() {
        if verify() {
            let description = descriptionText.textField.text ?? ""
            showHud()
            service.updateChannel(name: self.name, description: description, { (result) in
                switch result {
                case .success(let message):
                    guard let message = message as? String else {return}
                    guard let model = DataManager.getCurrentMemberModel() else {return}
                    model.desc = description
                    DataManager.saveMemberModel(model)
                    self.toast(message)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self.toast(error.localizedDescription)
                }
                self.hideHude()
            })
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let newLength = (textField.text?.count ?? 0) + string.count - range.length
        if newLength <= 140 {
            countLabel.text = String(newLength) + "/140"
            return true
        }
        
        return false
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        countLabel.text = "0/140"
        return true
    }
    
    internal func verify() -> Bool {
        let description = descriptionText.textField.text ?? ""
        
        if description.isEmpty {
            toast(String.EmptyEditDescriptionChannel)
            return false
        }
        return true
    }
}
