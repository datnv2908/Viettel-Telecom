//
//  AppEnum.swift
//  5dmax
//
//  Created by Huy Nguyen on 3/13/17.
//  Copyright © 2017 Huy Nguyen. All rights reserved.
//

import Foundation
import UIKit

enum GroupType: String, Codable {

    case filmFree
    case filmCategoryGroup
    case filmHot
    case filmRecommend
    case filmNew
    case filmNational
    case filmYear
    case myList
    case filmHistoryView
    case historyTransaction
    case filmRetail

    func idStringValue() -> String {
        switch self {
        case .filmFree:
            return "film_free"
        case .filmCategoryGroup:
            return "category_group_"
        case .filmHot:
            return "FILM_HOT_TOPIC"
        case .filmRecommend:
            return "film_recommend"
        case .filmNew:
            return "film_new"
        case .filmNational:
            return "film_info_"
        case .filmYear:
            return "film_year_"
        case .myList:
            return "mylist"
        case .filmHistoryView:
            return "film_history"
        case .historyTransaction:
            return "transaction"
        case .filmRetail:
            return "film_retail"
        }
    }

    func name() -> String {
        switch self {
        case .filmFree:
            return String.phim_mien_phi
        case .filmCategoryGroup:
            return String.phim_theo_the_loai
        case .filmHot:
            return String.phim_hot
        case .filmRecommend:
            return String.phim_de_cu
        case .filmNew:
            return String.phim_moi
        case .filmNational:
            return String.phim_theo_quoc_gia_dien_vien_dao_dien
        case .filmYear:
            return String.phim_loc_theo_nam
        case .myList:
            return String.phim_cua_toi
        case .filmHistoryView:
            return String.phim_da_xem
        case .historyTransaction:
            return String.lich_su_giao_dich_thue_bao
        case .filmRetail:
            return String.phim_co_phi
        }
    }
}

  enum ContentType: String, Codable {
    case film = "FILM" // it means film retail
    case vod  = "VOD"
    case game  = "GAME"
    case trailer = "TRAILER"
    case trailerUpdate = "TRAILER_UPDATE"// it means film series with watching part
    case relatedUpdate = "RELATED_UPDATE"
    case series = "film_series"
    case collection = "COLLECTION"
    case category = "CATEGORY"
}

enum FilmInfoType: Int {
    case nation = 0
    case actor = 1
    case director = 2
}

enum FilmDetailSection: Int {
    case cover = 0
    case info = 1
    case related = 2
    case trailer = 3
    static var count = FilmDetailSection.related.rawValue + 1
}

enum HomeType {
    case normalHome
    case oddFilm
    case seariesFilm
    
}
enum MenuType {
    case notificationHeader
    case notification
    case home
    case oddMovie
    case seriesMovie
    case charges
    case kind
    case newUpdate
    case download
    case watchLater
    case package
    case language
    case termCondition
    case contact
    case profile
    case logout

    func displayString() -> String {
        switch self {
        case .notificationHeader:
            return String.thong_bao
        case .notification:
            return ""
        case .home:
            return String.trang_chu
        case .charges:
            return String.phim_co_phi
        case .kind:
            return String.the_loai
        case .watchLater:
            return String.xem_sau
        case .download:
            return String.download
        case .package:
            return String.dang_ky_vip
        case .newUpdate:
            return String.moi_cap_nhat
        case .profile:
            return String.tai_khoan
        case .termCondition:
            return String.dieu_khoan
        case .language:
            return String.ngon_ngu
        case .contact:
            return String.ho_tro
        case .logout:
            return String.dang_xuat
        case .oddMovie :
            return String.odd_Movie
        case .seriesMovie :
            return String.series_Movie
        }
    }
}

enum GrantType {
    case autoLogin
    case login
    case loginSocial
    case refreshToken

    func stringValue() -> String {
        switch self {
        case .autoLogin:
            return "auto_login"
        case .login:
            return "login"
        case .loginSocial:
            return "login-social"
        case .refreshToken:
            return "refresh_token"
        }
    }
}

