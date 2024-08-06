//
//  EditNameChannelViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class EditNameChannelViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var nameText: TextFieldFormView!
    @IBOutlet weak var countFirstNameLabel: UILabel!
    
    let service = UserService()
    var name: String = ""
    var desc: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupView() {
        self.title = String.chinh_sua_ten
        
        nameText.mode = .normal
        nameText.title = String.ten_day_du
        nameText.maxNumberCharracters = 49
        nameText.textField.font = UIFont(name: "SFUIText-Regular", size: 16)
        nameText.textField.tag = 101
        nameText.textField.text = self.name
        countFirstNameLabel.text = "\(nameText.textField.text?.count ?? 0)/50"
        nameText.textField.delegate = self
        
        let finishButton = UIBarButtonItem.saveBarButton(target: self, selector: #selector(finishEdit))
        navigationItem.rightBarButtonItem = finishButton
    }
    
    func splitFullName(fullName: String) -> [String] {
        let fullNameArr = fullName.components(separatedBy: " ")
        return fullNameArr
    }
    
    @objc func finishEdit() {
        if verify() {
            let fullName = nameText.textField.text ?? ""
            showHud()
            service.updateChannel(name: fullName, description: self.desc, { (result) in
                switch result {
                case .success(let message):
                    guard let message = message as? String else {return}
                    guard let model = DataManager.getCurrentMemberModel() else {return}
                    model.fullName = fullName
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
        if textField.tag == 101 {
            countFirstNameLabel.text = String(newLength) + "/50"
            return true
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        countFirstNameLabel.text = "0/50"
        return true
    }
    
    internal func verify() -> Bool {
        let fullName = nameText.textField.text ?? ""
        
        if fullName.isEmpty {
            toast(String.EmptyEditNameChannel)
            return false
        }
        return true
    }
}
