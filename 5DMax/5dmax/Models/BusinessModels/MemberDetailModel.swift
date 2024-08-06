//
//  MemberDetailModel.swift
//  5dmax
//
//  Created by Hoang on 3/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MemberDetailModel: NSObject {

    var userId: Int = 0
    var email: String?
    var msisdn: String?
    var avatarImage: String?
    var name: String?
    var packages: [PackageModel] = []

    init(_ dto: MemberDetailDTO) {

        userId = dto.id
        email = dto.email
        msisdn = dto.msisdn
        avatarImage = dto.avatarImage
        name = dto.name
        packages = []

        for item in dto.packages {

            packages.append(PackageModel(item))
        }
    }
}
