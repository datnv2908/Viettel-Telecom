//
//  ChannelEndUserEditModel.swift
//  UClip
//
//  Created by Toan on 7/9/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
class ChannelEndUserEditModel: NSObject {
    var id : Int
    var coverImageWeb : String
    var des : String
    var reason :  String
    var avatarImage : String
    var name : String
    var coverImage : String
    var created_at : String
    var status : Int = 0
    init( _ json : JSON) {
        self.id = json["id"].intValue
        self.coverImageWeb = json["coverImageWeb"].stringValue
        self.des = json["description"].stringValue
        self.avatarImage = json["avatarImage"].stringValue
        self.reason = json["reason"].stringValue
        self.name = json["name"].stringValue
        self.coverImage = json["coverImage"].stringValue
        self.created_at = json["created_at"].stringValue
        self.status = json["status"].intValue
    }
}
