

//
//  PlaylistDTO.swift
//  MyClip
//
//  Created by Os on 9/12/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaylistDTO: NSObject {
    var id: String
    var name: String
    var desc: String
    var coverImage: String
    var avatarImage: String
    var numberVideo: Int
    var type: String
    var isOfficial : Bool
    var pricePlay : String
    init(_ json: JSON) {
        id              = json["id"].stringValue
        name            = json["name"].stringValue
        desc            = json["description"].stringValue
        coverImage      = json["coverImage"].stringValue
        avatarImage     = json["avatarImage"].stringValue
        numberVideo     = json["num_video"].intValue
        type            = json["type"].stringValue
        isOfficial      = json["official"].boolValue
        pricePlay      = json["price_play"].stringValue
    }
}
