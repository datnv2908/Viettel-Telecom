//
//  NotificationNameExtension.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let receiveRemoteNotification =
        Notification.Name(rawValue: "com.viettel.congphim.receivedRemoteNotification")
    static let receiveRemoteUIBarButton = Notification.Name(rawValue: "receivedOneUIBarButton")
    static let receiveNotifcation = Notification.Name("receivedNotification")
    static let receiveNotifcationToReloadDetailView = Notification.Name("receiveNotifcationToReloadDetailView")
}

