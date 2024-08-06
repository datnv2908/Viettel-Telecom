//
//  BaseTableViewController.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    class func initWithDefautlStoryboard() -> Self {
        let className = String(describing: self)
        let storyboardId = className
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: storyboardId)
    }

    class func initWithDefautlStoryboardWithID(storyboardId: String!) -> Self {
        let className = String(describing: self)
        return instantiateFromStoryboardHelper(storyboardName: className, storyboardId: storyboardId)
    }

    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
}
