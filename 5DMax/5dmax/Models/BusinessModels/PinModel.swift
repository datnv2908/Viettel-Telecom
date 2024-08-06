//
//  PinModel.swift
//  5dmax
//
//  Created by Hoang on 3/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

enum ContentLevel: String {
    case all = "7+"
    case required13 = "13+"
    case required16 = "16+"
    case required18 = "18+"

    func intValue() -> Int {
        switch self {
        case .all:
            return 0
        case .required13:
            return 13
        case .required16:
            return 16
        case .required18:
            return 18
        }
    }
}

class PinModel: NSObject, NSCoding {

    var code1: String = ""
    var code2: String = ""
    var code3: String = ""
    var code4: String = ""
    var contentLevel: ContentLevel = .required18
    var isOn: Bool = false

    override init() {
        super.init()
        code1 = ""
        code2 = ""
        code3 = ""
        code4 = ""
        isOn = false
    }

    func isBlank() -> Bool {
        if code1.characters.isEmpty &&
            code2.characters.isEmpty &&
            code3.characters.isEmpty &&
            code4.characters.isEmpty {
                return true
        }

        return false
    }

    func reset() {
        code1 = ""
        code2 = ""
        code3 = ""
        code4 = ""
        contentLevel = .required18
    }

    func isEqualWithPin(pin: String) -> Bool {
        let fullPIN = code1 + code2 + code3 + code4
        if fullPIN == pin {
            return true
        }
        return false
    }

    required init(coder decoder: NSCoder) {
        code1   = decoder.decodeObject(forKey: "code1") as? String ?? ""
        code2   = decoder.decodeObject(forKey: "code2") as? String ?? ""
        code3   = decoder.decodeObject(forKey: "code3") as? String ?? ""
        code4   = decoder.decodeObject(forKey: "code4") as? String ?? ""
        let type = decoder.decodeObject(forKey: "contentLevel") as? String ?? ""
        contentLevel = ContentLevel(rawValue: type) ?? .all
        isOn = decoder.decodeBool(forKey: "isOn")
    }

    func encode(with coder: NSCoder) {
        coder.encode(code1, forKey: "code1")
        coder.encode(code2, forKey: "code2")
        coder.encode(code3, forKey: "code3")
        coder.encode(code4, forKey: "code4")
        coder.encode(contentLevel.rawValue, forKey: "contentLevel")
        coder.encode(isOn, forKey: "isOn")
    }
}
