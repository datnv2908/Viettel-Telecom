//
//  PriceDTO.swift
//  5dmax
//
//  Created by admin on 8/22/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class PriceDTO: NSObject {
    var price_play: String
    
    init(_ json: JSON) {
        price_play = json["price_play"].stringValue
    }
}
