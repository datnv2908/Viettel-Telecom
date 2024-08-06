//
//  ChannelViewModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/21/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

class ChannelViewModel: NSObject {
    var sections: [ChannelSectionModel]
    var channelModel: ChannelModel
    
    init(_ model: ChannelModel) {
      channelModel = model
      sections = [ChannelSectionModel]()
      let section1 = ChannelSectionModel(title: String.trang_chu.uppercased(), identifier: "", objectId: "home")
      sections.append(section1)
      
      let section2 = ChannelSectionModel(title: String.videos.uppercased(), identifier: "", objectId: "videos")
      sections.append(section2)
      let section5 = ChannelSectionModel(title: String.gioi_thieu.uppercased(), identifier: "", objectId: "about")
      sections.append(section5)
    }
}
