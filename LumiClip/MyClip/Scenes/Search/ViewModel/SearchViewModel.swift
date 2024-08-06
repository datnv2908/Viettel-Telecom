//
// Created by VIPER
// Copyright (c) 2017 VIPER. All rights reserved.
//

import Foundation
import UIKit

class SearchViewModel: NSObject {
    var title: String? = "SearchViewController"
    var currentKeyword: String = ""
    var isShowAllChannel: Bool = false
    var searchType: SearchType = SearchType.history
    var data = [SectionModel]()
    var listKeyword = [String]()
    var listSearchHistory = [SearchRealmModel]()
    var listSearchResult = [GroupModel]()
    var listSearchSuggest = [SearchGroupModel]()
}

extension SearchViewModel: SearchViewModelInput {
    func updateWithHistoriesSearch(data: [SearchRealmModel]) {
        self.data = []
        var section = SectionModel(rows: [])
        for model in data {
            section.rows.append(RowModel(title: model.keyword,
                                         identifier: SearchTableViewCell.nibName()))
        }
        self.data.append(section)
        searchType = .history
        listSearchHistory = data
    }
    
    func updateWithKeyword(data: [String]) {
        self.data = []
        var section = SectionModel(rows: [])
        for model in data {
            section.rows.append(RowModel(title: model,
                                         identifier: KeywordTableViewCell.nibName()))
        }
        self.data.append(section)
        searchType = .keyword
        listKeyword = data
    }
    
