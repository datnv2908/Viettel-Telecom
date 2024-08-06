//
//  HtmlContentModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class HtmlContentModel: NSObject, NSCoding {
    var type: String
    var content: String
    var contentType: HTMLContentType = .unknow

    init(_ dto: HtmlContentDTO) {
        type = dto.type
        content = dto.content
        contentType = HTMLContentType(rawValue: type) ?? .unknow
    }

    required init(coder decoder: NSCoder) {
        type        = decoder.decodeObject(forKey: "type") as? String ?? ""
        content     = decoder.decodeObject(forKey: "content") as? String ?? ""
        contentType = HTMLContentType(rawValue: type) ?? .unknow
    }

    func encode(with coder: NSCoder) {
        coder.encode(type, forKey: "type")
        coder.encode(content, forKey: "content")
    }
}
