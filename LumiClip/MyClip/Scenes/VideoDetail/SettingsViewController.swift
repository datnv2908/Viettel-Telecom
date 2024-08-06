//
//  TableViewController.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    
    @IBOutlet weak var qualityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverQuality" {
            guard let controller = segue.destination as? QualityViewController else {return}
            controller.delegate = self
            controller.popoverPresentationController?.delegate = self
            controller.preferredContentSize = CGSize(width: 90, height: 125)
            controller.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 0, width: 0, height: 0)
        }
    }
}

extension SettingsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SettingsViewController: PassQualityProtocol {
    func passQuality(quality: String) {
        qualityLabel.text = quality
    }
}

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 2 {
            guard let url = URL(string: "link-to-app") else {return}
            UIApplication.shared.openURL(url)
        }
    }
}
