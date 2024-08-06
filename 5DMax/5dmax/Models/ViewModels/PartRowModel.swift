//
//  PartRowModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/8/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

struct PartRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var imageUrl: String
    var identifier: String
    var isActive: Bool
   var descFilm: String
    init(_ index: Int, _ active: Bool) {
        title = String.init(format: "%d", index + 1)
        desc = ""
        imageUrl = ""
        identifier = EpisodeCollectionViewCell.nibName()
        isActive = active
        descFilm = "" 
    }
}
