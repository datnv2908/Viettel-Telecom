//
//  HeaderModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 7/10/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct HeaderModel: PBaseHeaderModel {
    var title: String
    var identifier: String?
    init(title: String = "", identifier: String? = nil) {
        self.title = title
        self.identifier = identifier
    }
}
