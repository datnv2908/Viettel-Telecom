//
//  PlaylistRowModel.swift
//  MyClip
//
//  Created by Os on 9/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON
struct PlaylistRowModel: PBaseRowModel {
    var title: String
    var desc: String
    var image: String
    var identifier: String
    var objectID: String
    var numberVideo: Int
    var viewsCount: Int
    var isOfficial: Bool
    var freeVideo: Bool
    init(_ playlist: PlaylistModel) {
        self.objectID = playlist.id
        self.title = playlist.name
        self.desc = "\(playlist.numberVideo) \(String.video.lowercased())"
        self.image = playlist.coverImage
        self.identifier = PlaylistTableViewCell.nibName()
        self.numberVideo = playlist.numberVideo
       self.viewsCount  = 0
         isOfficial = playlist.isOfficial
      if playlist.pricePlay == "" {
         self.freeVideo = true
      }else{
         self.freeVideo = false
      }
    }
   init(_ mutilChannelModel : MutilChannelModel) {
       self.title = mutilChannelModel.title
       self.desc = mutilChannelModel.desc
       self.image = mutilChannelModel.path
       self.identifier = ""
       self.objectID = mutilChannelModel.objectID
       self.numberVideo = mutilChannelModel.videoCount
       self.viewsCount = mutilChannelModel.viewCount
        isOfficial = mutilChannelModel.isOfficial
      self.freeVideo = mutilChannelModel.freeVideo
   }
   init(_ model : ContentModel) {
       self.numberVideo = Int(model.num_video) ?? 0
       self.title = model.name
       self.image = model.coverImage
       self.desc = model.desc
       self.objectID = model.id
       self.isOfficial = false
       self.viewsCount = 0
       self.image = ""
       self.identifier = PlaylistTableViewCell.nibName()
      self.freeVideo = model.freeVideo
   }
}
