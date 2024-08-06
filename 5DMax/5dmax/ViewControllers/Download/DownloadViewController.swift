//
//  DownloadViewController.swift
//  5dmax
//
//  Created by admin on 9/10/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class DownloadViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
    }
    
    func setNavigation() {
        self.navigationItem.title = String.tai_ve
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuBarItem(target: self,
                                                                            btnAction: #selector(menuButtonAction(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
