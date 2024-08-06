//
//  FeedBackModel.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FeedBackModel: NSObject, NSCoding {

    var id: String
    var content: String

    init(_ dto: FeedBackDTO) {

        id      = dto.id
        content = dto.content
    }

    required init(coder decoder: NSCoder) {
        self.id         = decoder.decodeObject(forKey: "id") as? String ?? ""
        self.content    = decoder.decodeObject(forKey: "content") as? String ?? ""
    }

    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.content, forKey: "content")
    }
}
