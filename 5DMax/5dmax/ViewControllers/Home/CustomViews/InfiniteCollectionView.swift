//
//  InfiniteCollectionView.swift
//  ExampleInfiniteScrollView
//
//  Created by Mason L'Amy on 04/08/2015.
//  Copyright (c) 2015 Maso Apps Ltd. All rights reserved.
//

import UIKit

protocol InfiniteCollectionViewDataSource {
    func cellForItemAtIndexPath(collectionView: UICollectionView, dequeueIndexPath: NSIndexPath,
                                usableIndexPath: NSIndexPath) -> UICollectionViewCell
    func numberOfItems(collectionView: UICollectionView) -> Int
    func itemSizeWidth() -> CGFloat
    func minimumInteritemSpacing() -> CGFloat
}

protocol InfiniteCollectionViewDelegate: NSObjectProtocol {
    func didSelectCellAtIndexPath(collectionView: UICollectionView, usableIndexPath: NSIndexPath)
}

class InfiniteCollectionView: UICollectionView {
    var infiniteDataSource: InfiniteCollectionViewDataSource?
    weak var infiniteDelegate: InfiniteCollectionViewDelegate?

    fileprivate var cellPadding = CGFloat(0)
    fileprivate var cellWidth = CGFloat(0)
    fileprivate var indexOffset = 0

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cellPadding = (self.infiniteDataSource?.itemSizeWidth())!
        cellWidth = (self.infiniteDataSource?.minimumInteritemSpacing())!
        centreIfNeeded()
    }

    fileprivate func centreIfNeeded() {
        let currentOffset = contentOffset
        let contentWidth = getTotalContentWidth()

        if contentWidth <= 0 {
            return
        }

        // Calculate the centre of content X position offset and the current distance from that centre point
        let centerOffsetX: CGFloat = (3 * contentWidth - bounds.size.width) / 2
        let distFromCentre = centerOffsetX - currentOffset.x

        if fabs(distFromCentre) > (contentWidth / 4) {
            // Total cells (including partial cells) from centre
            let cellcount = distFromCentre/(cellWidth+cellPadding)

            // Amount of cells to shift (whole number) - conditional statement due to nature of +ve or -ve cellcount
            let shiftCells = Int((cellcount > 0) ? floor(cellcount) : ceil(cellcount))

            // Amount left over to correct for
            let offsetCorrection = (abs(cellcount).truncatingRemainder(dividingBy: 1)) * (cellWidth+cellPadding)

            // Scroll back to the centre of the view, offset by the correction to ensure it's not noticable
            if contentOffset.x < centerOffsetX {
                //left scrolling
                contentOffset = CGPoint(x: centerOffsetX - offsetCorrection, y: currentOffset.y)
            } else if contentOffset.x > centerOffsetX {
                //right scrolling
                contentOffset = CGPoint(x: centerOffsetX + offsetCorrection, y: currentOffset.y)
            }

            // Make content shift as per shiftCells
            shiftContentArray(offset: getCorrectedIndex(indexToCorrect: shiftCells))

            // Reload cells, due to data shift changes above
            reloadData()
        }
    }

    fileprivate func shiftContentArray(offset: Int) {
        indexOffset += offset
    }

    fileprivate func getTotalContentWidth() -> CGFloat {
        let numberOfCells = infiniteDataSource?.numberOfItems(collectionView: self) ?? 0
        return CGFloat(numberOfCells) * (cellWidth + cellPadding)
    }

    func getIndexPath(indexPath: NSIndexPath) -> NSIndexPath {
       return NSIndexPath(item: getCorrectedIndex(indexToCorrect: indexPath.row - indexOffset), section: 0)
    }
}

extension InfiniteCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = infiniteDataSource?.numberOfItems(collectionView: self) ?? 0
        return  3 * numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return infiniteDataSource!.cellForItemAtIndexPath(
            collectionView: self, dequeueIndexPath: indexPath as NSIndexPath,
                                                          usableIndexPath: NSIndexPath(item: getCorrectedIndex(
                                                            indexToCorrect: indexPath.row - indexOffset), section: 0))
    }

    fileprivate func getCorrectedIndex(indexToCorrect: Int) -> Int {
        if let numberOfCells = infiniteDataSource?.numberOfItems(collectionView: self) {
            if numberOfCells == 0 {
                return 0
            }

            if indexToCorrect < numberOfCells && indexToCorrect >= 0 {
                return indexToCorrect
            } else {
                let countInIndex = Float(indexToCorrect) / Float(numberOfCells)
                let flooredValue = Int(floor(countInIndex))
                let offset = numberOfCells * flooredValue
                return indexToCorrect - offset
            }
        } else {
            return 0
        }
    }
}

extension InfiniteCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        infiniteDelegate?.didSelectCellAtIndexPath(collectionView: self,
                                                   usableIndexPath: NSIndexPath(item: getCorrectedIndex(
                                                    indexToCorrect: indexPath.row - indexOffset), section: 0))
    }
}
