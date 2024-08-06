//
//  PackageModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/19/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PackageModel: NSObject {
    var id: String
    var name: String
    var desc: String
    var shortDesc: String
    var popup: [String]
    var fee: Int
    var status: Int
    init(_ dto: PackageDTO) {
        id = dto.id
        name = dto.name
        desc = dto.desc
        shortDesc = dto.shortDesc
        popup = dto.popup
        fee = dto.fee
        status = dto.status
    }
}
