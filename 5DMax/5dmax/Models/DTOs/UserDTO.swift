//
//  UserDTO.swift
//  5dmax
//
//  Created by Admin on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserDTO: NSObject {

    var userid: String
    var name: String
    var msisdn: String
    var email: String
    var avatarImage: String
    var packages: PackageDTO

    init(_ json: JSON) {
        userid = json["id"].stringValue
        name = json["name"].stringValue
        msisdn = json["msisdn"].stringValue
        email = json["email"].stringValue
        avatarImage = json["avatarImage"].stringValue
        packages = PackageDTO(json["packages"])
    }

}
