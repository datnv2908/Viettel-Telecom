//
//  MovieQualityModel.swift
//  5dmax
//
//  Created by Gem on 4/3/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MovieQualityModel: NSObject {
    var title: String = ""
    var url: String = ""

    init(title qualityTitle: String, url urlString: String) {
        title = qualityTitle
        url = urlString
    }
}
