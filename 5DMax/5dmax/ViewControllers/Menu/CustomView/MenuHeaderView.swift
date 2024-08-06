//
//  MenuHeaderView.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol SelectHeaderDelegate:NSObjectProtocol {
    func didSelectHeader(header: MenuHeaderView, sender: Any)
}

class MenuHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    
    var viewModel: NotificationViewModel = NotificationViewModel()
    var notificationServices: NotificationServices = NotificationServices()
    
    weak var delegateHeader: SelectHeaderDelegate?
    
    var selectHeaderClore: ((UIButton) -> Void)?
    var selectNotificationClore: ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clear
    }

    @IBAction func onShowProfile(_ sender: Any) {
        if let closure = selectHeaderClore {
            closure(sender as! UIButton)
        }
    }
    
    func bindingWith(_ viewModel: MenuViewModel) {
        hiLabel.text = String.xin_chao.uppercased()
        phoneLabel.text = viewModel.phoneNumber
    }
}

