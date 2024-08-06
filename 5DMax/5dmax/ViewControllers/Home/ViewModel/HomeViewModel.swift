//
//  HomeViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

protocol SectionModelDelegate {
    func sectionDidLoadMore()
}

struct HomeViewModel {
    var sections: [HomeSectionModel]
    init() {
        sections = [HomeSectionModel]()
    }

    init(_ groups: [GroupModel]) {
        sections = [HomeSectionModel]()
        for group in groups {
            sections.append(HomeSectionModel(groupModel: group))
        }
    }
    init(_ groups: [GroupModel] , _ series : SeriesModel ) {
        sections = [HomeSectionModel]()
        
        for group in groups {
            sections.append(HomeSectionModel(groupModel: group))
        }
        if series.serries.count  > 0  {
        sections.append(HomeSectionModel(groupModel: GroupModel(series: series)))
        }
    }
    
    init(_ groups: [GroupModel], isShowPrice: Bool = false) {
        sections = [HomeSectionModel]()
        for group in groups {
            sections.append(HomeSectionModel(groupModel: group, isShowPrice: isShowPrice))
        }
    }

    class HomeSectionModel: PBaseSectionModel {
        var title: String
        var identifier: String
        var blockType: BlockType
        var rows: [RowModel]
        var groupId: String = ""
        var delegate: SectionModelDelegate?
        private var service: FilmService = FilmService()
        private var isGettingMoreData: Bool = false
        var isShowPrice: Bool = false

        init() {
            title = ""
            identifier = ""
            blockType = .banner
            rows = [RowModel]()
        }

        init(groupModel: GroupModel) {
            groupId = groupModel.groupId
            blockType = groupModel.blockType
            identifier = self.blockType.sectionIdentifier()
            rows = []
            for model in groupModel.content {
                rows.append(RowModel(blockType: blockType, model: model))
            }
            
            if blockType == .comingsoon, let film = rows.first?.title {
                title = groupModel.name + ": " + film
            } else {
                title = groupModel.name
            }
        }
        
        init(groupModel: GroupModel, isShowPrice: Bool = false) {
            groupId = groupModel.groupId
            blockType = groupModel.blockType
            identifier = self.blockType.sectionIdentifier()
            rows = []
            for model in groupModel.content {
                var rowModel = RowModel(blockType: blockType, model: model)
                rowModel.isShowPrice = isShowPrice
                rows.append(rowModel)
            }
            
            if blockType == .comingsoon, let film = rows.first?.title {
                title = groupModel.name + ": " + film
            } else {
                title = groupModel.name
            }
            self.isShowPrice = isShowPrice
        }
        
        func showHeader() -> Bool {
            switch blockType {
            case .banner:
                return false
            default:
                return true
            }
        }

        func insetForSection() -> UIEdgeInsets {
            return blockType.insetForSection()
        }

        func itemSpacing() -> CGFloat {
            return blockType.itemSpacing()
        }

        func sizeForSection() -> CGSize {
            return blockType.sizeForSection()
        }

        func sizeForItem() -> CGSize {
            var size = blockType.sizeForItem()
            size.height = isShowPrice ? (size.height + 20.0) : size.height
            return size
        }
        
        func doLoadMore(movieType: HomeType) {
            if rows.count >= 8, isGettingMoreData == false  {
                DLog("Do load more")
                
                var isSeries: Bool?
                if movieType == .seariesFilm {
                    isSeries = true
                } else if movieType == .oddFilm {
                    isSeries = false
                }
                
                weak var weakSelf = self
                self.isGettingMoreData = true
                self.service.getCollectionMoreContent(id: groupId, offset: rows.count, limit: kDefaultLimit, isSeries: isSeries) {(model, error) in
                    if error != nil {
                        DLog(error?.localizedDescription)
                    } else if let moreContent = model?.content, let type = weakSelf?.blockType {
                        if moreContent.count > 0 {
                            for film in moreContent {
                                let rowModel = RowModel(blockType: type, model: film)
                                if let strong = weakSelf {
                                    rowModel.isShowPrice = strong.isShowPrice
                                }
                                
                                weakSelf?.rows.append(rowModel)
                            }
                            weakSelf?.delegate?.sectionDidLoadMore()
                        }
                    }
                    weakSelf?.isGettingMoreData = false
                }
            }
        }
    }
}
