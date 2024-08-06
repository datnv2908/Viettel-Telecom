//
//  SeriesTableViewCell.swift
//  5dmax
//
//  Created by Toan on 7/16/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

protocol getDetailFilm {
    func getDetailFilm(mFilm: FilmModel)
}
class SeriesTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var seriesClHeight: NSLayoutConstraint!
    @IBOutlet weak var seriesCl: UICollectionView!
    var listRowModel: [RowModel] = []
    var sectionModel = HomeViewModel.HomeSectionModel()
     var delegate: getDetailFilm?
    override func awakeFromNib() {
        super.awakeFromNib()
        seriesCl.delegate = self
        seriesCl.dataSource = self
        self.seriesCl.addObserver(self, forKeyPath: "contentSize", options:   NSKeyValueObservingOptions.old.union(NSKeyValueObservingOptions.old), context: nil)
        self.backgroundColor = UIColor.clear
        self.seriesCl.backgroundColor = UIColor.clear
    }
    func bindingWith(_ model: HomeViewModel.HomeSectionModel) {
           sectionModel = model
           for row in model.rows {
               seriesCl.register(UINib(nibName: row.identifier, bundle: Bundle.main),
                                       forCellWithReuseIdentifier: row.identifier)

           }
        listRowModel = model.rows
           seriesCl.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listRowModel.count
    }
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = listRowModel[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier,
                                                      for: indexPath) as! MovieItemCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rowModel = listRowModel[indexPath.row]
        delegate?.getDetailFilm(mFilm: rowModel.film!)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        self.seriesClHeight.constant = (CGFloat(listRowModel.count) * sectionModel.sizeForItem().height) + 8
        self.layoutIfNeeded()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
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

