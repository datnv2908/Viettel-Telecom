//
//  DrawerContainerViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/24/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import MMDrawerController

class DrawerContainerViewController: MMDrawerController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showsShadow = false

        // Do any additional setup after loading the view.
        self.maximumLeftDrawerWidth = 280
        self.openDrawerGestureModeMask = .all
        self.closeDrawerGestureModeMask = .all
        self.openDrawerGestureModeMask = .bezelPanningCenterView

        let sideMenuViewController = MenuContainerViewController()
        self.leftDrawerViewController = sideMenuViewController
        self.centerViewController = sideMenuViewController.mainMenu.homeNav
        self.shouldStretchDrawer = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showHome() {
        if let menu = self.leftDrawerViewController as? MenuContainerViewController {
            menu.mainMenu.showHome()
        }
    }
}
