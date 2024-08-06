//
//  MyChannelViewModel.swift
//  UClip
//
//  Created by Toan on 5/19/21.
//  Copyright © 2021 Huy Nguyen. All rights reserved.
//

import UIKit

struct  MyChannelViewModel {
    
      private var _channelDetails: ChannelDetailsModel? = nil
      var sections = [SectionModel]()
      var channelDetails: ChannelDetailsModel? {
          get {
              return _channelDetails
          }
          set {
              _channelDetails = newValue
              if let model = newValue {
                  sections.removeAll()
                  // header section
                let headerModel = ChannelDetailHeaderModel(newValue!)
                 var section = SectionModel(rows: [])
                for channel in model.channels {
                    let channel = MutilChannelModel(model: channel)
                    section.rows.append(channel)
                }
                sections.append(section)
              }
          }
      }
     
   
}
class MyChannelModel: NSObject {
    var sections: [ChannelSectionModel]
     override init() {
        sections = [ChannelSectionModel]()
        let section1 = ChannelSectionModel(title: String.my_Channel.uppercased(), identifier: "myChannel", objectId: "My Channel")
        sections.append(section1)
        let section2 = ChannelSectionModel(title: String.videos.uppercased(), identifier: "videos", objectId: "videos")
        sections.append(section2)
        let section3 = ChannelSectionModel(title: String.danh_sach_phat.uppercased(), identifier: "PlayList", objectId: "PlayList")
        sections.append(section3)
        let section4 = ChannelSectionModel(title: String.kenh.uppercased(), identifier: "channel", objectId: "channel")
        sections.append(section4)
        let section5 = ChannelSectionModel(title: String.gioi_thieu.uppercased(), identifier: "about", objectId: "about")
        sections.append(section5)
    }
}
