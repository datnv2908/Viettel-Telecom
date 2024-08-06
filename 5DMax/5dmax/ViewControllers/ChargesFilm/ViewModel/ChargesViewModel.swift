//
//  ChargesViewModel.swift
//  5dmax
//
//  Created by admin on 8/20/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct ChargesViewModel {
    var sections: [ChargesSectionModel]
    init() {
        sections = [ChargesSectionModel]()
    }
    
    init(_ groups: [GroupModel]) {
        sections = [ChargesSectionModel]()
        for group in groups {
            sections.append(ChargesSectionModel(groupModel: group))
        }
    }
    
    struct ChargesSectionModel: PBaseSectionModel {
        var title: String
        var identifier: String
        var blockType: BlockType
        var rows: [RowModel]
        init() {
            title = ""
            identifier = ""
            blockType = .film
            rows = [RowModel]()
        }
        
        init(groupModel: GroupModel) {
            title = groupModel.name
            blockType = groupModel.blockType
            identifier = self.blockType.sectionIdentifier()
            rows = []
            for model in groupModel.content {
                rows.append(RowModel(blockType: blockType, model: model))
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
            return blockType.sizeForItem()
        }
    }
}
