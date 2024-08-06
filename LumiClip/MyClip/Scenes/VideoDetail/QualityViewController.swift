//
//  QualityViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class QualityViewController: UITableViewController {

    var delegate: PassQualityProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let selectedRow = tableView.cellForRow(at: indexPath) as? QualityTableViewCell
            else {return}
        let quality = selectedRow.qualityLabel.text ?? ""
        delegate.passQuality(quality: quality)
        dismiss(animated: true, completion: nil)
    }
    
}

protocol PassQualityProtocol {
    func passQuality(quality: String)
}
