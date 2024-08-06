//
//  FilmSeasonView.swift
//  5dmax
//
//  Created by Gem on 4/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Nuke
import UIKit

protocol FilmSeasonCollectionViewCellDelegate: NSObjectProtocol {
    func filmSeasonCollectionViewCell(_ cell: FilmSeasonCollectionViewCell, didSelectEpisodeAtIndex index: Int)
    func filmSeasonCollectionViewCell(_ cell: FilmSeasonCollectionViewCell, didTapOnPlayPart sender: Any)
}

class FilmSeasonCollectionViewCell: BaseCollectionViewCell {

    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentCoverImageView: UIImageView!
    @IBOutlet weak var currentAlias: UILabel!
    @IBOutlet weak var currentDuration: UILabel!
    @IBOutlet weak var currentDescription: UILabel!

    weak var delegate: FilmSeasonCollectionViewCellDelegate?
    var currentIndex: Int = 0
    var parts = [PartRowModel]()
    override func bindingWithModel(_ model: PBaseRowModel) {
        super.bindingWithModel(model)
        let rowModel = model as! FilmDetailViewModel.FilmSeasonRowModel
        seasonButton.setTitle(rowModel.title, for: .normal)
        
        if let url = URL(string: rowModel.currentImageUrl),
            let thumb = currentCoverImageView {
            let request = ImageRequest(url: url)
            Nuke.loadImage(with: request, into: thumb)
        }
        
        currentAlias.text = rowModel.currentAlias
        currentDuration.text = rowModel.currentDuration
        currentDescription.text = rowModel.currentDescription
        currentIndex = rowModel.currentIndex
        parts = rowModel.parts

        for part in parts {
            collectionView.register(UINib(nibName: part.identifier, bundle: Bundle.main),
                                    forCellWithReuseIdentifier: part.identifier)
            break
        }
        collectionView.reloadData()
        if parts.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1), execute: {
                self.collectionView.scrollToItem(at: IndexPath(item: rowModel.currentIndex, section: 0),
                                                 at: UICollectionView.ScrollPosition.centeredHorizontally,
                                                 animated: false)
            })
        }
    }
    @IBAction func onPlayPart(_ sender: Any) {
        delegate?.filmSeasonCollectionViewCell(self, didTapOnPlayPart: sender)
    }

    @IBAction func seasonAction(_ sender: Any) {

    }
}

extension FilmSeasonCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parts.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowModel = parts[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: rowModel.identifier,
                                                      for: indexPath) as! BaseCollectionViewCell
        cell.bindingWithModel(rowModel)
        return cell
    }
}

extension FilmSeasonCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.filmSeasonCollectionViewCell(self, didSelectEpisodeAtIndex: indexPath.item)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 65, height: 36)
    }

}
