
//
//  MyListViewModel.swift
//  MyClip
//
//  Created by hnc on 11/25/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class MyListViewModel: NSObject {
    var sections: [SectionModel]
    var contents: [ContentModel]
    override init() {
        sections = []
        contents = [ContentModel]()
    }
    
    func doUpdateWithData(_ data: [ContentModel]) {
        sections = []
        contents = data
        let listUpload = UploadService.sharedInstance.listVideoUpload
        if !listUpload.isEmpty {
            var section = SectionModel(rows: [])
            for item in listUpload {
                section.rows.append(UploadRowModel(item))
            }
            sections.append(section)
        }
        
        var myVideoSection = SectionModel(rows: [])
        for item in data {
            myVideoSection.rows.append(VideoRowModel(video: item, identifier: MyListTableViewCell.nibName()))
        }
        sections.append(myVideoSection)
    }

    func removeContent(_ model: ContentModel) {
        for index in contents.indices where contents[index].id == model.id {
            contents.remove(at: index)
            break
        }
        doUpdateWithData(contents)
    }
}