enum OSType {
    case android
    case iOS

    func stringValue() -> String {
        switch self {
        case .android:
            return "ANDROID"
        case .iOS:
            return "IOS"
        }
    }
}

enum AccountFieldType {
    case text
    case phone
    case email
    case password
    case button
    case buttonLink
    case none
}

enum SetupCellType {
    case account
    case pay
    case facebook
    case password
    case quality
    case content
    case help
    case service
    case security
    case version

    func stringValue() -> String {
        switch self {
        case .account:
            return String.tai_khoan
        case .pay:
            return String.quan_ly_goi_cuoc
        case .facebook:
            return String.facebook
        case .password:
            return String.doi_mat_khau
        case .quality:
            return String.chat_luong
        case .content:
            return String.quan_ly_noi_dung
        case .help:
            return String.tro_giup
        case .service:
            return String.dieu_khoan_dich_vu
        case .security:
            return String.chinh_sach_bao_mat
        case .version:
            return String.phien_ban
        }
    }

    func viewcontroller() -> UIViewController? {
        switch self {

        case .account:
            return AccountViewController.initWithNib()
        case .pay:
            return PackofDataViewController.initWithNib()
        case .facebook:
            return nil
        case .password:
            return ChangePassViewController.initWithNib()
        case .quality:
            return QualityViewController.initWithDefautlStoryboard()
        case .content:
            return nil
        case .help:
            let setting = DataManager.getDefaultSetting()
            let htmlContent = setting?.getHTMLWithType(contenType: .contact)
            let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.tro_giup)
            return viewController
        case .service:
            let setting = DataManager.getDefaultSetting()
            let htmlContent = setting?.getHTMLWithType(contenType: .termCondition)
            let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.dieu_khoan_dich_vu)
            return viewController
        case .security:
            let setting = DataManager.getDefaultSetting()
            let htmlContent = setting?.getHTMLWithType(contenType: .privacy)
            let viewController = ViewHTMLViewController.initWithHTML(html: htmlContent, title: String.chinh_sach_bao_mat)
            return viewController
        case .version:
            return nil
        }
    }
}

enum APIErrorCode: Int {
    case success        = 200
    case fail           = 201
    case invalidToken1  = 401
    case invalidToken   = 403
    case notExist       = 404
    case needMapNumber  = 440
    case notRegisted    = 900
    case downgrade      = 909
    case needCaptcha    = 800
    case invalidCaptcha = 808
    case userInactive   = 888
    case unknow         = 99999
}

enum LoginType {

    case facebook
    case email
    case mobile3G
    case OTP

    func stringValue() -> String {
        switch self {
        case .facebook:
            return "facebook"
        default:
            return ""
        }
    }
}

enum HTMLContentType: String {
    case termCondition = "term-condition"
    case intro = "intro"
    case contact = "contact"
    case privacy = "privacy"
    case summary = "summary"
    case unknow = "unknow"
}

typealias SelectQualityBlock = (_ quality: QualityModel) -> (Void)

enum FilmType: String {
    case retail = "1" // film by category
    case series = "0" // film by nation
    func stringValue() -> String {
        switch self {
        case .retail:
            return String.the_loai
        case .series:
            return String.phim_bo
        }
    }
}

enum NotificationAction: String {
    case detail = "DETAIL"
    case message = "MESSAGE"
}

enum MyList: Int {
    case later = 0
    case history = 1
    func description() -> String {
        switch self {
        case .later:
            return String.xem_sau.uppercased()
        case .history:
            return String.dang_xem.uppercased()
        }
    }
}

enum FilmCostType: Int {
    case typeFree = 0
    case typeRent = 1
    case typeMonth = 2
    case unknow = -1
    
    static func typeWithInt(_ number: Int)-> FilmCostType {
        if number == 0 {
            return typeFree
        }
        
        if number == 1 {
            return typeRent
        }
        
        if number == 2 {
            return typeMonth
        }
        return unknow
    }
}

enum LocalNotificationType {
    case stopPlayTrailer
    
    var value: String {
        return "stopPlayTrailer"
    }
}

