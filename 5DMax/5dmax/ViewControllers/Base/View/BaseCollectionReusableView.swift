//
//  BaseCollectionReusableView.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/20/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

protocol PBaseCollectionReusableView {
    func bindingWithModel(_ model: SectionModel)
}

class BaseCollectionReusableView: UICollectionReusableView, PBaseCollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel?
    func bindingWithModel(_ model: SectionModel) {
        titleLabel?.text = model.title
    }
}
