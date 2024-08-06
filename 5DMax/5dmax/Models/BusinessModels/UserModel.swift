//
//  UserModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    var userid: String
    var name: String
    var msisdn: String
    var email: String
    var avatarImage: String
    var package: PackageModel

    init(_ dto: UserDTO) {
        userid = dto.userid
        name = dto.name
        msisdn = dto.name
        email = dto.email
        avatarImage = dto.avatarImage
        package = PackageModel(dto.packages)
    }
}
