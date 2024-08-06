//
//  QualityDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class QualityDTO: NSObject {

    var name: String
    var vodProfileId: Int
    var liveProfileId: Int

    init(_ json: JSON) {
        name = json["name"].stringValue
        vodProfileId = json["vod_profile_id"].intValue
        liveProfileId = json["live_profile_id"].intValue
    }
}
