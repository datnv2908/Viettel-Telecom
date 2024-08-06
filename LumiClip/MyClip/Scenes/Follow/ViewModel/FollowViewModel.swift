//
//  FollowViewModel.swift
//  MyClip
//
//  Created by Os on 9/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class FollowViewModel: SimpleTableViewModelProtocol {
    var channelFollows = [RowModel]()
    var data = [PBaseRowModel]()
    var title = String.theo_doi
    func update(channels: [ChannelModel], isAddEmty: Bool) {
        channelFollows.removeAll()
        for item in channels {
            channelFollows.append(RowModel(title: item.name,
                                           desc: item.desc,
                                           image: item.avatarImage,
                                           identifier: ChannelFollowCollectionViewCell.nibName()))
        }
        if(isAddEmty){
            channelFollows.append(RowModel(title: "",
                                       desc: "",
                                       image: "",
                                       identifier: ChannelFollowCollectionViewCell.nibName()))
        }
    }
}
