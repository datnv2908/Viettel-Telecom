//
//  EditMyChannelViewModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct EditMyChannelViewModel {
    var avatarImage: String = ""
    var coverImage: String = ""
    var fullName: String = ""
    var description: String = ""
    var id: String = ""
    var status :Int = 0
    var reason : String = ""

    init() {
        if DataManager.isLoggedIn() {
            guard let model = DataManager.getCurrentMemberModel() else {return}
            avatarImage = model.avatarImage
            coverImage = model.coverImage
            fullName = model.fullName
            description = model.desc
            id = model.userId
           
        }
      
    }
   init(channel : MutilChannelModel) {
       self.id = channel.objectID
   }
   init(model : ChannelModel) {
       self.id = model.id
   }
   init(model : ChannelEndUserEditModel) {
       self.avatarImage = model.avatarImage
       self.coverImage =  model.coverImage
       self.fullName = model.name
       self.description = model.des
       self.status = model.status
       self.id = String(model.id)
       self.status = model.status
       self.reason = model.reason
   }
}
