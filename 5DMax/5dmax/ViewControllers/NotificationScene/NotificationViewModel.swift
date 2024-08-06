//
//  NotificationViewModel.swift
//  5dmax
//
//  Created by Os on 4/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class NotificationViewModel: NSObject {
    let title: String = String.thong_bao
    var listNotification: [NotificationModel] = []
    
    override init() {
        listNotification = []
    }
    
    init(_ list: [NotificationModel]) {
        listNotification = list
    }
    
    func getNumberRowInSection(_ section: Int) -> Int {
        return listNotification.count
    }

    func getNotifyAtIndexPath(_ indexPath: IndexPath) -> NotificationModel {
        return listNotification[indexPath.row]
    }
}
