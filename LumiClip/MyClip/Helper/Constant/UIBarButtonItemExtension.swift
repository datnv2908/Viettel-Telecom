//
//  AppNavButtonItem.swift
//  MyClip
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    class func appTitleView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        let image = #imageLiteral(resourceName: "MyClip")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        view.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        view.addSubview(imageView)
        return view
    }

    class func menuBarButton(target: Any, selector: Selector) -> MJBadgeBarButton {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        menuButton.addTarget(target, action: selector, for: .touchUpInside)
        let barButton = MJBadgeBarButton()
        barButton.badgeBGColor = UIColor.red
        barButton.badgeTextColor = UIColor.white
        barButton.badgeOriginX = 23
        barButton.badgeOriginY = 5
        barButton.badgeSize = 6.0
        barButton.badgeFont = AppFont.font(size: 5)
        barButton.badgeMinSize = 6.0
        barButton.shouldHideBadgeAtZero = false
        barButton.setup(customButton: menuButton)
        barButton.addRemoveBadge(true)
        return barButton
    }

    class func searchBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "search"), style: .plain, target: target, action: selector)
    }
    
    class func closeBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "iconEscape"), style: .plain, target: target, action: selector)
    }
    
    class func uploadBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: String.tai_len.uppercased(), style: .plain, target: target, action: selector)
    }
    
    class func finishBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "iconCheckWhite"), style: .plain, target: target, action: selector)
    }

    class func bellBarButton(target: Any, selector: Selector) -> MJBadgeBarButton {
        let bellButton = UIButton(type: .custom)
        bellButton.setImage(#imageLiteral(resourceName: "bell"), for: .normal)
        bellButton.frame = CGRect(x: 0, y: 0, width: #imageLiteral(resourceName: "bell").size.width, height: 40)
        bellButton.addTarget(target, action: selector, for: .touchUpInside)
        let barButton = MJBadgeBarButton()
        barButton.badgeBGColor = UIColor.red
        barButton.badgeTextColor = UIColor.white
        barButton.badgeOriginX = 10
        barButton.badgeFont = AppFont.font(size: 9)
        barButton.badgeMinSize = 12.0
        barButton.badgeSize    = 14.0
        barButton.setup(customButton: bellButton)
        return barButton
    }

    class func cancelBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: String.huy.uppercased(), style: .plain, target: target, action: selector)
    }
    
    class func nextBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: String.Next.uppercased(), style: .plain, target: target, action: selector)
    }
    
    class func editBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "videoEditButton"), style: .plain, target: target, action: selector)
    }
    
    class func saveBarButton(target: Any, selector: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(title: String.luu.uppercased(), style: .plain, target: target, action: selector)
    }
}
