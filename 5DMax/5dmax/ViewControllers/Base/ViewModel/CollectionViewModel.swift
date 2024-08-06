//
//  CollectionViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct CollectionViewModel {
    var section: CollectionSectionModel
    init() {
        section = CollectionSectionModel()
    }
    init(_ groupModel: GroupModel) {
        section = CollectionSectionModel(groupModel)
    }

    mutating func appendContent(_ filmModels: [FilmModel]) {
        for filmModel in filmModels {
            self.section.rows.append(RowModel(blockType: section.type, model: filmModel))
        }
    }

    struct CollectionSectionModel: PBaseSectionModel {
        var title: String
        var type: BlockType
        var rows: [RowModel]
        var moreContentType = MoreContentType.film

        init() {
            title = ""
            type = .film
            rows = [RowModel]()
        }

        init(_ groupModel: GroupModel) {
            title = groupModel.name
            type = groupModel.blockType
            moreContentType = MoreContentType(rawValue: type.rawValue) ?? .film
            rows = [RowModel]()
            for filmModel in groupModel.content {
                rows.append(RowModel(blockType: type, model: filmModel))
            }
        }

        func showHeader() -> Bool {
            return false
        }

        func insetForSection() -> UIEdgeInsets {
            return type.insetForSection()
        }

        func itemSpacing() -> CGFloat {
            return type.itemSpacing()
        }

        func sizeForSection() -> CGSize {
            return type.sizeForSection()
        }

        func sizeForItem() -> CGSize {
            return type.sizeForItem()
        }
    }
}
