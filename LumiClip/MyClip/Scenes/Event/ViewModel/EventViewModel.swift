//
//  EventViewModel.swift
//  MyClip
//
//  Created by Manh Hoang Xuan on 5/24/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

class EventViewModel: NSObject {
    var sections: [EventSectionModel]
    var eventConfigModel: EventConfigModel
    override init() {
        sections = [EventSectionModel]()
        eventConfigModel = EventConfigModel()
        let section1 = EventSectionModel(title: String.su_kien.uppercased(), identifier: "", objectId: "event")
        sections.append(section1)
        
        let section2 = EventSectionModel(title: String.diem_cua_toi.uppercased(), identifier: "", objectId: "diemcuatoi")
        sections.append(section2)
        
        let section3 = EventSectionModel(title: String.the_le.uppercased(), identifier: "", objectId: "thele")
        sections.append(section3)
        
        let section4 = EventSectionModel(title: String.giai_thuong.uppercased(), identifier: "", objectId: "giaithuong")
        sections.append(section4)
    }
}
