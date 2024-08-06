//
//  UpdateProfileViewModel.swift
//  UClip
//
//  Created by zohan on 6/27/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

struct UpdateProfileViewModel {
    var status : Int = 0
    var avatarImage: String = ""
    var coverImage: String = ""
    var fullName: String = ""
    var description: String = ""
    var id: String = ""
    
    init(model : ChannelEndUserEditModel) {
        self.avatarImage = model.avatarImage
        self.coverImage =  model.coverImage
        self.fullName = model.name
        self.description = model.des
        self.status = model.status
        self.id = String(model.id)
    }
    init(channel : MutilChannelModel) {
        self.id = channel.objectID
    }
    init(model : ChannelModel) {
        self.id = model.id
    }
}
