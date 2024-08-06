//
//  PriceModel.swift
//  5dmax
//
//  Created by admin on 8/22/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class PriceModel: NSObject {
    var price_play: String
    
    init(_ dto: PriceDTO) {
        price_play = dto.price_play
    }
}
