//
//  AddPlaylistViewController.swift
//  MyClip
//
//  Created by sunado on 9/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AddPlaylistViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var addPlaylistView: TextFieldFormView!
    
    @IBOutlet weak var contenBgView: UIView!
    var service = UserService()
    var completionBlock: CompletionBlock?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupView() {
        setupNameView()
        setupNavigation()
        contenBgView.backgroundColor = UIColor.setViewColor()
        
        self.addPlaylistView.textField.becomeFirstResponder()
        navigationItem.leftBarButtonItem = UIBarButtonItem.closeBarButton(target: self, selector: #selector(onClickDismissButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.luu, style: .plain, target: self, action: #selector(onClickSaveButton(_:)))
        addPlaylistView.backgroundColor = UIColor.setViewColor()
        self.view.backgroundColor = UIColor.setViewColor()
    }
    
    func setupNameView() {
        addPlaylistView.mode = .normal
        addPlaylistView.title = String.name
        addPlaylistView.titleTextColor = UIColor.settitleColor()
        addPlaylistView.titleLabel.font = SFUIDisplayFont.fontWithType(.bold, size: 14)
        addPlaylistView.textField.font = SFUIDisplayFont.fontWithType(.regular, size: 16)
        addPlaylistView.textField.placeholder = String.enterNewPlaylistName
        addPlaylistView.textField.clearButtonMode = .whileEditing
        addPlaylistView.maxNumberCharracters = 50
    }
    
    @objc func onClickDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func onClickSaveButton(_ sender: Any) {
        if DataManager.isLoggedIn() {
            performAddPlaylist()
        } else {
            performLogin(completion: { (result) in
                if result.isSuccess {
                    self.performAddPlaylist()
                }
            })
        }
    }
    
    func performAddPlaylist() {
        if vertify() {
            let name = addPlaylistView.textField.text ?? ""
            showHud()
            service.createPlaylist(name: name, description: "", completion: { (result) in
                switch result {
                case .failure(let error):
                    self.handleError(error as NSError, completion: { (result) in
                        if result.isSuccess {
                            self.performAddPlaylist()
                        }
                    })
                case .success(let response):
                    let userInfo = [NSLocalizedDescriptionKey: response.message, "model": response.data] as [String : Any]
                    self.completionBlock?(CompletionBlockResult(isCancelled: false, isSuccess: true, with: userInfo))
                    self.dismiss(animated: true, completion: nil)
                }
                self.hideHude()
            })
        }
    }
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       guard let textFieldText = textField.text,
           let rangeOfTextToReplace = Range(range, in: textFieldText) else {
               return false
       }
       let substringToReplace = textFieldText[rangeOfTextToReplace]
       let count = textFieldText.count - substringToReplace.count + string.count
       return count <= 50
   }
    func setupNavigation() {
        navigationItem.title = String.tao_danh_sach_phat_moi
    }
    
    func vertify() -> Bool {
        let name = addPlaylistView.textField.text ?? ""
        if name.isEmpty  {
            toast(String.enterPlaylistName)
            addPlaylistView.textField.becomeFirstResponder()
            return false
        }
        return true
    }
}
