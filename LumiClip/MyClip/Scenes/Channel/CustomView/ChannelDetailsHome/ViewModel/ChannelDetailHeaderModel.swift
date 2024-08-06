//
//  ChannelDetailHeaderModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct ChannelDetailHeaderModel: PBaseHeaderModel {
    var title: String
    var identifier: String?
    var coverImage: String
    var avatarImage: String
    var isFollow: Bool
    var followCount: Int
    var isReceiveNotitication: Bool
    
    init(_ detail: ChannelDetailsModel) {
        title = detail.name
        identifier = ChannelDetailsHeaderView.nibName()
        coverImage = detail.coverImage
        avatarImage = detail.avatarImage
        isFollow = detail.isFollow
        followCount = detail.numFollow
        isReceiveNotitication = detail.notificationType == .always || detail.notificationType == .sometimes
    }
}
