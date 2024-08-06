//
//  TrendingViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct TrendingViewModel {
    var rows: [TrendingRowModel]

    init(_ keywords: [String]) {
        rows = [TrendingRowModel]()
        for keyword in keywords {
            rows.append(TrendingRowModel(keyword))
        }
    }

    struct TrendingRowModel: PBaseRowModel {
        var title: String
        var desc: String
        var imageUrl: String
        var identifier: String
        var descFilm: String
        init(_ keyword: String) {
            title = keyword
            desc = ""
            imageUrl = ""
            identifier = TrendingTableViewCell.nibName()
            descFilm = ""
        }
    }

}
