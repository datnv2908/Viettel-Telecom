
//
//  SelectChannelViewModel.swift
//  MyClip
//
//  Created by Os on 8/30/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct SelectChannelViewModel {
    var data:[SectionModel] {
        didSet {
            checkChange += 1
        }
    }
    var checkChange = 0
    
    init() {
        data = [SectionModel]()
    }
    
    init(_ model: FollowContentModel) {
        self.data = [SectionModel]()
        var sectionFollow =
            SectionModel(rows: [],
                         header: HeaderModel(title: String.noi_dung_ban_da_chon,
                                             identifier: ChannelHeaderView.nibName()))
        for item in model.channelFollow.channels {
            sectionFollow.rows.append(ChannelRowModel(title: item.name, image: item.avatarImage, identifier: ChannelCollectionViewCell.nibName(), objectId: item.id, isSelected: true))
        }
        var sectionHot =
            SectionModel(rows: [],
                         header: HeaderModel(title: String.noi_dung_de_xuat,
                                             identifier: ChannelHeaderView.nibName()))
        for item in model.channelHot.channels {
            sectionHot.rows.append(ChannelRowModel(title: item.name, image: item.avatarImage, identifier: ChannelCollectionViewCell.nibName(), objectId: item.id, isSelected: false))
        }
        self.data.append(sectionFollow)
        self.data.append(sectionHot)
        self.checkChange = 0
    }
}
