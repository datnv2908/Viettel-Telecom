//
//  TrailersDTO.swift
//  5dmax
//
//  Created by admin on 8/23/18.
//  Copyright © 2018 Huy Nguyen. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrailersDTO: NSObject {
    var id: String
    var idPlaylist: String
    var name:String
    var slug: String
    var duration: String
    var descriptionTrailer: String
    var coverImage: String
    
    init(_ json: JSON) {
        id = json["id"].stringValue
        idPlaylist = json["idPlaylist"].stringValue
        name = json["name"].stringValue
        slug = json["slug"].stringValue
        duration = json["duration"].stringValue
        descriptionTrailer = json["description"].stringValue
        coverImage = json["coverImage"].stringValue
    }
}

/*
 "id": "12482",
 "idPlaylist": "7611",
 "name": "Giáng sinh hoàn hảo (Thuyết minh) - A perfect Christmas - Phần 6",
 "slug": "giang-sinh-hoan-hao-thuyet-minh-a-perfect-christmas-phan-6-joqogpcf",
 "duration": "769",
 "description": "Holly Maddux là một nữ thiết kế nội thất tham vọng. Tiếng sét ái tình giáng xuống khi cô tình cờ gặp một người đàn ông lạ mặt đẹp trai và hai người nhanh chóng trao nhau nụ hôn lãng mạn ngay trong thang máy. Tuy nhiên, không lâu sau cô phát hiện ra anh ta chính là người bạn trai giàu có của vị sếp ghê gớm và độc đoán của cô.",
 "coverImage": "http://static2.myclip.vn/5602ed243212e7bd8fabf779ad4cdbc11535000961/image1/2017/03/02/17/8bab7660/8bab7660-fe60-4072-9acb-177b8ac19ad1_640_360.jpg"
 */
