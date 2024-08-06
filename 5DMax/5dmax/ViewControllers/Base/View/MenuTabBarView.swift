//
//  BaseTabbarView.swift
//  5dmax
//
//  Created by Hoang on 3/22/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol MenuTabBarViewDelegate: class {

    func menuBarDidSelect(menuBar: MenuTabBarView, index: IndexPath)
}

class MenuTabBarView: UICollectionView, UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    private var menuName: [String] = []
    var index: Int = 0
    var padding: CGFloat = 0
    private let widthDefault: CGFloat = 90.0
    weak var menuTabBarDelegate: MenuTabBarViewDelegate?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    override func setNeedsLayout() {
        super.setNeedsLayout()
    }

    func setUpView() {

        self.register(MenuCollectionViewCell.nibDefault(), forCellWithReuseIdentifier: "cell")
        self.dataSource = self
        self.delegate = self
        self.backgroundColor = AppColor.navigationColor()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return menuName.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! MenuCollectionViewCell
        cell.lblTitle.text = menuName[indexPath.row]

        if indexPath.row == index {
            cell.lblTitle.textColor = UIColor.white
        } else {
            cell.lblTitle.textColor = AppColor.warmGrey()
        }

        return cell
    }

    // MARK: 
    // MARK: 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: widthDefault, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 5
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let dele = menuTabBarDelegate {
            dele.menuBarDidSelect(menuBar: self, index: indexPath)
        }
    }

    // MARK: 
    // MARK: 
    func perfromReloadMenuData(menu: [String]) {

        menuName = menu

        let width: CGFloat = widthDefault*CGFloat(menu.count)
        let screenWidth = UIScreen.main.bounds.size.width
        padding = (screenWidth - width)/2
        self.reloadData()
    }

    func perfromSetCurrentIndex(currentIndex: Int) {

        self.index = currentIndex
        self.reloadData()
    }

    func getAttString() -> NSDictionary {
        return [NSAttributedString.Key.font: AppFont.museoSanFont(style: .semibold, size: 12.0)]
    }
}
