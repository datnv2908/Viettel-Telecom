//
//  SettingsViewModal.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

struct SettingsViewModel {
    var defaultQuality: String
    var isNotification: Bool = true
    var title = String.cai_dat
    var appVersion: String
    init() {
        defaultQuality = UserDefaults.standard.string(forKey: Constants.kDefaultQuality) ?? String.auto    
        if let bundle = Bundle.main.infoDictionary?["CFBundleVersion"]  as? String, let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"]  as? String {
            appVersion = "\(version)(\(bundle))"
        } else {
            appVersion = ""
        }
    }
}
