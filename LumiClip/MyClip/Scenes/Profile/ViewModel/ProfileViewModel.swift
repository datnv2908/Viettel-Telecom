//
//  ProfileViewModel.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
struct ProfileViewModel {
    var sections = [SectionModel]()
    
    init() {
        var rows = [ProfileRowModel]()
        var values = [ProfileTypeEnum]()
        if DataManager.isLoggedIn() {
         values = [.pakage, .bankInfor, .myEarning, .myList, .watchRecently, .watchLater, .playlist,
                      .settings, .present, .privacy, .contact, .changePassword,.manageComment, .logout]
            let headerModel = HeaderModel(title: "personal", identifier: ProfileHeaderPersonal.nibName())
         
            for item in values {
                rows.append(ProfileRowModel(type: item))
            }
            let sectionModel = SectionModel(rows: rows, header: headerModel)
            sections = [sectionModel]
        } else {
            values = [.download, .pakage, .settings, .privacy, .contact]
            let headerModel = HeaderModel(title: "login", identifier: ProfileHeaderLogin.nibName())
            for item in values {
                rows.append(ProfileRowModel(type: item))
            }
            let sectionModel = SectionModel(rows: rows, header: headerModel)
            sections = [sectionModel]
        }
    }
}
