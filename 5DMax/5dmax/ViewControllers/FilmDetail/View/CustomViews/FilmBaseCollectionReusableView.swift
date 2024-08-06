//
//  BaseCollectionReusableView.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PFilmBaseCollectionReusableView {
    func bindingWithModel(_ model: FilmDetailViewModel.FilmDetailSectionModel)
}

class FilmBaseCollectionReusableView: UICollectionReusableView, PFilmBaseCollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var thumbaiImageView: UIImageView!
    
    func bindingWithModel(_ model: FilmDetailViewModel.FilmDetailSectionModel) {
        titleLabel?.text = model.title
    }
}
