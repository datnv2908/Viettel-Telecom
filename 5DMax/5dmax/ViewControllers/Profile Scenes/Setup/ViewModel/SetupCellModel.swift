//
//  SetupCellModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct SetupCellModel: PBaseRowModel {
    var title: String
    var desc: String
    var imageUrl: String
    var identifier: String
    var type: SetupCellType
    var descFilm: String
    init(_ cellType: SetupCellType) {
        title = cellType.stringValue()
        if cellType == .facebook {
            identifier = SetupFacebookTableViewCell.nibName()
        } else {
            identifier = ProfileTableViewCell.nibName()
        }
        if cellType == .version {
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
            let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
            desc = "App Version \(version) (Build \(buildVersion))"
        } else {
            desc = ""
        }
        imageUrl = ""
        type = cellType
        descFilm = "" 
    }
}
