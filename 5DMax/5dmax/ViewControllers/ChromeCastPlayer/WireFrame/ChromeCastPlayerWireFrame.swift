//
//  ChromeCastPlayerWireFrame.swift
//  5dmax
//
//  Created by Hoang on 3/31/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ChromeCastPlayerWireFrame: NSObject {

    weak var presenter: ChromeCastPlayerWireFrameOutput?
    weak var viewController: UIViewController?
}

extension ChromeCastPlayerWireFrame: ChromeCastPlayerWireFrameInput {

    func doDismiss() {

        viewController?.dismiss(animated: true, completion: nil)
    }
}
