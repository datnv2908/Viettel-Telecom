//
//  SetupViewModel.swift
//  5dmax
//
//  Created by Admin on 3/15/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

struct SetupViewModel {

    var cellModels: [[SetupCellModel]]

    var numberOfSection: Int {
        return 4
    }

    init() {
        cellModels = [[SetupCellModel]]()
        let headerSection = [SetupCellModel]()
        //Section Tài khoản
        var accountSection = [SetupCellModel]()
        
        let setting = DataManager.getDefaultSetting()
        if (setting?.hiddenVIP != "1") {
            accountSection.append(SetupCellModel(.pay))
        }
        
        accountSection.append(SetupCellModel(.password))
        if DataManager.boolForKey(Constants.kLoginFacebook) {
            accountSection.append(SetupCellModel(.facebook))
        }
        //Section Thiết lập
        var settingSection = [SetupCellModel]()
        settingSection.append(SetupCellModel(.quality))
        settingSection.append(SetupCellModel(.content))

        //Section Thông tin
        var infoSection = [SetupCellModel]()
//        infoSection.append(SetupCellModel(.help))
//        infoSection.append(SetupCellModel(.service))
        infoSection.append(SetupCellModel(.security))

        cellModels.append(headerSection)
        cellModels.append(accountSection)
        cellModels.append(settingSection)
        cellModels.append(infoSection)
    }

    func user() -> MemberModel? {

        return DataManager.getCurrentMemberModel()
    }

    func sectionHeaderTitle(section: Int) -> String {
        switch section {
        case 0:
            return ""
        case 1:
            return String.tai_khoan
        case 2:
            return String.thiet_lap
        case 3:
            return String.thong_tin
        default:
            return ""
        }
    }

    func numberOfRow(section: Int) -> Int {
        return self.cellModels[section].count
    }

    func cellModel(at indexPath: IndexPath) -> SetupCellModel {
        return self.cellModels[indexPath.section][indexPath.row]
    }

}
