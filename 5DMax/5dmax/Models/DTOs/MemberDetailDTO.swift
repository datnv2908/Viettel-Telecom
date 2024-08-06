//
//  MemberDetailDTO.swift
//  5dmax
//
//  Created by Hoang on 3/27/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class MemberDetailDTO: NSObject {

    var email: String?
    var id: Int = 0
    var msisdn: String?
    var avatarImage: String?
    var name: String?
    var packages: [PackageDTO]

    init(_ json: JSON) {
        email           = json["email"].stringValue
        id              = json["id"].intValue
        msisdn          = json["msisdn"].stringValue
        avatarImage     = json["avatarImage"].stringValue
        name            = json["name"].stringValue
        packages        = []

        for sub in json["packages"].arrayValue {
            packages.append(PackageDTO(sub))
        }
    }
}
