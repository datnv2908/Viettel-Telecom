//
//  NewUpdateModel.swift
//  5dmax
//
//  Created by admin on 10/11/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit

class NewUpdateModel: NSObject,NSCoding {
    var id: Int
    var name: String
    
    init(_ dto: NewUpdateDTO) {
        id = dto.id
        name = dto.name
    }
    
    required init(coder decoder: NSCoder) {
        self.id      = decoder.decodeInteger(forKey: "id")
        self.name    = decoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.id, forKey: "id")
        coder.encode(self.name, forKey: "name")
    }
}
