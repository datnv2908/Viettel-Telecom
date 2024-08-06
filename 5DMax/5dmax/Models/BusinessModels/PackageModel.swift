//
//  PackageModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

enum PackageModelType {

    case packageService
    case purchase
}

class PackageModel: NSObject, NSCoding {

    var packageId: String
    var name: String
    var fee: String
    var shortDescription: String
    var desc: String
    var status: Bool
    var popUp: [String] = []
    var capacityFree: String
    var type: PackageModelType = .packageService
    var expiredStr: String
    var cycle: String

    init(_ dto: PackageDTO) {
        packageId   = dto.packageId
        name        = dto.name
        fee         = dto.fee
        shortDescription = dto.shortDesciption
        desc        = dto.desc
        status      = dto.status
        popUp       = []
        popUp.append(contentsOf: dto.popup)
        capacityFree = dto.capacityFree
        expiredStr   = dto.expiredStr
        cycle       = dto.cycle
    }

    required init(coder decoder: NSCoder) {
        packageId       = decoder.decodeObject(forKey: "packageId") as? String ?? ""
        name            = decoder.decodeObject(forKey: "name") as? String ?? ""
        fee             = decoder.decodeObject(forKey: "fee") as? String ?? ""
        shortDescription   = decoder.decodeObject(forKey: "shortDescription") as? String ?? ""
        desc            = decoder.decodeObject(forKey: "desc") as? String ?? ""
        status          = decoder.decodeObject(forKey: "status") as? Bool ?? false
        popUp           = decoder.decodeObject(forKey: "status") as? [String] ?? []
        capacityFree    = decoder.decodeObject(forKey: "capacityFree") as? String ?? ""
        expiredStr      = decoder.decodeObject(forKey: "expiredStr") as? String ?? ""
        cycle           = decoder.decodeObject(forKey: "cycle") as? String ?? ""
    }

    func encode(with coder: NSCoder) {

        coder.encode(packageId, forKey: "packageId")
        coder.encode(name, forKey: "name")
        coder.encode(fee, forKey: "fee")
        coder.encode(shortDescription, forKey: "shortDescription")
        coder.encode(desc, forKey: "desc")
        coder.encode(status, forKey: "status")
        coder.encode(popUp, forKey: "popUp")
        coder.encode(capacityFree, forKey: "capacityFree")
        coder.encode(expiredStr, forKey: "expiredStr")
        coder.encode(cycle, forKey: "cycle")
    }

    override init() {
        packageId   = ""
        name        = ""
        fee         = ""
        shortDescription = ""
        desc        = ""
        status      = false
        popUp       = []
        capacityFree = ""
        expiredStr = ""
        cycle       = ""
    }

    class func defaultPackeage() -> PackageModel {
        let model = PackageModel()
        model.name = "Thanh toán bằng thẻ ATM/Visa/MasterCard/Thẻ cào"
        model.type = .purchase
        return model
    }
}
