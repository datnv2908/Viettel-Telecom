//
//  MenuViewModel.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

struct MenuViewModel {
    var avatarUrl: String
    var phoneNumber: String
    var numberNotification: String
    var sections: [MenuSectionModel] = []
    var newUpdate: [NewUpdateModel] = []
    
    var listNotification: [NotificationModel] {
        set {
            mListNotification.removeAll()
            mListNotification.append(contentsOf: newValue)
            doReloadMenuData()
        }
        get {
            return mListNotification
        }
    }
    private var mListNotification: [NotificationModel] = []
    
    init() {
        if let model = DataManager.getCurrentMemberModel() {
            phoneNumber = model.getName()
        } else {
            phoneNumber =  String.dang_nhap
        }
        avatarUrl = ""
        numberNotification = ""
        doReloadMenuData()
    }
    
    func getNotification(_ index: Int)-> NotificationModel {
        return listNotification[index - 1]
    }
    
    mutating func doReloadMenuData() {
        if DataManager.isLoggedIn() {
            sections.removeAll()
            sections.append(sectionNotification(mListNotification))
            sections.append(sectionMenu)
            
            if let menu = DataManager.getDefaultSetting()?.menuCollections, menu.count > 0 {
                sections.append(sectionNewUpdate)
            }
            
            sections.append(sectionWatchLater)
            sections.append(sectionInfor)
        } else {
            sections.removeAll()
            sections.append(sectionMenu)
            
            if let menu = DataManager.getDefaultSetting()?.menuCollections, menu.count > 0 {
                sections.append(sectionNewUpdate)
            }
            
            sections.append(sectionWatchLater)
            sections.append(sectionInfor)
        }
    }
    
    private func sectionNotification(_ list: [NotificationModel])->MenuSectionModel {
        var section = MenuSectionModel()
        section.rows.append(MenuRowModel(MenuType.notificationHeader,"", #imageLiteral(resourceName: "notificationsMaterial")))
        let number = list.count > 2 ? 2 : listNotification.count
        for i in 0..<number {
            section.rows.append(MenuRowModel(MenuType.notification,""))
        }
        return section
    }
    
    private var  sectionMenu: MenuSectionModel {
        get {
            var section = MenuSectionModel()
            section.rows.append(MenuRowModel(MenuType.home, ""))
            section.rows.append(MenuRowModel(MenuType.seriesMovie, ""))
            section.rows.append(MenuRowModel(MenuType.oddMovie, ""))
            section.rows.append(MenuRowModel(MenuType.kind, ""))
            return section
        }
    }
    
    private var sectionNewUpdate: MenuSectionModel {
        get {
            var section = MenuSectionModel()
            if let setting = DataManager.getDefaultSetting() {
                for i in setting.menuCollections {
                    var menu = MenuRowModel(MenuType.newUpdate, title: i.name)
                    menu.id = i.id
                    section.rows.append(menu)
                }
            }
            return section
        }
    }
    
    private var sectionWatchLater: MenuSectionModel {
        get {
            var section = MenuSectionModel()
            section.rows.append(MenuRowModel(MenuType.watchLater, "", #imageLiteral(resourceName: "checked")))
            return section
        }
    }
    
    private var sectionInfor: MenuSectionModel {
        get {
            var section = MenuSectionModel()
            
            let setting = DataManager.getDefaultSetting()
            if (setting?.hiddenVIP != "1") {
//                section.rows.append(MenuRowModel(MenuType.charges,""))
                section.rows.append(MenuRowModel(MenuType.package, ""))
            }
            
            section.rows.append(MenuRowModel(MenuType.profile, ""))
            section.rows.append(MenuRowModel(MenuType.termCondition, ""))
            section.rows.append(MenuRowModel(MenuType.contact, ""))
            section.rows.append(MenuRowModel(MenuType.language, ""))
            
            if DataManager.getCurrentMemberModel() != nil {
                section.rows.append(MenuRowModel(MenuType.logout, ""))
            }
            return section
        }
    }
    
    struct MenuSectionModel: PBaseSectionModel {
        var title: String
        var identifier: String
        var rows: [MenuRowModel] = []
        init() {
            title = ""
            identifier = MenuTableViewCell.nibName()
            rows = [MenuRowModel]()
        }
    }
}

struct MenuRowModel: PBaseRowModel {
    var id: Int = 0
    var title: String
    var desc: String
    var imageUrl: String
    var identifier: String
    var image: UIImage?
    var menuType: MenuType
    var descFilm: String
    init(_ menuType: MenuType, _ desc: String) {
        self.title = menuType.displayString()
        self.desc = desc
        self.imageUrl = ""
        self.identifier = ""
        self.image = nil
        self.menuType = menuType
        descFilm = ""
    }
    
    init(_ menuType: MenuType, title: String) {
        self.title = title
        self.desc = ""
        self.imageUrl = ""
        self.identifier = ""
        self.image = nil
        self.menuType = menuType
        descFilm = ""
    }
    
    init(desc: String, menuType: MenuType) {
        self.title = menuType.displayString()
        self.desc = desc
        self.imageUrl = ""
        self.identifier = ""
        self.image = #imageLiteral(resourceName: "icHome")
        self.menuType = menuType
        descFilm = ""
    }
    
    init(_ menuType: MenuType, _ desc: String, _ image: UIImage) {
        self.title = menuType.displayString()
        self.desc = desc
        self.imageUrl = ""
        self.identifier = ""
        self.menuType = menuType
        self.image = image
        descFilm = ""
    }
}