    func updateWithSearchResult(data: [GroupModel]) {
        self.data = []
        for item in data {
            var section = SectionModel(rows: [], header: HeaderModel(title: item.name, identifier: NormalHeaderView.nibName()))
            if item.groupType == .channel {
                if item.channels.count > 3 {
                    for index in 0 ..< 3 {
                        let model = item.channels[index]
                        section.rows.append(ChannelRowModel(title: model.name, desc: String(model.num_follow), image: model.coverImage, identifier: NormalChannelTableViewCell.nibName(),
                                                            numberRegister: model.num_follow))
                    }
                    section.rows.append(RowModel(title: "", desc: "", image: "", identifier: LoadMoreTableViewCell.nibName()))
                } else {
                    for model in item.channels {
                        section.rows.append(ChannelRowModel(title: model.name, desc: String(model.num_follow), image: model.coverImage, identifier: NormalChannelTableViewCell.nibName(),
                                                            numberRegister: model.num_follow))
                    }
                }
            } else if item.groupType == .video {
                if item.videos.count > 3 {
                    for index in 0 ..< 3 {
                        let model = item.videos[index]
                        section.rows.append(VideoRowModel(video: model, identifier: VideoSmallImageTableViewCell.nibName()))
                    }
                    section.rows.append(RowModel(title: "", desc: "", image: "", identifier: LoadMoreTableViewCell.nibName()))
                } else {
                    for model in item.videos {
                        section.rows.append(VideoRowModel(video: model, identifier: VideoSmallImageTableViewCell.nibName()))
                    }
                }
            } else if item.type == GroupType.search.rawValue { // trs: for ////search-suggestion-v2////
                for model in item.videos {
                    if model.type == ContentType.channel.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName(), num_video: model.num_video, num_follow: model.num_follow, isShowAllData: true))
                    }else if model.type == ContentType.video.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName(), timeUpload: model.published_time, id: "", channel_id: model.channel_id, channel_name: model.channel_name, viewNumber:Int(model.play_times) ?? 0, isShowAllData: true))
                    }
                }
            }
            if section.rows.count > 0 {
                self.data.append(section)
            }
        }
        searchType = .search
        listSearchResult = data
    }
    
    func updateWithSearchSuggest(data: [SearchGroupModel]) {
        self.data = []
        for item in data {
            var section = SectionModel(rows: [], header: HeaderModel(title: item.name, identifier: NormalHeaderView.nibName()))
            
            if item.type == GroupType.channel.rawValue {
                if item.contents.count > 3 {
                    for index in 0 ..< 3 {
                        let model = item.contents[index]
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName()))
                    }
                    section.rows.append(RowModel(title: "", desc: "", image: "", identifier: LoadMoreTableViewCell.nibName()))
                } else {
                    for model in item.contents {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName()))
                    }
                }
            } else if item.type == GroupType.video.rawValue {
                
                if item.contents.count > 3 {
                    for index in 0 ..< 3 {
                        let model = item.contents[index]
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName()))
                    }
                    section.rows.append(RowModel(title: "", desc: "", image: "", identifier: LoadMoreTableViewCell.nibName()))
                } else {
                    for model in item.contents {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName()))
                    }
                }
            } else if item.type == GroupType.search.rawValue { // trs: for ////search-suggestion-v2////
                for model in item.contents {
                    if model.type == ContentType.channel.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName()))
                    }else if model.type == ContentType.video.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName()))
                    }
                }
            }
            self.data.append(section)
        }
        searchType = .searchSuggest
        listSearchSuggest = data
    }
    
    func updateWithSearchMoreResult(data: [GroupModel]) {
        for item in data {
            var section = SectionModel(rows: [], header: HeaderModel(title: item.name, identifier: NormalHeaderView.nibName()))
            if self.data.count > 0 {
                section = self.data[0]
            }
            
            if item.type == GroupType.search.rawValue { // trs: for ////search-suggestion-v2////
                for model in item.videos {
                    if model.type == ContentType.channel.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName(), num_video: model.num_video, num_follow: model.num_follow, isShowAllData: true))
                    }else if model.type == ContentType.video.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName(), timeUpload: model.published_time, id: "", channel_id: model.channel_id, channel_name: model.channel_name, viewNumber:Int(model.play_times) ?? 0, isShowAllData: true))
                    }
                }
            }
            if section.rows.count > 0 {
                self.data = []
                self.data.append(section)
            }
        }
        listSearchResult = data
    }
    
    func updateWithSearchMoreSuggest(data: [SearchGroupModel]) {
        for item in data {
            var section = SectionModel(rows: [], header: HeaderModel(title: item.name, identifier: NormalHeaderView.nibName()))
            if self.data.count > 0 {
                section = self.data[0]
            }
            if item.type == GroupType.search.rawValue { // trs: for ////search-suggestion-v2////
                for model in item.contents {
                    if model.type == ContentType.channel.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName()))
                    }else if model.type == ContentType.video.rawValue {
                        section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName()))
                    }
                }
            }
            
            self.data = []
            self.data.append(section)
        }
        listSearchSuggest = data
    }
    
    func doUpdateWithLoadMore(at groupIndex: Int) {
        if searchType == .search {
            for index in 0 ..< self.listSearchResult.count {
                let item = self.listSearchResult[index]
                var section = SectionModel(rows: [], header: HeaderModel(title: item.name, identifier: NormalHeaderView.nibName()))
                if item.groupType == .channel {
                    if index == groupIndex {
                        for model in item.channels {
                            section.rows.append(ChannelRowModel(title: model.name, desc: String(model.num_follow), image: model.coverImage, identifier: NormalChannelTableViewCell.nibName(),
                                                                numberRegister: model.num_follow))
                        }
                        self.data.remove(at: index)
                        self.data.insert(section, at: index)
                    }
                } else if item.groupType == .video {
                    if index == groupIndex {
                        for model in item.videos {
                            section.rows.append(VideoRowModel(video: model, identifier: VideoSmallImageTableViewCell.nibName()))
                        }
                        
                        self.data.remove(at: index)
                        self.data.insert(section, at: index)
                    }
                }
            }
        } else if searchType == .searchSuggest {
            for index in 0 ..< self.listSearchSuggest.count {
                let item = self.listSearchSuggest[index]
                var section = SectionModel(rows: [], header: HeaderModel(title: item.name, identifier: NormalHeaderView.nibName()))
                if item.type == GroupType.channel.rawValue {
                    if index == groupIndex {
                        for model in item.contents {
                            section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: NormalChannelTableViewCell.nibName()))
                        }
                        self.data.remove(at: index)
                        self.data.insert(section, at: index)
                    }
                } else if item.type == GroupType.video.rawValue {
                    if index == groupIndex {
                        for model in item.contents {
                            section.rows.append(RowModel(title: model.name, desc: "", image: model.coverImage, identifier: VideoSmallImageTableViewCell.nibName()))
                        }
                        self.data.remove(at: index)
                        self.data.insert(section, at: index)
                    }
                }
                
            }
        }
    }
}

extension SearchViewModel: SearchViewModelOutput {
    func getTitle() -> String? {
        return title
    }
}
