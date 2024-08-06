//
//  FilmDetailViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/17/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct FilmDetailViewModel {
    
    var title: String = ""
    var desc: String = ""
    var link: String = ""
    var filmRelatedSection: [FilmDetailSectionModel] = []
    var trailerSection: [FilmDetailSectionModel] = []
    var displayType: FilmDetailSectionType = FilmDetailSectionType.related
    var trailerRowModel = RowModel(blockType: .trailer_update, model: nil)
    var relatedRowModel = RowModel(blockType: .related_update, model: nil)
    var detailModel: PlayListModel?
    
    //mark: -- SECTION
    struct FilmDetailSectionModel: PBaseSectionModel {
        var title: String
        var desc: String
        var type: FilmDetailSectionType
        var identifier: String?
        var headerIdentifier: String?
        var rows: [PBaseRowModel]
        init(sectionType: FilmDetailSectionType) {
            title = ""
            desc = ""
            type = sectionType
            identifier = type.identifier()
            headerIdentifier = type.headerIdentifier()
            rows = [PBaseRowModel]()
        }
        
        mutating func setType(sectionType: FilmDetailSectionType) {
            type = sectionType
            identifier = type.identifier()
            headerIdentifier = type.headerIdentifier()
        }
    }
    
    //mark: -- ROW
    struct FilmCoverRowModel: PBaseRowModel {
        var descFilm: String
        var title: String
        var desc: String
        var imageUrl: String
        var identifier: String
        init(_ playListModel: PlayListModel) {
            title = playListModel.detail.name
            desc = ""
            imageUrl = playListModel.detail.coverImage
            identifier = ""
            descFilm  = ""
        }
    }

    struct FilmTitleRowModel: PBaseRowModel {
        var descFilm: String
        var title: String
        var desc: String
        var yearofProduct: String
        var metaData: String = ""
        var imageUrl: String
        var identifier: String
        var price: String
        var rating: String
        var country: String
        var buyStatusText: String
        var extraDesc: String
        
        init(_ playListModel: PlayListModel) {
            title = playListModel.detail.name
            if !playListModel.detail.yearOfProduct.isEmpty {
                metaData += playListModel.detail.yearOfProduct
            }

            if !playListModel.detail.contentFilter.isEmpty {
                metaData += "       " + playListModel.detail.contentFilter
            }
            if playListModel.detail.attributes == .retail {
                if !playListModel.detail.duration.isEmpty {
                    metaData += "       " + playListModel.detail.duration + "m"
                }
            } else if !playListModel.lisSeasons.isEmpty {
                
                metaData += "       \(playListModel.lisSeasons.count) " + String.seasons
            } else {
                metaData += "       \(playListModel.parts.count) " + String.tap
            }
            desc = playListModel.detail.desc
            descFilm = ""
            yearofProduct = playListModel.detail.yearOfProduct
            imageUrl = playListModel.detail.avatarImage
            identifier = ""
            price = playListModel.video.price_play
            rating = playListModel.detail.imdb
            country = playListModel.detail.country
            buyStatusText = playListModel.detail.buyStatusText
            extraDesc = playListModel.detail.extra_description
        }
        
        func attributedDescription() -> NSAttributedString {
            let font = AppFont.museoSanFont(style: .regular, size: 13.0)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.0
            paragraphStyle.lineBreakMode = .byTruncatingTail
            let attributedText = NSAttributedString(string: desc,
                                                    attributes: [NSAttributedString.Key.font: font,
                                                                 NSAttributedString.Key.foregroundColor: UIColor.colorFromHexa("e6e6e6"),
                                                                 NSAttributedString.Key.paragraphStyle: paragraphStyle])
            return attributedText
        }
    }

    struct FilmPriceRowModel: PBaseRowModel {
        var descFilm: String
        var title: String
        var desc: String
        var imageUrl: String
        var identifier: String
        
        init(_ playListModel: PlayListModel) {
            title = playListModel.detail.name
            desc = ""
            imageUrl = playListModel.detail.coverImage
            identifier = ""
            descFilm = ""
        }
    }

    struct FilmInfoRowModel: PBaseRowModel {
        var descFilm: String
        var title: String
        var desc: String
        var imageUrl: String
        var identifier: String
        var actor: String
        var directors: String
        var category: String
        var nation: String
        var rating: String
        var isFavourite: Bool
        
        init(_ playListModel: PlayListModel) {
            title = ""
            desc = playListModel.detail.desc
            imageUrl = playListModel.detail.coverImage
            identifier = ""
            isFavourite = playListModel.detail.isFavourite
            let actors = playListModel.detail.actorInfo.map({$0.name})
            actor = String.init(format: "%@: %@", String.dien_vien, actors.joined(separator: ", "))
            
            let dNames = playListModel.detail.directorInfo.map({$0.name})
            directors = String.init(format: "%@: %@", String.directors, dNames.joined(separator: ", "))
            
            let categories = playListModel.detail.categories.map({$0.name})
            category = String.init(format: "%@: %@", String.the_loai, categories.joined(separator: ", "))
            let nations = playListModel.detail.nationInfo.map({$0.name})
            nation = String.init(format: "%@: %@", String.quoc_gia, nations.joined(separator: ", "))
            rating = String.init(format: "%@: %@", String.danh_gia, playListModel.detail.imdb)
            descFilm = ""
        }
    }

    struct FilmSeasonRowModel: PBaseRowModel {
        var descFilm: String
        
        var title: String
        var desc: String
        var imageUrl: String
        var identifier: String
        var currentIndex: Int = 0
        var currentImageUrl: String = ""
        var currentAlias: String = ""
        var currentDuration: String = ""
        var currentDescription: String = ""
        var parts: [PartRowModel]

        init(_ playListModel: PlayListModel) {
            title = String.season_1
            desc = ""
            imageUrl = ""
            identifier = ""

            let filteredParts = playListModel.parts.filter { (model) -> Bool in
                return model.partId == playListModel.detail.getCurrentVideoId()
            }
            if let part = filteredParts.first {
                currentIndex = playListModel.parts.index(of: part) ?? 0
                currentAlias = part.name
                currentImageUrl = part.coverImage
                currentDuration = String.init(format: "%dm", part.duration/60)
                currentDescription = part.desc
            }

            parts = [PartRowModel]()
            for index in playListModel.parts.indices {
                let rowModel = PartRowModel(index, index == currentIndex)
                parts.append(rowModel)
            }
            descFilm = ""
        }
    }
    
    struct FilmSeasonPartRowModel: PBaseRowModel {
        var title: String = ""
        var desc: String = ""
        var imageUrl: String = ""
        var identifier: String = "FilmPartNumberCollectionViewCell"
        var part: PartModel
        var descFilm : String = ""
        init(_ item: PartModel) {
            title       = item.name
            desc        = "\(Int(item.duration/60))" + "m"
            imageUrl    = item.coverImage
            part        = item
            descFilm    = item.filmDesc
        }
    }
    
    init() {
        title = ""
        desc = ""
        link = ""
    }

    init(_ playListModel: PlayListModel ,_ lisRelateSeries : [PartModel]?) {
        
        detailModel = playListModel
        title = playListModel.detail.name
        desc = playListModel.detail.desc
        link = playListModel.detail.link
        filmRelatedSection = [FilmDetailSectionModel]()
        // cover section
        var coverSection = FilmDetailSectionModel(sectionType: .cover)
        coverSection.rows.append(FilmCoverRowModel(playListModel))
        filmRelatedSection.append(coverSection)

        // title section
        var titleSection = FilmDetailSectionModel(sectionType: .rate)
        titleSection.rows.append(FilmTitleRowModel(playListModel))
        filmRelatedSection.append(titleSection)
        
        if DataManager.isLoggedIn() {
            if let popup = playListModel.stream.popup, popup.canView == false {
                if !popup.isRegisterSub && (popup.isBuyPlaylist || popup.isBuyVideo) {
                    var priceSection = FilmDetailSectionModel(sectionType: .price)
                    priceSection.rows.append(FilmTitleRowModel(playListModel))
                    filmRelatedSection.append(priceSection)
                }
            }
        } else {
            if playListModel.detail.subscription_type == .typeRent, let popup = playListModel.stream.popup, popup.canView == false {
                var priceSection = FilmDetailSectionModel(sectionType: .price)
                priceSection.rows.append(FilmTitleRowModel(playListModel))
                filmRelatedSection.append(priceSection)
            }
        }
        
        if !playListModel.detail.extra_description.isEmpty {
            var filmDescSection = FilmDetailSectionModel(sectionType: .extraDesc)
            filmDescSection.rows.append(FilmTitleRowModel(playListModel))
            filmRelatedSection.append(filmDescSection)
        }
        
        var filmDescSection = FilmDetailSectionModel(sectionType: .desc)
        filmDescSection.rows.append(FilmTitleRowModel(playListModel))
        filmRelatedSection.append(filmDescSection)

        // description section
        var descSection = FilmDetailSectionModel(sectionType: .infor)
        descSection.rows.append(FilmInfoRowModel(playListModel))
        filmRelatedSection.append(descSection)
        trailerSection.append(contentsOf: filmRelatedSection)
        
        var trailerSec = FilmDetailSectionModel(sectionType: .trailer)
        trailerSec.title = String.trailers.uppercased()
        
        var relatedUpdate = FilmDetailSectionModel(sectionType: .related_update)
        
        if playListModel.detail.attributes == .series || playListModel.notSeries == 0 {
            var seasonSection = FilmDetailSectionModel(sectionType: .part)
            seasonSection.title = String.danh_sach_tap.uppercased()
            trailerSec.title = String.danh_sach_tap.uppercased()
            
            if let models = lisRelateSeries, !models.isEmpty {
                for item in  models {
                    seasonSection.rows.append(FilmSeasonPartRowModel(item))
                }
                
                filmRelatedSection.append(seasonSection)
            } else {
                let rowModel = RowModel(blockType: .related_update, model: nil)
                rowModel.title = String.dang_cap_nhat
                relatedUpdate.rows.append(rowModel)
                relatedUpdate.title = String.danh_sach_tap.uppercased()
                filmRelatedSection.append(relatedUpdate)
            }
        } else {
            // related films
            var relatedSection = FilmDetailSectionModel(sectionType: .related)
            
            relatedSection.title = String.phim_lien_quan.uppercased()
            trailerSec.title = String.phim_lien_quan.uppercased()
            relatedUpdate.title = String.phim_lien_quan.uppercased()
            if playListModel.related.content.count > 0 {
                if playListModel.related.content.count > 0 {
                    for filmModel in playListModel.related.content {
                        if relatedSection.rows.count < 12 {
                            let rowModel = RowModel(blockType: .film, model: filmModel)
                            relatedSection.rows.append(rowModel)
                        }
                    }
                }
                filmRelatedSection.append(relatedSection)
            } else {
                let rowModel = RowModel(blockType: .related_update, model: nil)
                rowModel.title = String.dang_cap_nhat
                relatedUpdate.rows.append(rowModel)
                filmRelatedSection.append(relatedUpdate)
            }
            //filmRelatedSection.append(relatedSection)
            //filmRelatedSection.append(relatedUpdate)
        }
        
        //trailer films
        if let trailer = playListModel.trailers {
            trailerRowModel.imageUrl = trailer.coverImage
            trailerRowModel.title = trailer.name
            trailerRowModel.desc = trailer.descriptionTrailer
            trailerRowModel.contentType = .trailer
           trailerSec.setType(sectionType: .trailer)
        } else {
            trailerRowModel.contentType = .trailerUpdate
            trailerSec.setType(sectionType: .trailer_Update)
        }
        
        trailerSec.rows.append(trailerRowModel)
        trailerSection.append(trailerSec)
    }
    
    mutating func doUpdateTrailer(_ trailer: TrailersModel) {
        self.trailerRowModel.title = trailer.name
        self.trailerRowModel.imageUrl = trailer.coverImage
    }
    
    var sections: [FilmDetailSectionModel] {
        return displayType == .trailer ? trailerSection : filmRelatedSection
    }
    
    var trailer: TrailersModel? {
        return detailModel?.trailers
    }
}
