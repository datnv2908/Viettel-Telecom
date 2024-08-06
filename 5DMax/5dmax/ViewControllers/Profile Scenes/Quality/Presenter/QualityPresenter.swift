//
//  QualityPresenter.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class QualityPresenter: NSObject {

    var wireFrame: QualityWireFrame? = QualityWireFrame()
    var viewModel: QualityViewModel? = QualityViewModel()

    func performChangeDownloadWifi(_ isActive: Bool) {

        viewModel?.isDownloadOnlyWifi = isActive
        DataManager.saveSettingDownloadWifi(isActive: isActive)
    }

    func performSelectFilmQuality() {

        weak var weakSelf = self
        wireFrame?.performSelectFilmQuality(currentQuality: viewModel?.filmQuality,
                                            selectQuality: { (quality: QualityModel) -> (Void) in

            weakSelf?.viewModel?.filmQuality = quality
            DataManager.saveSettingFilmQuality(quality)
        })
    }

    func performSelectDownloadFilmQuality() {

        weak var weakSelf = self
        wireFrame?.performSelectDownloadFilmQuality(currentQuality: viewModel?.downloadQuality,
                                                    selectQuality: { (quality: QualityModel) -> (Void) in

            weakSelf?.viewModel?.downloadQuality = quality
            DataManager.saveSettingDownloadFilmQuality(quality)
        })
    }
}
