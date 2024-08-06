//
//  ChannelDetailsHomeViewModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/26/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct ChannelDetailsHomeViewModel {
    var channelModel: ChannelModel
    private var _channelDetails: ChannelDetailsModel? = nil
    var channelDetails: ChannelDetailsModel? {
        get {
            return _channelDetails
        }
        set {
            _channelDetails = newValue
            if let model = newValue {
                sections.removeAll()
                // header section
                let rowLoadMore = RowModel(title: "", desc: "", image: "", identifier: WatchMoreTableViewCell.nibName())
                let headerModel = ChannelDetailHeaderModel(newValue!)
                sections.append(SectionModel(rows: [], header: headerModel))
                // newest section
                let newestHeader = HeaderModel(title: model.newestVideo.name,
                                              identifier: ChannelDetailVideoGroupHeaderView.nibName())
                var newestRows = [PBaseRowModel]()
                for (_, item) in model.newestVideo.videos.enumerated() {
                    newestRows.append(VideoRowModel(video: item,
                                                    identifier: VideoSmallImageTableViewCell.nibName()))
                }
                if !newestRows.isEmpty {
                    newestRows.append(rowLoadMore)
                    sections.append(SectionModel(rows: newestRows, header: newestHeader))
                }
                // most view section
                let mostViewHeader = HeaderModel(title: model.mostViewVideo.name,
                                                 identifier: ChannelDetailVideoGroupHeaderView.nibName())
                var mostViewRows = [PBaseRowModel]()
                for (_, item) in model.mostViewVideo.videos.enumerated() {
                    mostViewRows.append(VideoRowModel(video: item,
                                                    identifier: VideoSmallImageTableViewCell.nibName()))
                }
                if !mostViewRows.isEmpty {
                    mostViewRows.append(rowLoadMore)
                    sections.append(SectionModel(rows: mostViewRows, header: mostViewHeader))
                }
            }
        }
    }
    init(_ model: ChannelModel) {
        channelModel = model
    }
    var sections = [SectionModel]()
    func contentModel(at indexPath: IndexPath) -> ContentModel? {
        if indexPath.section == 1 {
            if((channelDetails?.newestVideo.videos.count)! > 0){
                return channelDetails?.newestVideo.videos[indexPath.row]
            }
            return nil
        } else if indexPath.section == 2 {
            if((channelDetails?.mostViewVideo.videos.count)! > 0){
                return channelDetails?.mostViewVideo.videos[indexPath.row]
            }
            return nil
        } else {
            return nil
        }
    }
}
