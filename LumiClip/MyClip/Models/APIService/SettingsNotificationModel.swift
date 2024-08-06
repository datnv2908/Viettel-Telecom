//
//  SettingsNotificationModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SettingsNotificationModel {
    var isNotification: Bool
    
    init(_ json: JSON) {
        isNotification = json["data"][0]["isNotification"].boolValue
    }
}
