//
//  QualityWireFrame.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class QualityWireFrame: NSObject {

    var hostViewController: UIViewController?

    func performSelectFilmQuality(currentQuality: QualityModel?, selectQuality: SelectQualityBlock?) {

        let viewController = SelectQualityViewController.initWithNib()
        viewController.defaultQuality = currentQuality
        viewController.selectQualityHanlde = selectQuality
        hostViewController?.navigationController?.pushViewController(viewController, animated: true)
    }

    func performSelectDownloadFilmQuality(currentQuality: QualityModel?, selectQuality: SelectQualityBlock?) {

        let viewController = SelectQualityViewController.initWithNib()
        viewController.defaultQuality = currentQuality
        viewController.selectQualityHanlde = selectQuality
        hostViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}
