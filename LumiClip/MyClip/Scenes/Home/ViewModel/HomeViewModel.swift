//
//  HomeViewModel.swift
//  MyClip
//
//  Created by Os on 8/28/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    var data: [HomeSectionModel]
    var listChannel = [ChannelModel]()
    var oldList: [HomeSectionModel]
    override init() {
        data = [HomeSectionModel]()
        oldList = [HomeSectionModel]()
        let section1 = HomeSectionModel(title: String.de_xuat, identifier: "",
                                        objectId: MoreContentType.home.rawValue)
        data.append(section1)
        
        let section2 = HomeSectionModel(title: String.thinh_hanh, identifier: "",
                                        objectId: MoreContentType.recommend.rawValue)
        data.append(section2)
        
//        let section3 = HomeSectionModel(title: "Tết 2018", identifier: "",
//                                        objectId: MoreContentType.tet2018.rawValue)
//        data.append(section3)
    }
    
    func updateWithChannels(_ data: [ChannelModel]) {
        oldList = self.data
        self.listChannel = data
        self.data = [HomeSectionModel]()
        let section1 = HomeSectionModel(title: String.de_xuat, identifier: "",
                                        objectId: MoreContentType.home.rawValue)
        self.data.append(section1)
        
        let section2 = HomeSectionModel(title: String.thinh_hanh, identifier: "",
                                        objectId: MoreContentType.recommend.rawValue)
        self.data.append(section2)
        
//        let section3 = HomeSectionModel(title: "Tết 2018", identifier: "",
//                                        objectId: MoreContentType.tet2018.rawValue)
//        self.data.append(section3)
        
        for item in data {
            self.data.append(HomeSectionModel(title: item.name,
                                              identifier: "",
                                              objectId: item.id))
        }
    }
}
