//
//  PlaylistDTO.swift
//  5dmax
//
//  Created by Admin on 3/16/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class PlaylistDTO: NSObject {
    var detail: FilmDetailDTO
    var parts: [PartDTO]
    var related: GroupDTO
    var currentTime: Int
    var stream: StreamDTO
    var price: PriceDTO
    var trailers: TrailersDTO?
    var listSeason : [SeasonDTO]
    var idSeasonSelected: Int?
    var notSeries: Int?
    var desc : String
    var  idNextSeason : Int?
    var preVideoID : Int?
    init(_ json: JSON) {
        detail = FilmDetailDTO(json["detail"])
        parts = []
        for (_, subJson) in json["parts"] {
            parts.append(PartDTO(subJson))
        }
        related = GroupDTO(json["relateds"])
        currentTime = json["currentTime"].intValue
        stream = StreamDTO(json["streams"])
        price = PriceDTO(json["video"])
        idSeasonSelected = json["id_season_selected"].intValue
        notSeries = json["not_series"].intValue
        desc = json["description"]["description"].stringValue
        listSeason = []
        for (_, subJson) in json["list_season"] {
            listSeason.append(SeasonDTO(subJson))
        }
        if (json["trailers"].isEmpty == false) {
            trailers = TrailersDTO(json["trailers"])
        }
        idNextSeason = json["id_next_season"].intValue
        preVideoID = json["id_pre_season"].intValue
    }
}
