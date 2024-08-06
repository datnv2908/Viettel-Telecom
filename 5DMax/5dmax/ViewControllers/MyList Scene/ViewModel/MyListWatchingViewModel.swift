//
//  MyListWatchingViewModel.swift
//  5dmax
//
//  Created by Os on 4/14/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit
class MyListWatchingViewModel: NSObject {
    var myList: MyListWatching
    var isEdit: Bool = false
    override init() {
        myList = MyListWatching()
    }
    init(_ groupModel: GroupModel) {
        myList = MyListWatching(groupModel)
    }
    struct MyListWatching: PBaseSectionModel {
        var title: String
        var type: BlockType
        var rows: [RowModel]

        init() {
            title = ""
            type = .film
            rows = [RowModel]()
        }

        init(_ groupModel: GroupModel) {
            title = groupModel.name
            type = groupModel.blockType
            rows = [RowModel]()
            for filmModel in groupModel.content {
                rows.append(RowModel(blockType: type, model: filmModel))
            }
        }
    }

    func appendContent(_ filmModels: [FilmModel]) {
        for filmModel in filmModels {
            self.myList.rows.append(RowModel(blockType: myList.type, model: filmModel))
        }
    }
}
