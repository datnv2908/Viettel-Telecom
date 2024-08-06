//
//  QualityModel.swift
//  5dmax
//
//  Created by Hoang on 3/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class QualityModel: NSObject, NSCoding {

    var name: String
    var isAuto: Bool = false
    var url: String
    var isSelected: Bool

    init(_ dto: QualityDTO) {
        name = dto.name
        isAuto = false
        url = ""
        isSelected = false
    }

    required init(coder decoder: NSCoder) {
        name            = decoder.decodeObject(forKey: "name") as? String ?? ""
        isAuto          = decoder.decodeBool(forKey: "isAuto")
        url             = decoder.decodeObject(forKey: "url") as? String ?? ""
        isSelected      = decoder.decodeBool(forKey: "isSelected")
    }

    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(isAuto, forKey: "isAuto")
        coder.encode(url, forKey: "url")
        coder.encode(isSelected, forKey: "isSelected")
    }

    override init() {

        name = String.tu_dong
        isAuto = true
        url = ""
        isSelected = true
    }

    init(_ name: String, _ url: String, isAuto: Bool, isSelected: Bool) {
        self.name = name
        self.url = url
        self.isAuto = isAuto
        self.isSelected = isSelected
    }

    class func defaultModel() -> QualityModel! {
        let model = QualityModel()
        model.name = String.tu_dong
        model.isAuto = true
        model.isSelected = true
        return model
    }
}
