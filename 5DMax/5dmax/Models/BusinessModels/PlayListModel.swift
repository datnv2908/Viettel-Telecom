//
//  PlayListModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class PlayListModel: NSObject {

    var detail: FilmDetailModel
    var parts: [PartModel]
    var related: GroupModel
    var currentTime: Int
    var stream: StreamModel
    var video: PriceModel
    var trailers: TrailersModel?
    var lisSeasons = [SeasonDTO]()
    var isSeasonFilm : Bool = false
    var seasonIndex : Int = 0
    var idSeasonSelected: Int?
    var notSeries: Int?
    var descSerri : String
    var preVideoID : Int?
    var idNextSeason : Int?
    
    init(_ dto: PlaylistDTO) {
        detail = FilmDetailModel(dto.detail)
        parts = []
        isSeasonFilm = false
        for partDTO in dto.parts {
            parts.append(PartModel(partDTO))
        }
    
//        seasonIndex = detail
        related = GroupModel(dto.related)
        currentTime = dto.currentTime
        idSeasonSelected = dto.idSeasonSelected
        notSeries = dto.notSeries
        stream = StreamModel(dto.stream)
        video = PriceModel(dto.price)
       
        if let item = dto.trailers {
            trailers = TrailersModel(item)
        }
        descSerri = dto.desc
        for season in dto.listSeason {
            lisSeasons.append(SeasonDTO(season))
        }
        if self.lisSeasons.count > 0 {
            isSeasonFilm = true
            
        }else{
            isSeasonFilm = false
        }
        idNextSeason = dto.idNextSeason
        preVideoID = dto.preVideoID
    }

    func choosePartAtIndex(_ index: Int) {
        if index < 0 || index > parts.count - 1 {
            return
        }
        detail.setCurrentVideoId(parts[index].partId)
    }
    
    func isDRMContent() -> Bool {
        if detail.drmContent != nil {
            return true
        } else {
            return false
        }
    }
}
