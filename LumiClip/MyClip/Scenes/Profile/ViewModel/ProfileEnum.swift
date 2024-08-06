//
//  PersonalEnum.swift
//  MyClip
//
//  Created by Quang Ly Hoang on 9/7/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import UIKit

enum ProfileType {
    case login
    case personal
}

enum ProfileTypeEnum: Int {
    case myList = 0
    case pakage
    case myEarning
    case bankInfor
    case watchRecently
    case watchLater
    case playlist
    case settings
    case present
    case privacy
    case contact
    case changePassword
    case logout
    case download
    case manageComment
    func title() -> String {
        switch self {
        case .myList:
            return String.video_cua_toi
        case .myEarning:
            return String.thu_nhap
        case .bankInfor:
            return String.dang_ky_nhan_tien
        case .download:
            return String.video_tai_xuong
        case .pakage:
            return String.goi
        case .watchRecently:
            return String.xem_gan_day
        case .watchLater:
            return String.xem_sau
        case .playlist:
            return String.danh_sach_phat
        case .settings:
            return String.cai_dat
        case .present:
            return String.gioi_thieu
        case .privacy:
            return String.dieu_khoan_va_chinh_sach_bao_mat
        case .contact:
            return String.lien_he
        case .changePassword:
            return String.doi_mat_khau
        case .logout:
            return String.dang_xuat
        case .manageComment :
         return String.manage_Comment
        }
    }
    
    func open() -> Bool {
        switch self {
        case .myList:
            return false
        case .myEarning:
            return false
        case .bankInfor:
            return false
        case .download:
            return true
        case .pakage:
            return false
        case .watchRecently:
            return false
        case .watchLater:
            return false
        case .playlist:
            return false
        case .settings:
            return true
        case .present:
            return true
        case .privacy:
            return true
        case .contact:
            return true
        case .changePassword:
            return false
        case .logout:
            return false
        case .manageComment :
            return false
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .myList:
            return #imageLiteral(resourceName: "iconVideo")
        case .myEarning:
            return #imageLiteral(resourceName: "iconThuNhap")
        case .bankInfor:
            return #imageLiteral(resourceName: "iconBankInfor")
        case .download:
            return #imageLiteral(resourceName: "iconDownload")
        case .pakage:
            return #imageLiteral(resourceName: "iconGoiCuoc")
        case .watchRecently:
            return #imageLiteral(resourceName: "icXemGanDay")
        case .watchLater:
            return #imageLiteral(resourceName: "icXemSau")
        case .playlist:
            return #imageLiteral(resourceName: "iconPlaylist")
        case .settings:
            return #imageLiteral(resourceName: "iconSetting")
        case .present:
            return #imageLiteral(resourceName: "iconGioiThieu")
        case .privacy:
            return #imageLiteral(resourceName: "iconLocked")
        case .contact:
            return #imageLiteral(resourceName: "iconLienHe")
        case .changePassword:
            return #imageLiteral(resourceName: "ic_change_password")
        case .logout:
            return #imageLiteral(resourceName: "iconLogout")
        case .manageComment:
            return #imageLiteral(resourceName: "MangerCommentIcon.png")
        }
    }
}


