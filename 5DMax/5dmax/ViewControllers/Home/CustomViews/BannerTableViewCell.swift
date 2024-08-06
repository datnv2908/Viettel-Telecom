//
//  BannerTableViewCell.swift
//  5dmax
//
//  Created by Thuy Vu Dinh on 4/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class BannerTableViewCell: CollectionTableViewCell {

    @IBOutlet weak var infiniteCollectionView: InfiniteCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.infiniteCollectionView.infiniteDataSource = self
        self.infiniteCollectionView.delegate = self
    }

    override func bindingWith(_ model: HomeViewModel.HomeSectionModel) {
        sectionModel = model
        for row in model.rows {
            infiniteCollectionView.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                            forCellWithReuseIdentifier: row.identifier)
        }
        infiniteCollectionView.reloadData()
    }
}

extension BannerTableViewCell: InfiniteCollectionViewDataSource {
    func numberOfItems(collectionView: UICollectionView) -> Int {
        if sectionModel.rows.count > 10 {
            return 10
        } else {
            return sectionModel.rows.count
        }
    }

    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: NSIndexPath,
                                usableIndexPath: NSIndexPath) -> UICollectionViewCell {
        let rowModel = sectionModel.rows[usableIndexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier,
                                                      for: dequeueIndexPath as IndexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        if let watchingCell = cell as? WatchingItemCollectionViewCell {
            weak var wself = self
            watchingCell.viewInfoClosure = {(_ sender: Any) in
                wself?.delegate?.collectionTableViewCell(wself!, didSelectViewInfoItemAtIndex: usableIndexPath.item, film: rowModel.film)
            }
        }
        return cell
    }

    func itemSizeWidth() -> CGFloat {
        return sectionModel.sizeForItem().width
    }

    func minimumInteritemSpacing() -> CGFloat {
        return sectionModel.itemSpacing()
    }
}

//CollectionView delegate
extension BannerTableViewCell {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            let rowModel = sectionModel.rows[indexPath.row]
            delegate.collectionTableViewCell(self, didSelectItemAtIndex:  self.infiniteCollectionView.getIndexPath(
                indexPath: indexPath as NSIndexPath).row, film: rowModel.film)
        }
    }
}
