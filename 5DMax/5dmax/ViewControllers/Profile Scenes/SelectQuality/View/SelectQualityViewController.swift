//
//  SelectQualityViewController.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SelectQualityViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var listQuality: [QualityModel] = [QualityModel.defaultModel()]
    var settingModel: SettingModel? = DataManager.getDefaultSetting()
    var defaultQuality: QualityModel? = QualityModel.defaultModel()
    var selectQualityHanlde: SelectQualityBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setUpView() {
        self.navigationItem.title = String.chon_chat_luong
        lblTitle.text = String.phim_chat_luong_cao_se_su_dung_nhieu_data_hon
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        view.backgroundColor = AppColor.grayBackgroundColor()
    }

    func setUpData() {
        if let setting = settingModel {
            listQuality.append(contentsOf: setting.quality)
        }
    }

    deinit {

        listQuality.removeAll()
        settingModel = nil
        defaultQuality = nil
        selectQualityHanlde = nil
    }
}

extension SelectQualityViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return listQuality.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let quality = listQuality[indexPath.row]
        cell.textLabel?.text = quality.name
        cell.backgroundColor = .white
        cell.textLabel?.textColor = AppColor.untCharcoalGrey()
        cell.textLabel?.font = AppFont.museoSanFont(style: .regular, size: 17)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)

        if indexPath.row == listQuality.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10000)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        }

        if quality.name == defaultQuality?.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let quality = listQuality[indexPath.row]
        if quality.name != defaultQuality?.name {
            defaultQuality = quality

            if let block = selectQualityHanlde {

                block(quality)
            }

            tableView.reloadData()
        }
    }
}
