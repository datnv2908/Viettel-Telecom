//
//  SlideTableViewCell.swift
//  5dmax
//
//  Created by Admin on 3/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

let autoScrollDuration: TimeInterval = 10

class SliderTableViewCell: CollectionTableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    var listRowModel: [RowModel] = []
    weak var timer: Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func bindingWith(_ model: HomeViewModel.HomeSectionModel) {
        sectionModel = model
        for row in model.rows {
            collectionView.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                    forCellWithReuseIdentifier: row.identifier)
        }
        if sectionModel.rows.count > 1 {
            let firstItem = model.rows.first
            let lastItem = model.rows.last
            var workingArray = model.rows
            workingArray.insert(lastItem!, at: 0)
            workingArray.append(firstItem!)
            listRowModel = workingArray
            startTimer()
            pageControl.numberOfPages = sectionModel.rows.count - 2
            self.collectionView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
                DispatchQueue.once(token: "banner", block: { 
                    if self.collectionView.numberOfItems(inSection: 0) > 0 {
                        self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)
                    }
                })
            })
        } else {
            listRowModel.append(contentsOf: model.rows)
            collectionView.reloadData()
            pageControl.numberOfPages = sectionModel.rows.count
            pageControl.currentPage = 0
        }
    }

    private func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: autoScrollDuration, target: self,
                                         selector: #selector(autoScrollCollectionView), userInfo: nil, repeats: true)
        }
    }

    @objc func autoScrollCollectionView(_ collectionView: UICollectionView) {
        let currentOffset: CGPoint = self.collectionView.contentOffset
        var currentIndex = Int(currentOffset.x / self.collectionView.bounds.size.width)
        if currentIndex < listRowModel.count - 1 {
            currentIndex += 1
            self.collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: false)
            pageControl.currentPage = 0
        }
    }

    func calculateTheOffset(_ collectionView: UICollectionView) {
        // We can ignore the first time scroll,
        // because it is caused by the call scrollToItemAtIndexPath: in dispath one
        var lastContentOffsetX: CGFloat  = CGFloat.leastNormalMagnitude
        let currentOffsetX = collectionView.contentOffset.x
        let currentOffsetY = collectionView.contentOffset.y
        let pageWidth = collectionView.bounds.size.width
        let offset = pageWidth * CGFloat(listRowModel.count - 2)
        // the first page(showing the last item) is visible and user's finger is still scrolling to the right

        var page = 0 as Int
        if currentOffsetX < pageWidth && lastContentOffsetX > currentOffsetX {
            lastContentOffsetX = currentOffsetX + offset
            collectionView.contentOffset = CGPoint(x: lastContentOffsetX, y: currentOffsetY)
            page = Int(collectionView.contentOffset.x / pageWidth)
        }
            // the last page (showing the first item) is visible and the user's finger is still scrolling to the left
        else if currentOffsetX > offset && lastContentOffsetX < currentOffsetX {
            lastContentOffsetX = currentOffsetX - offset
            collectionView.contentOffset = CGPoint(x: lastContentOffsetX, y: currentOffsetY)
            page = Int(collectionView.contentOffset.x / pageWidth)
        } else {
            lastContentOffsetX = currentOffsetX
            page = Int(currentOffsetX / pageWidth)
        }
        pageControl.currentPage = page - 1
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.calculateTheOffset(scrollView as! UICollectionView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.calculateTheOffset(scrollView as! UICollectionView)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = 0
        if sectionModel.rows.count > 1 {
            index = indexPath.item - 1
        } else {
            index = indexPath.item
        }
        if index < 0 {
            index = 0
        }
        if let delegate = self.delegate {
            DispatchQueue.main.async {
                let rowModel = self.sectionModel.rows[index]
                delegate.collectionTableViewCell(self, didSelectItemAtIndex: index, film: rowModel.film)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRowModel.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = listRowModel[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier,
                                                      for: indexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
}
