//
//  QualityViewController.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class QualityViewController: BaseTableViewController {

    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var lblDownload: UILabel!
    @IBOutlet weak var lblOnlyWifi: UILabel!
    
    @IBOutlet weak var cellFilmQuality: UITableViewCell!
    @IBOutlet weak var cellDownloadFilmQuality: UITableViewCell!
    @IBOutlet weak var swichWifiDownload: UISwitch!

    var presenter: QualityPresenter? = QualityPresenter()

    @IBAction func swiftWifiDownloadChangeValue(_ sender: Any) {
        presenter?.performChangeDownloadWifi(swichWifiDownload.isOn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell == cellFilmQuality {
            presenter?.performSelectFilmQuality()
        } else if cell == cellDownloadFilmQuality {
            presenter?.performSelectDownloadFilmQuality()
        }
    }

    func setUpView() {
        self.navigationItem.title = String.chat_luong
        presenter?.wireFrame?.hostViewController = self
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        view.backgroundColor = AppColor.grayBackgroundColor()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        lblQuality.text = String.chat_luong_phim
        lblDownload.text = String.tai_ve
        lblOnlyWifi.text = String.chi_tai_bang_wifi
        
        cellFilmQuality.textLabel?.text = String.chon_chat_luong
        cellFilmQuality.detailTextLabel?.text = presenter?.viewModel?.filmQuality?.name
        
        cellDownloadFilmQuality.textLabel?.text = String.chon_chat_luong
        cellDownloadFilmQuality.detailTextLabel?.text = presenter?.viewModel?.downloadQuality?.name
        swichWifiDownload.isOn = (presenter?.viewModel?.isDownloadOnlyWifi)!
        return cell
    }
}
