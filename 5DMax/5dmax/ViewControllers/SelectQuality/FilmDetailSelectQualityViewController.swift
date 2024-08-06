//
//  SelectQualityViewController.swift
//  5dmax
//
//  Created by Macintosh on 8/30/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

protocol FilmDetailSelectQualityViewControllerDelegate {
    func didSelectQuality(viewController: FilmDetailSelectQualityViewController?, quality: QualityModel)
}

@objcMembers
class FilmDetailSelectQualityViewController: BaseViewController {

    fileprivate var _listQuality: [QualityModel] = []
    var _currentQuality: QualityModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblSelectQuality: UILabel!
    var delegate: FilmDetailSelectQualityViewControllerDelegate?
    
    init(quality: QualityModel?, listQuality: [QualityModel]) {
        super.init(nibName: "FilmDetailSelectQualityViewController", bundle: nil)
        _listQuality.append(contentsOf: listQuality)
        
        if quality == nil {
            _currentQuality = _listQuality.first
        } else {
            _currentQuality = quality
        }
        self.preferredContentSize = CGSize(width: 330, height: 230)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSelectQuality.text = String.chon_chat_luong
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func canRotate() {}
}

extension FilmDetailSelectQualityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._listQuality.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12.0)
        cell.textLabel?.textColor = UIColor.white
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.tintColor = UIColor.white
        let quality = _listQuality[indexPath.row]
        cell.textLabel?.text = quality.name
        
        if let current = _currentQuality {
            cell.accessoryType = (current.name == quality.name) ? .checkmark : .none
        } else {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _currentQuality = _listQuality[indexPath.row]
        tableView.reloadData()
        delegate?.didSelectQuality(viewController: self, quality: _listQuality[indexPath.row])
    }
}
