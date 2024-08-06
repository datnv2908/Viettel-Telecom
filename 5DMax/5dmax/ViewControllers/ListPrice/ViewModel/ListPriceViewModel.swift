//
//  ListPriceViewModel.swift
//  5dmax
//
//  Created by Hoang on 3/23/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

class ListPriceViewModel: NSObject {

    let title: String = String.dang_ky_vip
    var listPackage: [PackageModel] = []
    var selectedPackage: PackageModel?
    var emptyPackage = PackageModel()
    var isConfirmSMS: Bool = false
    var isRegisterFast: Bool = false
    let numberSection: Int = 2
    let purchase: PackageModel = PackageModel.defaultPackeage()

    override init() {
        emptyPackage.name = "\(String.luu_y):"
        emptyPackage.desc = String.luu_luong_data_duoc_cong_them
    }

    func getNumberRowInSection(_ section: Int) -> Int {
        if section == 0 {
            return listPackage.count
        }
        return 1

    }
    
    func getPackageAtIndexPath(_ indexPath: IndexPath) -> PackageModel {
        if indexPath.section == 0 {
            return listPackage[indexPath.row]
        }
        return purchase
    }

    func getTitleSection(_ section: Int) -> String {
        return String.danh_sach_goi_cuoc
    }

    func performUpdateListPackage(list: [PackageModel], isConfirmSMS: Bool, isRegisterFast: Bool) {
        listPackage = []
        selectedPackage = nil
        for item in list {
            if item.status {
                selectedPackage = item
                listPackage.insert(item, at: 0)
            } else {
                listPackage.append(item)
            }
        }
        self.isConfirmSMS = isConfirmSMS
        self.isRegisterFast = isRegisterFast

        // insert empty package model if there is no package
        if listPackage.isEmpty {
            listPackage.append(emptyPackage)
        }
    }
}
