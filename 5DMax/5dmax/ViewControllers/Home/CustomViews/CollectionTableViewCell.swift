//
//  CollectionTableViewCell.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol CollectionTableViewCellDelegate: NSObjectProtocol {
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectItemAtIndex index: Int, film: FilmModel?)
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectViewInfoItemAtIndex index: Int, film: FilmModel?)
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didScroll scrollView: UIScrollView)
    func collectionTableViewCell(_ cell: CollectionTableViewCell, didSelectAddSeeLate index: Int)
    func collectionTableViewCell(_ cell: CollectionTableViewCell, playTrailer index: Int)
    func collectionTableViewCell(_ cell: CollectionTableViewCell, setVolume index: Int)
}

class CollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var sectionModel = HomeViewModel.HomeSectionModel()
    weak var delegate: CollectionTableViewCellDelegate?
    let services: FilmService = FilmService()
    var playListModel: PlayListModel?
    var isLoading = false
    var movieType = HomeType.normalHome
    
    func bindingWith(_ model: HomeViewModel.HomeSectionModel) {
        sectionModel = model
        sectionModel.delegate = self
        for row in model.rows {
            collectionView.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                    forCellWithReuseIdentifier: row.identifier)
        }
        collectionView.reloadData()
    }

    func setCollectionViewOffset(_ offset: CGPoint) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
            self.collectionView.contentOffset = offset
        })
    }
}

extension CollectionTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionModel.rows.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = sectionModel.rows[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier,
                                                      for: indexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        if let watchingCell = cell as? WatchingItemCollectionViewCell {
            weak var wself = self
            watchingCell.viewInfoClosure = {(_ sender: Any) in
                wself?.delegate?.collectionTableViewCell(wself!, didSelectViewInfoItemAtIndex: indexPath.item, film: rowModel.film)
            }
        } else if let comingsoonCell = cell as? FilmUpcomingCollectionViewCell {
            weak var wself = self
            comingsoonCell.playTrailerClosure = {(sender: Any) in
                if let strong = wself {
                    wself?.delegate?.collectionTableViewCell(strong, playTrailer: indexPath.item)
                }
            }
            comingsoonCell.watchLatedClosure = {(_ sender: Any) in
                if let strong = wself {
                    wself?.delegate?.collectionTableViewCell(strong, didSelectAddSeeLate: indexPath.item)
                }
            }
            
            comingsoonCell.volumeClosure = {(_ sender: Any) in
                if let strong = wself {
                    wself?.delegate?.collectionTableViewCell(strong, setVolume: indexPath.item)
                }
            }
        }
        return cell
    }
}

extension CollectionTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            let rowModel = sectionModel.rows[indexPath.row]
            delegate.collectionTableViewCell(self, didSelectItemAtIndex: indexPath.item, film: rowModel.film)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let delegate = self.delegate {
            delegate.collectionTableViewCell(self, didScroll: scrollView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let rowModel = sectionModel.rows[indexPath.row]
        if let lastItem = sectionModel.rows.last, rowModel.id == lastItem.id {
            sectionModel.doLoadMore(movieType: self.movieType)
        }
        
        if let trailerCell = cell as? FilmUpcomingCollectionViewCell, trailerCell.window != nil {
            trailerCell.isFocused
            let listWindows = UIApplication.shared.windows
            if listWindows.first == trailerCell.window {
                trailerCell.startPlayTrailer()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let trailerCell = cell as? FilmUpcomingCollectionViewCell {
            trailerCell.stopPlayTrailer()
        }
    }
}

extension CollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionModel.insetForSection()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionModel.itemSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionModel.itemSpacing()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sectionModel.sizeForItem()
    }
}

extension CollectionTableViewCell: SectionModelDelegate {
    func sectionDidLoadMore() {
        self.collectionView.reloadData()
    }
}
