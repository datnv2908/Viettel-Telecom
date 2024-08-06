//
//  ServicePackageRowModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation

struct ServicePackageRowModel: PBaseRowModel {
    var id: String
    var title: String
    var desc: String
    var shortDesc: String
    var popup: [String]
    var status: Bool
    var fee: Int
    var image: String
    var identifier: String
    var objectID: String
    var freeVideo: Bool
    init(_ dto: PackageModel) {
        self.id = dto.id
        self.title = dto.name
        self.desc = dto.desc
        self.shortDesc = dto.shortDesc
        self.popup = dto.popup
        self.status = dto.status == 1 ? true : false
        self.fee = dto.fee
        self.image = ""
        self.identifier = ServicePackageTableViewCell.nibName()
        self.objectID = ""
      self.freeVideo = false
    }
}
