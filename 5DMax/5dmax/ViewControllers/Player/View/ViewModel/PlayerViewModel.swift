//
//  PlayerViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 4/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct PlayerViewModel {
    var playListModel: PlayListModel?
    var filmModel: FilmModel?
    var trailerStream: StreamModel?
    var coverImage: String?
    var trailer: TrailersModel?
    var filmName: String?
    var fromNoti : Bool = false
    var sendView : Bool = false
    init() {

    }

    init(_ model: PlayListModel , fromNoti: Bool ,sendView : Bool) {
        playListModel = model
        coverImage = model.detail.coverImage
        self.fromNoti = fromNoti
        self.sendView = sendView
    }

    init(_ model: FilmModel, fromNoti: Bool,sendView : Bool) {
        filmModel = model
        coverImage = model.coverImage
        self.fromNoti = fromNoti
        self.sendView = sendView
    }
    
    init(trailerModel: TrailersModel?, stream: StreamModel,fromNoti: Bool) {
        self.trailer = trailerModel
        self.trailerStream = stream
        coverImage = trailerModel?.coverImage
        self.fromNoti = fromNoti
        self.sendView = false
    }
    
    func isShowEpisodeButton() -> Bool {
        if let model = playListModel {
            if model.detail.attributes == .series {
                return true
            }
        }
        return false
    }

    func currentPartIndex() -> Int? {
        if let model = playListModel {
            for (index, item ) in model.parts.enumerated() {
                if item.partId == model.detail.getCurrentVideoId() {
                    return index
                }
            }
        }
        return nil
    }
    
    func nextPart() -> PartModel? {
        if let model = playListModel {
            for (index, item) in model.parts.enumerated() {
                if item.partId == model.detail.getCurrentVideoId() {
                    if model.parts.indices.contains(index + 1) {
                        return model.parts[index + 1]
                    }
                }
            }
        }
        return nil
    }
    func previousPart() -> PartModel? {
        if let model = playListModel {
            for (index, item) in model.parts.enumerated() {
                if item.partId == model.detail.getCurrentVideoId() {
                       if model.parts.indices.contains(index - 1) {
                           return model.parts[index - 1]
                       }
                   }
               }
           }
           return nil
       }
    func nextSeriesID() -> Int {
        return (playListModel?.idNextSeason)!
    }
    func previousSeriesID() -> Int {
        return (playListModel?.preVideoID)!
    }
    func playerName() -> String {
        if let str = filmName, str.isEmpty == false {
            return str
        }
        
        if let model = playListModel {
            if model.detail.attributes == .retail {
                return model.detail.name
            } else {
                if let currentPartIndex = currentPartIndex() {
                    return model.parts[currentPartIndex].name
                } else {
                    return model.detail.name
                }
            }
        }

        if let model = filmModel {
            return model.name
        }
        
        if let model = trailer {
            return model.name
        }
        return ""
    }
    
    var kpiToken: String? {
        didSet {
            if let value = kpiToken {
                kpiModel = KPIModel(with: value)
            }
        }
    }
    var kpiModel: KPIModel?
}
