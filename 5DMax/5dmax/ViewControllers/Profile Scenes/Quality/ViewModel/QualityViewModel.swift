//
//  QualityViewModel.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class QualityViewModel: NSObject {

    var isDownloadOnlyWifi: Bool        = DataManager.getSettingDownloadWifi()
    var filmQuality: QualityModel?      = DataManager.getSettingFilmQuality()
    var downloadQuality: QualityModel?  = DataManager.getSettingDownloadFilmQuality()
}
