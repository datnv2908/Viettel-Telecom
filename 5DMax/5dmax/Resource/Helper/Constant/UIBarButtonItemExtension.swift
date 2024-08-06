//
//  AppNavButtonItem.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit
import GoogleCast

extension UIBarButtonItem {
    static func menuBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "icSlideMenu")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)

        return UIBarButtonItem(customView: btn)
    }

    static func searchBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "icSearch")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)

        return UIBarButtonItem(customView: btn)
    }

    static func notificationBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "icStorage")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)

        return UIBarButtonItem(customView: btn)
    }
    
    class func notifyBarItem(target: AnyObject, btnAction: Selector) -> MJBadgeBarButton {
        let bellButton = UIButton(type: .custom)
        let image = UIImage(named: "notificationBig")
        bellButton.setImage(image, for: .normal)
        bellButton.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        bellButton.addTarget(target, action: btnAction, for: .touchUpInside)
        let barButton = MJBadgeBarButton()
        barButton.badgeBGColor = UIColor.colorFromHexa("32b7bb")
        barButton.badgeTextColor = UIColor.white
        barButton.badgeOriginX = 10
        barButton.badgeFont = AppFont.museoSanFont(style: .regular, size: 10)
        barButton.badgeMinSize = 14.0
        barButton.badgeSize    = 16.0
        barButton.setup(customButton: bellButton)
        return barButton
    }
    
    static func titleBarItem() -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "logoMax")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 54.8, height: 25.9))
        btn.setImage(icon, for: .normal)
        btn.isEnabled = false

        return UIBarButtonItem(customView: btn)
    }

    static func backBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "icBack3")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
        return UIBarButtonItem(customView: btn)
    }

    static func storeBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "icStorage")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)

        return UIBarButtonItem(customView: btn)
    }

    static func shareBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "share")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)

        return UIBarButtonItem(customView: btn)
    }

    static func closeBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {
        let icon = #imageLiteral(resourceName: "icClose")
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.addTarget(target, action: btnAction, for: .touchUpInside)
        btn.setImage(icon, for: .normal)

        return UIBarButtonItem(customView: btn)
    }

    static func registerBarItem(target: AnyObject, btnAction: Selector) -> UIBarButtonItem {

        let item = UIBarButtonItem(title: String.dang_ky, style: .done, target: target, action: btnAction)
        item.tintColor = AppColor.blue()
        return item
    }

    static func chromecastBarItem() -> UIBarButtonItem {
        let frame = CGRect(x: 0, y: 0, width: 30, height: 38)
        let castButton = GCKUICastButton(frame: frame)
        castButton.tintColor = UIColor.white
        let item = UIBarButtonItem(customView: castButton)
        return item
    }
    
    static func composeBarButton(target: AnyObject, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: UIImage(named: "compose"), style: .plain, target: target, action: action)
    }
}

extension UIView {
    static func titleViewItem() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        let icon = #imageLiteral(resourceName: "logo5D_small")
        let imageView = UIImageView(image: icon)
        view.addSubview(imageView)
        return view
    }
}

extension UIButton {

    func setUpStyleBarItem() {
        self.titleLabel?.font = AppFont.museoSanFont(style: .bold, size: 13.0)
        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 5.0
    }
}
