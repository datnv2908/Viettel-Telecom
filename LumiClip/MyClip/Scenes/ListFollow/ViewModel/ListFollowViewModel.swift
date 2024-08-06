//
//  ListFollowViewModel.swift
//  MyClip
//
//  Created by Huy Nguyen on 9/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct ListFollowViewModel: SimpleTableViewModelProtocol {
    var rows: [FollowRowModel]
    var data: [PBaseRowModel] {
        get {
            return rows
        }
        set {
            
        }
    }
    init() {
        rows = [FollowRowModel]()
        data = [PBaseRowModel]()
    }
    mutating func toggleFollow(at index: Int) {
        for (i, _) in data.enumerated() where index == i {
            rows[i].isFollow = !rows[i].isFollow
        }
    }
}
