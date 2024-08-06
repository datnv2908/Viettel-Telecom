//
//  AddPlaylistViewController.swift
//  MyClip
//
//  Created by sunado on 9/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol UpdatePlaylistViewControllerDelegate: NSObjectProtocol {
    func didUpdate(_ model: PlaylistModel)
}

class UpdatePlaylistViewController: BaseViewController {
    weak var delegate: UpdatePlaylistViewControllerDelegate?
    @IBOutlet weak var nameView: TextFieldFormView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var descBottomView: UIView!
    @IBOutlet weak var nameNumberLabel: UILabel!
    @IBOutlet weak var descNumberLabel: UILabel!
    @IBOutlet weak var motaLabel: UILabel!
    private var playlistModel: PlaylistModel
    var service = UserService()
    
    init(_ model: PlaylistModel) {
        playlistModel = model
        super.init(nibName: "UpdatePlaylistViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.motaLabel.text = String.mo_ta
    }
    
    override func setupView() {
        setupNameView()
        setupNavigation()
        setupDescTextView()
        setupContent()
    }
    
    func setupNameView() {
        nameView.mode = .normal
        nameView.title = String.ten_danh_sach_phat
        nameView.maxNumberCharracters = 50
        nameView.textField.addTarget(self, action: #selector(onTextFieldChange), for: .editingChanged)
    }
    
    func setupNavigation() {
        navigationItem.title = String.updatePlaylist
        let saveBtn = UIButton(type: .custom)
        saveBtn.setImage(#imageLiteral(resourceName: "iconCheckBlack").withRenderingMode(.alwaysOriginal), for: .normal)
        saveBtn.frame = CGRect(x: 7, y: 6, width: 34, height: 28)
        saveBtn.addTarget(self, action: #selector(onClickSave), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveBtn)
    }
    
    func setupContent() {
        nameView.textField.text = playlistModel.name
        descTextView.text = playlistModel.desc
        let nameCharracterCount = playlistModel.name.count
        nameNumberLabel.text = "\(nameCharracterCount)/50"
        let descCharracterCount = playlistModel.desc.count
        descNumberLabel.text = "\(descCharracterCount)/50"
    }
    
    func setupDescTextView() {
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.isScrollEnabled = false
        descTextView.delegate = self
    }
    
    @objc func onClickSave() {
        if vertify() {
            let name = nameView.textField.text ?? ""
            let desc = descTextView.text ?? ""
            showHud()
            service.updatePlaylist(id: playlistModel.id, name: name, description: desc, completion: { (result) in
                switch result {
                case .failure(let error):
                    self.handleError(error as NSError, completion: { (result) in
                        if result.isSuccess {
                            self.onClickSave()
                        }
                    })
                    self.hideHude()
                case .success( _):
                    self.toast(String.updateSuccess)
                    self.hideHude()
                    self.navigationController?.popViewController(animated: true)
                    let updatedModel = self.playlistModel
                    updatedModel.name = name
                    updatedModel.desc = desc
                    self.delegate?.didUpdate(updatedModel)
                }
            })
        }
    }
    
    func vertify() -> Bool {
        let name = nameView.textField.text ?? ""
        if name.isEmpty  {
            toast(String.enterPlaylistName)
            nameView.textField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    @objc func onTextFieldChange() {
        if let count = nameView.textField.text?.count {
            nameNumberLabel.text = "\(count)/50"
        }
    }
}

extension UpdatePlaylistViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        descBottomView.backgroundColor = nameView.textField.borderSelectedColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        descBottomView.backgroundColor = nameView.textField.borderUnselectedColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text ?? ""
        let count = text.count
        descNumberLabel.text = "\(count)/50"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isOverLength = textView.text.count + (text.count - range.length) > 50
        return !isOverLength
    }
}

