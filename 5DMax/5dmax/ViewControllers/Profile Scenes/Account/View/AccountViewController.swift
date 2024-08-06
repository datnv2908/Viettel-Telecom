//
//  AccountViewController.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var datasource: [AccountViewModel] = []
    var isEdit: Bool = false
    var user: MemberModel? = DataManager.getCurrentMemberModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpData()
    }

    func setUpView() {
        tableView.register(AccountTableViewCell.nibDefault(), forCellReuseIdentifier: AccountTableViewCell.nibName())
        self.navigationItem.title = String.tai_khoan
    }

    func setUpData() {

        datasource = []
        if let _user = user {
            if _user.msisdn.characters.count > 0 {
                let model = AccountViewModel(title: String.so_dien_thoai, value: _user.msisdn, type: .text)
                datasource.append(model)

                let modelPass   = AccountViewModel(title: String.mat_khau, value: "********", type: .password)
                let modelUpdate = AccountViewModel(title: String.chinh_sua, value: "", type: .none)

                datasource.append(modelPass)
                datasource.append(modelUpdate)

            } else {

                let modelName = AccountViewModel(title: String.ho_ten, value: _user.fullname, type: .text)
                datasource.append(modelName)

                let model = AccountViewModel(title: String.so_dien_thoai, value: String.lien_ket, type: .buttonLink)
                datasource.append(model)

            }
        }
    }

    func performConectAccount() {
        AuthorizeLinkAccountViewController.performLinkPhoneNumber(fromViewController: self)
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.nibName(),
                                                 for: indexPath) as! AccountTableViewCell
        let model = datasource[indexPath.row]
        cell.bindData(model: model, isEdit: isEdit)
        cell.selectionStyle = .none

        weak var weakSelf = self
        cell.actionHandle = { () in
            weakSelf?.performConectAccount()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = datasource[indexPath.row]

        if model.type == .none {
            let alert = UIAlertController(title: String.xac_nhan_chinh_sua,
                                          message: String.vui_long_nhap_mat_khau_de_bat_dau_chinh_sua_thong_tin_Tai_khoan,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: String.huy, style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: String.dong_y, style: .default, handler: { (_) in
                self.isEdit = true
                self.tableView.reloadData()
            }))

            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = String.mat_khau
                textField.isSecureTextEntry = true
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
}
